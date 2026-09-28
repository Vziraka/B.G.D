const el = id => document.getElementById(id);
const canvas = el('camera'), ctx = canvas.getContext('2d');
const token = document.querySelector('meta[name="session-token"]').content;
function expandVideo(expanded) {
  el('view').classList.toggle('expanded', expanded);
  el('expand').setAttribute('aria-expanded', String(expanded));
  el('expand').textContent=expanded?'Return to controls':'Expand video';
  document.body.classList.toggle('video-expanded', expanded);
}
el('expand').onclick=()=>expandVideo(!el('view').classList.contains('expanded'));
document.addEventListener('keydown',event=>{
  if(event.key==='Escape') expandVideo(false);
});
const tasks={track:'Test tools',verify:'Face setup',command:'Conversation'};
function showTask(name) {
  for(const task of Object.keys(tasks)) {
    const active=task===name;
    el(`panel-${task}`).hidden=!active; el(`tab-${task}`).classList.toggle('active',active);
    el(`tab-${task}`).setAttribute('aria-selected',String(active));
  }
  el('task-title').textContent=tasks[name];
}
for(const task of Object.keys(tasks)) el(`tab-${task}`).onclick=()=>showTask(task);
showTask('command');
let sequence = 0, latest = null, lastGood = performance.now(), uiKey = '';
let actionError = '', actionErrorUntil = 0;
let objectDetections = [], objectDetectionsUntil = 0;
let missionPrompt = null, missionPromptUntil = 0;
let pendingProposal=null, proposalTimer=null, conversationEpoch=0;
let spokenState='',spokenAt=0;
let objectSelectionMode=false, objectSelectionDraft=null, suppressCanvasClickUntil=0;
let facePassed = null, livenessPassed = null;
let faceRange=null, faceRangeTimer=null, faceRangeBusy=false, faceRangeAt=0;
let times = [], delays = [], reportedAt = performance.now();
let presentationEpoch = 0;
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
const paint = () => new Promise(resolve => requestAnimationFrame(resolve));
function showObjectGuide(stage, views=0) {
  const guide=el('object-capture-guide');
  if(!stage) { guide.hidden=true; return; }
  const copy={
    center:['STEP 1 OF 3','Center one object','Put the complete object inside the blue guide, hold it still, then say “follow this object” again.'],
    hold:['STEP 2 OF 3','Hold it still','Keep the object centered, then say “follow this object” again.'],
    scanning:['SCANNING','Keep holding still','The Pi is learning the first view. Wait for the purple tracking box.'],
    learning:['STEP 3 OF 3',`Target locked · ${views}/4 views`,`Now move slowly and show another side. You can stop after 2–4 learned views.`],
    searching:['SEARCHING','Target temporarily lost','Keep the camera view clear. The desk checks nearby first, then the full frame.'],
    lost:['NOT FOUND','Target lost safely','Return to the first step and scan the object again.'],
  }[stage];
  guide.hidden=false; guide.dataset.stage=stage;
  el('object-guide-step').textContent=copy[0]; el('object-guide-title').textContent=copy[1]; el('object-guide-detail').textContent=copy[2];
  const active=stage==='center'?0:stage==='hold'||stage==='scanning'?1:2;
  ['capture-center','capture-hold','capture-learn'].forEach((id,index)=>{
    el(id).classList.toggle('done',index<active || (stage==='learning' && index===active));
    el(id).classList.toggle('active',index===active && stage!=='lost' && stage!=='searching');
  });
}
function interrupted(message) {
  presentationEpoch++;
  objectDetections=[]; objectDetectionsUntil=0;
  missionPrompt=null; missionPromptUntil=0;
  latest=null; ctx.fillStyle='#10171e'; ctx.fillRect(0,0,canvas.width,canvas.height);
  el('camera-live-label').textContent='WAITING FOR VIDEO';el('camera-badge').classList.toggle('offline',true);
  el('connection-status').textContent='Reconnecting'; el('connection-status').classList.toggle('disconnected',true);
  el('notice').textContent=message; el('state').textContent='Connection interrupted';
  el('state').className='lost'; el('reason').textContent='Waiting for fresh camera and tracking data.';
  el('people').replaceChildren(); uiKey=''; delete el('people').dataset.ready;
  el('display').textContent='—'; el('delay').textContent='—';
}
async function post(path, data, timeout=3000) {
  const response = await fetch(path, {method:'POST', headers:{'Content-Type':'application/json','X-Session-Token':token}, body:JSON.stringify(data), signal:AbortSignal.timeout(timeout)});
  const result = await response.json();
  if (!response.ok) throw new Error(result.error);
  return result;
}
async function postAudio(blob, proposalId, signal) {
  const response = await fetch('/speech/transcribe', {method:'POST', headers:{'Content-Type':blob.type || 'audio/webm','X-Session-Token':token,'X-Proposal-Id':proposalId || ''}, body:blob, signal});
  const result = await response.json();
  if (!response.ok) throw new Error(result.error);
  return result;
}
async function select(id) {
  replaceConversationIntent();
  try { renderInfo(await post('/select',{id})); actionError=''; el('notice').textContent = ''; }
  catch (error) { actionError=error.message; actionErrorUntil=performance.now()+4000; el('notice').textContent = actionError; }
}
el('clear').onclick = async () => { replaceConversationIntent();try { await post('/clear',{}); } catch(e) { el('notice').textContent=e.message; } };
el('object-select').onclick=()=>{
  objectSelectionMode=true; objectSelectionDraft=null; canvas.style.cursor='crosshair';
  el('object-select-state').textContent='Drag a snug box around one object in the camera.';
};
el('object-clear').onclick=async()=>{
  replaceConversationIntent();
  try { await post('/object/clear',{}); objectSelectionMode=false; objectSelectionDraft=null; canvas.style.cursor=''; }
  catch(error) { el('notice').textContent=error.message; }
};
el('enrollment-start').onclick = async () => { try { resetVerification(); renderInfo(await post('/enrollment/start',{})); } catch(e) { el('notice').textContent=e.message; } };
el('enrollment-cancel').onclick = async () => { try { resetVerification(); renderInfo(await post('/enrollment/cancel',{})); } catch(e) { el('notice').textContent=e.message; } };
function resetVerification() {
  facePassed=null; livenessPassed=null;
  el('face-status').className='verification-card pending'; el('face-state').textContent='Not checked';
  el('liveness-status').className='verification-card pending'; el('liveness-state').textContent='Not tested';
  el('face-result').textContent='Run Verify face after enrollment.';
  el('liveness-result').textContent='Liveness has not been checked.';
  updateCombined();
}
function updateCombined() {
  const card=el('verification-status'), result=card.querySelector('strong');
  if(facePassed===false || livenessPassed===false) { card.className='verification-card failed'; result.textContent='Diagnostic failed'; }
  else if(facePassed && livenessPassed) { card.className='verification-card passed'; result.textContent='Diagnostic checks passed'; }
  else { card.className='verification-card blocked'; result.textContent=facePassed?'Waiting for liveness':livenessPassed?'Waiting for face match':'Verification incomplete'; }
}
function showFaceResult(result) {
  facePassed=result.passed;
  el('face-status').className=`verification-card ${result.passed?'passed':'failed'}`;
  el('face-state').textContent=result.passed?'Passed':'Not a match';
  el('face-result').textContent=`Face scores ${result.minimum.toFixed(3)}–${result.maximum.toFixed(3)} · median ${result.median.toFixed(3)} · threshold ${result.threshold.toFixed(3)}.`;
  updateCombined();
}
function showLivenessResult(result) {
  livenessPassed=result.passed;
  el('liveness-status').className=`verification-card ${result.passed?'passed':'failed'}`;
  el('liveness-state').textContent=result.passed?'Passed':'Possible spoof';
  el('liveness-result').textContent=`${result.real_labels} of ${result.frames} frames labeled real · probability ${result.minimum.toFixed(4)}–${result.maximum.toFixed(4)} · median ${result.median.toFixed(4)}.`;
  updateCombined();
}
el('face-check').onclick = async () => {
  try {
    el('face-status').className='verification-card checking'; el('face-state').textContent='Checking…';
    const result=await post('/face/check',{});
    showFaceResult(result);
  } catch(e) { resetVerification(); el('face-result').textContent=e.message; }
};
el('liveness-check').onclick = async () => {
  try {
    el('liveness-status').className='verification-card checking'; el('liveness-state').textContent='Checking…';
    showLivenessResult(await post('/liveness/check',{},10000));
  } catch(e) { livenessPassed=null; el('liveness-status').className='verification-card failed'; el('liveness-state').textContent='Check failed'; el('liveness-result').textContent=e.message; updateCombined(); }
};
function showMissionResult(mission) {
  const resultEl=el('command-result'), steps=el('command-steps');
  resultEl.textContent=`${mission.status.replaceAll('_',' ')} · ${mission.message} · ${mission.authority}`;
  steps.replaceChildren();
  for(const step of mission.interpretation?.steps || []) {
    const item=document.createElement('li');
    item.textContent=step.target?`${step.action}: ${step.target}`:step.action;
    steps.append(item);
  }
  const block=el('command-observation-block'), observations=el('command-observations');
  observations.replaceChildren();
  for(const observation of mission.observations || []) {
    const item=document.createElement('li'); item.textContent=`${observation.action}: ${observation.message}`;
    item.className=observation.status; observations.append(item);
  }
  block.hidden=!(mission.observations || []).length;
  objectDetections=mission.detections || [];
  objectDetectionsUntil=objectDetections.length?performance.now()+3000:0;
  missionPrompt=mission.prompt || null;
  missionPromptUntil=missionPrompt?performance.now()+(missionPrompt.expires_in_s || 20)*1000:0;
  if(missionPrompt?.kind==='center_target') showObjectGuide('center');
  else if(mission.status==='stopped') showObjectGuide(null);
}
function say(message) {
  if(speechRecorder || speechAcquiring) return;
  if(!el('spoken-feedback').checked || typeof speechSynthesis==='undefined' || typeof SpeechSynthesisUtterance==='undefined') return;
  const voice=speechSynthesis.getVoices().find(v=>v.localService && v.lang.startsWith('en'));
  if(!voice) return;
  speechSynthesis.cancel(); const utterance=new SpeechSynthesisUtterance(message);
  utterance.voice=voice; speechSynthesis.speak(utterance);
}
function message(role,text) {
  const article=document.createElement('article'); article.className=`message ${role}`;
  const author=document.createElement('span'); author.className='message-author'; author.textContent=role==='user'?'YOU':'B.G.D';
  const body=document.createElement('p'); body.textContent=text;
  article.append(author,body); const log=el('conversation-log'); log.append(article);
  while(log.children?.length>30) log.firstElementChild.remove();
  log.scrollTop=log.scrollHeight;
}
function clearProposal() {
  pendingProposal=null; clearTimeout(proposalTimer); el('proposal-card').hidden=true; el('confirm-mission').disabled=false;
}
function replaceConversationIntent() {
  ++conversationEpoch; clearProposal(); stopSpeech(true);
}
function receiveConversation(result) {
  if(result.status==='superseded') return;
  clearProposal(); message('assistant',result.message || 'Request received.'); say(result.message || 'Request received.');
  const restored=result.status==='status' && result.pending_proposal?.status==='confirmation_required'
    ? result.pending_proposal : null;
  const proposal=result.status==='confirmation_required' && result.proposal_id?result:restored;
  if(proposal) {
    pendingProposal=proposal.proposal_id; el('proposal-card').hidden=false; el('confirm-mission').disabled=false;
    el('proposal-title').textContent=proposal.command;
    el('proposal-detail').textContent='Camera test only. Check the target and action before confirming.';
    el('proposal-expiry').textContent=`Say yes, confirm below, or send a correction. Expires in ${Math.ceil(proposal.expires_in)} seconds.`;
    proposalTimer=setTimeout(()=>{clearProposal();message('assistant','That proposal expired. Send the request again when ready.');},proposal.expires_in*1000);
  }
  showMissionResult(result);
}
async function sendConversation(text) {
  stopSpeech(true);
  const epoch=++conversationEpoch; const proposalId=pendingProposal;
  if(proposalId) {
    el('confirm-mission').disabled=true;
    el('proposal-detail').textContent='A new request is being checked. This exact proposal cannot be confirmed until it finishes.';
  }
  message('user',text); el('command-text').value=''; el('speech-status').textContent='Understanding your request…';
  try {
    const result=await post('/conversation',{text,proposal_id:proposalId},35000);
    if(epoch===conversationEpoch) {receiveConversation(result);el('speech-status').textContent='Ready for your next request.';}
  } catch(e) {if(epoch===conversationEpoch){message('assistant',e.message);if(pendingProposal){clearProposal();message('assistant','I could not verify whether the earlier proposal is still current. Ask for status before confirming anything.');}el('speech-status').textContent='Request did not complete. You can try again.';}}
}
el('command-form').onsubmit=event=>{event.preventDefault();const text=el('command-text').value.trim();if(text)sendConversation(text);};
for(const button of document.querySelectorAll?.('[data-command]') || []) button.onclick=()=>sendConversation(button.dataset.command);
el('confirm-mission').onclick=async()=>{
  stopSpeech(true);
  const id=pendingProposal;if(!id || el('confirm-mission').disabled)return;const epoch=++conversationEpoch;clearProposal();message('user','Yes, confirm that task.');
  try {const result=await post('/conversation/confirm',{proposal_id:id},35000);if(epoch===conversationEpoch)receiveConversation(result);}
  catch(e){if(epoch===conversationEpoch)message('assistant',e.message);}
};
el('cancel-mission').onclick=async()=>{stopSpeech(true);const epoch=++conversationEpoch;clearProposal();try{const result=await post('/conversation/cancel',{});if(epoch===conversationEpoch)receiveConversation(result);}catch(e){if(epoch===conversationEpoch)message('assistant',e.message);}};
el('stop-all').onclick=async()=>{
  const epoch=++conversationEpoch;clearProposal();stopSpeech(true);if(typeof speechSynthesis!=='undefined')speechSynthesis.cancel();
  try{const result=await post('/conversation',{text:'stop',proposal_id:null});if(epoch===conversationEpoch){receiveConversation(result);el('speech-status').textContent='Stopped. Ready when you are.';}}
  catch(e){if(epoch===conversationEpoch)message('assistant',`Stop could not be confirmed: ${e.message}`);}
};
el('object-category-details').ontoggle=async event=>{
  const list=el('object-category-list');
  if(!event.target.open || list.dataset.loaded) return;
  try {
    const result=await post('/object/categories',{});
    list.textContent=result.categories.length?result.categories.join(', '):'The detector is still starting. Close and reopen this list.';
    if(result.categories.length) list.dataset.loaded='yes';
  } catch(error) { list.textContent=error.message; }
};
function showFaceRange(result) {
  faceRange=result; const card=el('face-range-card');
  card.className=`range-guide ${result.quality}`;
  el('face-range-state').textContent=result.quality==='good'?'Reliable':result.quality==='marginal'?'Marginal':'Not reliable';
  el('face-range-detail').textContent=result.message;
  el('face-range-distance').textContent=result.estimated_distance_m===undefined?'—':`≈ ${result.estimated_distance_m.toFixed(1)} m`;
}
async function updateFaceRange() {
  if(faceRangeBusy || !faceRangeTimer) return;
  const timer=faceRangeTimer, started=performance.now();
  faceRangeBusy=true;
  try {
    const result=await post('/range/estimate-face',{},3000);
    if(faceRangeTimer!==timer) return;
    faceRangeAt=started;
    showFaceRange(result);
  }
  catch(error) { if(faceRangeTimer===timer)showFaceRange({quality:'poor',message:error.message}); }
  finally { faceRangeBusy=false; }
}
el('face-range-start').onclick=()=>{
  if(faceRangeTimer) return;
  el('face-range-start').disabled=true; el('face-range-stop').disabled=false;
  faceRangeTimer=setInterval(updateFaceRange,800); updateFaceRange();
};
el('face-range-stop').onclick=()=>{
  clearInterval(faceRangeTimer); faceRangeTimer=null; faceRange=null;
  el('face-range-start').disabled=false; el('face-range-stop').disabled=true;
  el('face-range-card').className='range-guide idle'; el('face-range-state').textContent='Guide stopped';
  el('face-range-detail').textContent='Start after temporary face enrollment.'; el('face-range-distance').textContent='—';
};
let objectRangeTimer=null, objectRangeBusy=false;
function showObjectRange(result) {
  const card=el('object-range-card'); card.className=`range-guide ${result.quality}`;
  el('object-range-state').textContent=result.quality==='good'?'Tracking reliably':result.quality==='marginal'?'Searching':'Not reliable';
  el('object-range-detail').textContent=result.message;
  el('object-range-distance').textContent=result.estimated_distance_m===undefined?'—':`≈ ${result.estimated_distance_m.toFixed(1)} m`;
}
async function updateObjectRange() {
  if(objectRangeBusy || !objectRangeTimer) return;
  objectRangeBusy=true;
  try { showObjectRange(await post('/range/estimate-object',{},3000)); }
  catch(error) { showObjectRange({quality:'poor',message:error.message}); }
  finally { objectRangeBusy=false; }
}
el('object-range-start').onclick=async()=>{
  if(objectRangeTimer) return;
  try {
    showObjectRange(await post('/range/calibrate-object',{},5000));
    el('object-range-start').disabled=true; el('object-range-stop').disabled=false;
    objectRangeTimer=setInterval(updateObjectRange,800);
  } catch(error) { showObjectRange({quality:'poor',message:error.message}); }
};
el('object-range-stop').onclick=()=>{
  clearInterval(objectRangeTimer); objectRangeTimer=null;
  el('object-range-start').disabled=false; el('object-range-stop').disabled=true;
  el('object-range-card').className='range-guide idle'; el('object-range-state').textContent='Guide stopped';
  el('object-range-detail').textContent='Use one opaque, high-contrast object facing the camera.'; el('object-range-distance').textContent='—';
};
let speechRecorder=null, speechTimer=null, discardSpeech=false, speechAcquiring=false, speechRequestController=null;
function stopSpeech(discard=false) {
  if(discard && speechRequestController) {
    speechRequestController.abort(); speechRequestController=null;
    el('speech-record').disabled=false;
  }
  if(!speechRecorder || speechRecorder.state==='inactive') return;
  discardSpeech=discard; clearTimeout(speechTimer); el('speech-record').disabled=true; speechRecorder.stop();
}
el('speech-record').onclick = async () => {
  if(speechRecorder && speechRecorder.state==='recording') { stopSpeech(); return; }
  const button=el('speech-record'), status=el('speech-status');
  if(button.disabled) return;
  const proposalAtStart=pendingProposal, speechEpoch=++conversationEpoch;
  let stream;
  button.disabled=true;speechAcquiring=true;
  try {
    if(!navigator.mediaDevices?.getUserMedia || !window.MediaRecorder) throw new Error('This browser does not support microphone recording.');
    if(typeof speechSynthesis!=='undefined')speechSynthesis.cancel();
    stream=await navigator.mediaDevices.getUserMedia({audio:true});
    speechAcquiring=false;
    if(speechEpoch!==conversationEpoch || document.hidden) {stream.getTracks().forEach(track=>track.stop());button.disabled=false;return;}
    const type=['audio/webm;codecs=opus','audio/mp4','audio/ogg;codecs=opus'].find(value=>MediaRecorder.isTypeSupported(value));
    const recorder=type?new MediaRecorder(stream,{mimeType:type}):new MediaRecorder(stream);
    speechRecorder=recorder; const chunks=[]; discardSpeech=false;
    recorder.ondataavailable=event=>{ if(event.data.size) chunks.push(event.data); };
    recorder.onstop=async () => {
      clearTimeout(speechTimer); stream.getTracks().forEach(track=>track.stop());
      const discard=discardSpeech, blob=new Blob(chunks,{type:recorder.mimeType});
      speechRecorder=null; button.textContent='Start speaking'; button.disabled=false;
      if(discard || speechEpoch!==conversationEpoch) return;
      const requestController=new AbortController(), requestTimer=setTimeout(()=>requestController.abort(),60000);
      speechRequestController=requestController;
      try {
        button.disabled=true;
        if(missionPrompt?.kind==='center_target') { missionPrompt.phase='scanning'; showObjectGuide('scanning'); }
        status.textContent=missionPrompt?.kind==='center_target'?'Transcribing, then scanning the centered object…':'Transcribing locally on the Pi…';
        const result=await postAudio(blob,proposalAtStart,requestController.signal);
        if(speechEpoch!==conversationEpoch)return;
        message('user',result.transcript); receiveConversation(result.mission);
        status.textContent=`Heard “${result.transcript}” · ${result.transcription_ms.toFixed(0)} ms after recording stopped.`;
      } catch(error) { if(speechEpoch===conversationEpoch)status.textContent=error.message; }
      finally {
        clearTimeout(requestTimer);
        if(speechRequestController===requestController)speechRequestController=null;
        if(speechEpoch===conversationEpoch)button.disabled=false;
      }
    };
    recorder.start(); button.disabled=false; button.textContent='Stop and transcribe'; status.textContent='Listening… Speak naturally. Tap again to send (up to 30 seconds).' ;
    speechTimer=setTimeout(()=>stopSpeech(),29500);
  } catch(error) { speechAcquiring=false;stream?.getTracks().forEach(track=>track.stop());speechRecorder=null;button.textContent='Start speaking';button.disabled=false;if(speechEpoch===conversationEpoch)status.textContent=error.message; }
};
document.addEventListener('visibilitychange',()=>{ if(document.hidden) {++conversationEpoch;stopSpeech(true);} });
function canvasPoint(event) {
  const rect=canvas.getBoundingClientRect();
  return [(event.clientX-rect.left)*canvas.width/rect.width,(event.clientY-rect.top)*canvas.height/rect.height];
}
canvas.onpointerdown=event=>{
  if(!objectSelectionMode) return;
  const [x,y]=canvasPoint(event); objectSelectionDraft={x1:x,y1:y,x2:x,y2:y};
  canvas.setPointerCapture(event.pointerId);
};
canvas.onpointermove=event=>{
  if(!objectSelectionDraft) return;
  [objectSelectionDraft.x2,objectSelectionDraft.y2]=canvasPoint(event);
};
canvas.onpointerup=async event=>{
  if(!objectSelectionDraft) return;
  [objectSelectionDraft.x2,objectSelectionDraft.y2]=canvasPoint(event);
  const draft=objectSelectionDraft;
  const box=[Math.min(draft.x1,draft.x2),Math.min(draft.y1,draft.y2),Math.max(draft.x1,draft.x2),Math.max(draft.y1,draft.y2)].map(Math.round);
  objectSelectionDraft=null; objectSelectionMode=false; suppressCanvasClickUntil=performance.now()+500; canvas.style.cursor='';
  replaceConversationIntent();
  try { await post('/object/select',{box},5000); }
  catch(error) { el('object-select-state').textContent=error.message; }
};
canvas.onclick = event => {
  if(objectSelectionMode || performance.now()<suppressCanvasClickUntil) return;
  if (!latest || performance.now()-lastGood > 750) return;
  const [x,y]=canvasPoint(event);
  const matches=latest.tracks.filter(t => x>=t.box[0] && x<=t.box[2] && y>=t.box[1] && y<=t.box[3]);
  if(matches.length===1) select(matches[0].id);
};
function renderInfo(meta) {
  el('language-mode').textContent=meta.language?.mode==='local_model'?'Local language model · Experimental':'Basic commands available · Natural-language model under evaluation';
  el('camera-live-label').textContent='LIVE';el('camera-badge').classList.toggle('offline',false);
  el('connection-status').textContent='Pi connected';el('connection-status').classList.toggle('disconnected',false);
  el('state').textContent=meta.status;
  el('state').className=meta.status==='Tracking'?'tracking':meta.status==='Lost'?'lost':'';
  el('reason').textContent=meta.reason || (meta.status==='Tracking'?`Following selected person ${meta.selected_id}.`:'Select a person’s box or use a button below.');
  const key=meta.tracks.map(t=>t.id).join(',');
  if(key!==uiKey || !el('people').dataset.ready) {
    uiKey=key; el('people').dataset.ready='yes'; el('people').replaceChildren();
    for(const track of meta.tracks) { const button=document.createElement('button'); button.textContent=`Select person ${track.id}`; button.onclick=()=>select(track.id); el('people').append(button); }
    if(!meta.tracks.length) { const p=document.createElement('p'); p.textContent='No clear person detected.'; el('people').append(p); }
  }
  el('vision').textContent=`${meta.vision_fps.toFixed(1)} / sec`;
  el('temp').textContent=meta.hardware.temperature_c===undefined?'—':`${meta.hardware.temperature_c.toFixed(1)} °C`;
  el('power').textContent=meta.hardware.throttled==='0x0'?'No warnings':meta.hardware.throttled || 'Checking…';
  el('detail').textContent=`${meta.model} · Input ${meta.image_size} · Memory ${meta.hardware.memory_mb ?? '—'} MB · Vision frame age ${meta.vision_age_ms ?? '—'} ms`;
  const object=meta.object_tracking || {status:'idle',box:null,reason:'No object selected.'};
  el('object-select-state').textContent=objectSelectionMode?'Drag a snug box around one object in the camera.':object.reason;
  const recoveryState=el('object-recovery-state');
  if(objectSelectionMode) recoveryState.textContent='Selecting';
  else if(object.status==='reacquiring') recoveryState.textContent=object.search_scope==='full_frame'?'Searching full view':'Searching nearby';
  else if(object.status==='tracking' && object.memory_views) recoveryState.textContent=`Tracking · ${object.memory_views}/4 views`;
  else if(object.status==='tracking') recoveryState.textContent='Tracking';
  else if(object.status==='lost') recoveryState.textContent='Lost safely';
  else recoveryState.textContent='No target';
  if(missionPrompt?.kind==='center_target' && performance.now()<missionPromptUntil)
    showObjectGuide(missionPrompt.phase==='scanning'?'scanning':'hold');
  else if(object.status==='reacquiring') showObjectGuide('searching');
  else if(object.status==='tracking' && object.memory_views) showObjectGuide('learning',object.memory_views);
  else if(object.status==='lost' && object.memory_views) showObjectGuide('lost');
  else showObjectGuide(null);
  const summary=object.status!=='idle'?{tracking:'Tracking object',reacquiring:'Searching for object',lost:'Object lost'}[object.status] || object.status:meta.status;
  if(object.status!=='idle'){el('state').textContent=summary;el('reason').textContent=object.reason;}
  if(summary!==spokenState && performance.now()-spokenAt>3000 && ['Searching','Searching for object','Lost','Object lost'].includes(summary)) {say(summary);spokenAt=performance.now();}
  spokenState=summary;
  el('object-clear').disabled=object.status==='idle';
  el('object-select').textContent=['tracking','reacquiring'].includes(object.status)?'Select a different object':'Draw a box around it';
  const enrollment=meta.enrollment || {status:'idle',prompt:'Start guided enrollment when ready',feedback:'Enrollment has not started',completed:0,total:5};
  el('enrollment-state').textContent=enrollment.status==='active'?'In progress':enrollment.status==='complete'?'Enrollment complete':enrollment.status==='error'?'Enrollment error':'Not started';
  el('enrollment-state').className=enrollment.status==='complete'?'tracking':enrollment.status==='error'?'lost':'';
  el('enrollment-prompt').textContent=enrollment.status==='active'?`${enrollment.prompt}. ${enrollment.feedback}.`:enrollment.feedback;
  el('enrollment-progress').max=enrollment.total; el('enrollment-progress').value=enrollment.completed;
  el('enrollment-progress').textContent=`${enrollment.completed} of ${enrollment.total}`;
  el('enrollment-start').disabled=enrollment.status==='active';
  el('enrollment-cancel').disabled=enrollment.status==='idle';
  el('face-check').disabled=enrollment.status!=='complete';
  el('liveness-check').disabled=enrollment.status!=='complete';
}
function drawEnrollment(enrollment) {
  if(!enrollment || enrollment.status!=='active') return;
  ctx.save();
  ctx.strokeStyle=enrollment.status==='complete'?'#79ffb9':'#7ecbff'; ctx.lineWidth=4; ctx.setLineDash([12,8]);
  ctx.beginPath(); ctx.ellipse(canvas.width/2,canvas.height/2,canvas.width*.16,canvas.height*.36,0,0,Math.PI*2); ctx.stroke();
  ctx.setLineDash([]); ctx.font='bold 20px sans-serif';
  const label=enrollment.status==='complete'?'Enrollment complete':enrollment.prompt;
  const width=Math.min(canvas.width-32,ctx.measureText(label).width+28);
  ctx.fillStyle='#071017e8'; ctx.fillRect((canvas.width-width)/2,canvas.height-58,width,38);
  ctx.fillStyle=ctx.strokeStyle; ctx.textAlign='center'; ctx.fillText(label,canvas.width/2,canvas.height-32);
  ctx.restore();
}
function drawFaceRange() {
  if(!faceRangeTimer || !faceRange?.box || performance.now()-faceRangeAt>750) return;
  const [x1,y1,x2,y2]=faceRange.box;
  const color={good:'#45d79f',marginal:'#f5cf72',poor:'#ff7f87'}[faceRange.quality];
  ctx.strokeStyle=color; ctx.lineWidth=5; ctx.strokeRect(x1,y1,x2-x1,y2-y1);
  const label=`${faceRange.quality==='good'?'Reliable':faceRange.quality==='marginal'?'Marginal':'Not reliable'} · ≈ ${faceRange.estimated_distance_m.toFixed(1)} m`;
  ctx.font='bold 17px sans-serif'; const width=Math.min(canvas.width-x1,ctx.measureText(label).width+18);
  ctx.fillStyle='#071017e8'; ctx.fillRect(x1,Math.max(0,y1-30),width,30);
  ctx.fillStyle=color; ctx.fillText(label,x1+8,Math.max(21,y1-8));
}
function drawObjectDetections() {
  if(performance.now()>=objectDetectionsUntil) { objectDetections=[]; return; }
  for(const detection of objectDetections) {
    const [x1,y1,x2,y2]=detection.box, labelY=Math.max(0,y1-25);
    ctx.strokeStyle='#7ecbff'; ctx.lineWidth=4; ctx.strokeRect(x1,y1,x2-x1,y2-y1);
    ctx.fillStyle='#071017e8'; ctx.fillRect(x1,labelY,220,25);
    ctx.fillStyle='#7ecbff'; ctx.font='bold 15px sans-serif';
    ctx.fillText(`${detection.label} ${Math.round(detection.confidence*100)}% · snapshot`,x1+5,labelY+18);
  }
}
function drawGenericObject(object) {
  if(object?.status!=='tracking' || !object.box) return;
  const [x1,y1,x2,y2]=object.box, labelY=Math.max(0,y1-25);
  ctx.strokeStyle='#d4a7ff'; ctx.lineWidth=4; ctx.strokeRect(x1,y1,x2-x1,y2-y1);
  ctx.fillStyle='#071017e8'; ctx.fillRect(x1,labelY,330,25);
  ctx.fillStyle='#d4a7ff'; ctx.font='bold 15px sans-serif';
  const score=object.score===undefined?'':` ${Math.round(object.score*100)}%`;
  ctx.fillText(`${object.label || 'Selected object'}${score} · ${object.method || 'prototype'}`,x1+5,labelY+18);
}
function drawSelectionDraft() {
  if(!objectSelectionDraft) return;
  const {x1,y1,x2,y2}=objectSelectionDraft;
  ctx.strokeStyle='#ffffff'; ctx.lineWidth=3; ctx.setLineDash([8,6]);
  ctx.strokeRect(x1,y1,x2-x1,y2-y1); ctx.setLineDash([]);
}
function drawMissionPrompt() {
  if(!missionPrompt || performance.now()>=missionPromptUntil) { missionPrompt=null; return; }
  if(missionPrompt.kind!=='center_target' || !missionPrompt.box) return;
  const [x1,y1,x2,y2]=missionPrompt.box;
  const scanning=missionPrompt.phase==='scanning';
  ctx.fillStyle='#02060888';
  ctx.fillRect(0,0,canvas.width,y1); ctx.fillRect(0,y2,canvas.width,canvas.height-y2);
  ctx.fillRect(0,y1,x1,y2-y1); ctx.fillRect(x2,y1,canvas.width-x2,y2-y1);
  ctx.strokeStyle=scanning?'#f5cf72':'#7ecbff'; ctx.lineWidth=5; ctx.setLineDash(scanning?[]:[12,8]);
  ctx.strokeRect(x1,y1,x2-x1,y2-y1); ctx.setLineDash([]);
  ctx.fillStyle='#071017ed'; ctx.fillRect(x1,Math.max(0,y1-34),Math.min(390,x2-x1),34);
  ctx.fillStyle=scanning?'#f5cf72':'#7ecbff'; ctx.font='bold 16px sans-serif';
  ctx.fillText(scanning?'Hold still — scanning object…':'Put one complete object here',x1+8,Math.max(22,y1-11));
}
async function loop() {
  while(true) {
    if(document.hidden) { presentationEpoch++; times=[]; delays=[]; await sleep(250); continue; }
    try {
      const start=performance.now();
      const response=await fetch(`/frame?after=${sequence}`,{cache:'no-store',signal:AbortSignal.timeout(2500)});
      if(!response.ok) { const error=await response.json(); throw new Error(error.error); }
      const meta=JSON.parse(response.headers.get('X-Frame-Meta'));
      const bitmap=await createImageBitmap(await response.blob());
      await paint();
      if(document.hidden) { bitmap.close(); continue; }
      if(canvas.width!==bitmap.width || canvas.height!==bitmap.height) {canvas.width=bitmap.width;canvas.height=bitmap.height;}
      ctx.drawImage(bitmap,0,0,canvas.width,canvas.height); bitmap.close();
      // Bound box freshness at browser presentation too, including transfer time.
      const transfer=performance.now()-start;
      if(meta.vision_age_ms===null || meta.vision_age_ms+transfer>750) {
        meta.tracks=[];
        if(['Tracking','Temporarily hidden','Searching'].includes(meta.status)) {meta.status='Lost';meta.reason='Tracking updates are stale at the display.';}
      }
      if(meta.object_tracking?.status==='tracking' && (!Number.isFinite(meta.object_tracking.box_age_ms) || meta.object_tracking.box_age_ms+transfer>750)) {
        meta.object_tracking={...meta.object_tracking,status:'lost',box:null,reason:'Object tracking updates are stale at the display.'};
      }
      for(const track of meta.tracks) {
        const active=track.id===meta.selected_id && meta.status==='Tracking';
        ctx.strokeStyle=active?'#79ffb9':'#f5e08a'; ctx.lineWidth=active?4:2;
        const [x1,y1,x2,y2]=track.box; ctx.strokeRect(x1,y1,x2-x1,y2-y1);
        ctx.fillStyle='#071017dd'; ctx.fillRect(x1,Math.max(0,y1-23),130,23);
        ctx.fillStyle=ctx.strokeStyle; ctx.font='15px sans-serif'; ctx.fillText(`${active?'Selected':'Person'} ${track.id}`,x1+5,Math.max(17,y1-6));
      }
      drawGenericObject(meta.object_tracking);
      drawObjectDetections();
      drawSelectionDraft();
      drawMissionPrompt();
      drawEnrollment(meta.enrollment);
      drawFaceRange();
      ctx.fillStyle='#071017dd'; ctx.fillRect(8,8,205,30);
      ctx.fillStyle=meta.status==='Tracking'?'#79ffb9':meta.status==='Lost'?'#ff9797':'#f5e08a';
      ctx.font='18px sans-serif'; ctx.fillText(meta.status,16,30);
      lastGood=performance.now(); latest=meta; sequence=meta.sequence;
      renderInfo(meta);
      const epoch=presentationEpoch;
      // Measure after the next presentation opportunity without blocking the next fetch.
      // At most one frame request is active; there is no growing prefetch queue.
      void paint().then(()=>{
        if(document.hidden || epoch!==presentationEpoch) return;
        const now=performance.now();
        times.push(now); delays.push(meta.capture_age_ms+now-start);
        times=times.filter(t=>now-t<5000); if(delays.length>150) delays.shift();
        const fps=times.length>1?(times.length-1)*1000/(times.at(-1)-times[0]):0;
        const sorted=[...delays].sort((a,b)=>a-b), p95=sorted[Math.ceil(sorted.length*.95)-1];
        el('display').textContent=`${fps.toFixed(1)} fps`; el('delay').textContent=`${Math.round(p95)} ms`;
        el('notice').textContent=meta.error || (now<actionErrorUntil?actionError:'') || (meta.hardware.throttled && meta.hardware.throttled!=='0x0'?'Pi reports power or throttling flags.':'');
        if(now-reportedAt>5000) { reportedAt=now; post('/telemetry',{display_fps:fps,latency_upper_p95_ms:p95,samples:delays.length,visible:true}).catch(()=>{}); }
      }).catch(error=>interrupted(`Preview unavailable: ${error.message}`));
    } catch(error) {
      interrupted(`Camera unavailable: ${error.message}`);
      times=[]; delays=[]; await sleep(500);
    }
  }
}
setInterval(()=>{if(!document.hidden && performance.now()-lastGood>1000) interrupted('Waiting for fresh video…');},250);
loop();
