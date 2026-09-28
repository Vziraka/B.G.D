// Exercise the real UI handlers with controllable permission, recording and HTTP completion.
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const deferred = () => { let resolve,reject; const promise=new Promise((r,j)=>{resolve=r;reject=j;}); return {promise,resolve,reject}; };
const flush = async () => { for(let i=0;i<12;i++) await Promise.resolve(); };
function harness() {
  const elements=new Map(), requests=[], recordings=[], timers=new Map(), permission=deferred();
  let timerId=0, stoppedTracks=0, permissionRequests=0, now=0;
  const drawing={strokes:0};
  const context=new Proxy({}, {get:(_,key)=>key==='strokeRect'?()=>drawing.strokes++:key==='measureText'?()=>({width:20}):()=>{}});
  function element() {
    return {children:[],dataset:{},style:{},textContent:'',width:960,height:540,classList:{toggle(){},contains(){return false;}},
      set innerHTML(value){throw new Error('Unsafe HTML rendering: '+value);},
      setAttribute(){},append(...items){this.children.push(...items);},replaceChildren(){this.children=[];},
      querySelector(){return element();},getContext:()=>context,get firstElementChild(){return this.children[0];}};
  }
  const el=id=>{if(!elements.has(id))elements.set(id,element());return elements.get(id);};
  const document={hidden:false,body:element(),getElementById:el,querySelector:()=>({content:'test-token'}),
    querySelectorAll:()=>[],createElement:element,addEventListener(){}};
  const stream={getTracks:()=>[{stop(){stoppedTracks++;}}]};
  class Recorder {
    static isTypeSupported(){return true;}
    constructor(){this.state='inactive';this.mimeType='audio/webm';recordings.push(this);}
    start(){this.state='recording';}
    stop(){this.state='inactive';this.stopPending=true;}
    async finish(){this.ondataavailable({data:new Blob(['audio'])});await this.onstop();}
  }
  const sandbox={document,performance:{now:()=>now},Blob,MediaRecorder:Recorder,window:{MediaRecorder:Recorder},AbortController,
    navigator:{mediaDevices:{getUserMedia:()=>{permissionRequests++;return permission.promise;}}},AbortSignal:{timeout:()=>({})},
    setTimeout(fn){timers.set(++timerId,fn);return timerId;},clearTimeout(id){timers.delete(id);},
    setInterval(fn){timers.set(++timerId,fn);return timerId;},clearInterval(id){timers.delete(id);},
    requestAnimationFrame(){},fetch(url,options){
      if(url.startsWith('/frame')) return new Promise(()=>{});
      const pending=deferred();requests.push({url,options,reply(value){pending.resolve({ok:true,json:async()=>value});},fail(error){pending.reject(error);}});
      return pending.promise;
    }};
  vm.runInNewContext(fs.readFileSync('bgd_vision/app.js','utf8'),sandbox);
  const proposal=id=>({status:'confirmation_required',message:'Review '+id,command:'follow bottle',proposal_id:id,expires_in:45,authority:'SIMULATION_ONLY'});
  const texts=()=>el('conversation-log').children.map(article=>article.children[1].textContent);
  return {sandbox,el,requests,recordings,timers,proposal,texts,drawing,
    allow(){permission.resolve(stream);},stopped:()=>stoppedTracks,permissionRequests:()=>permissionRequests,setNow(value){now=value;}};
}
async function run() {
  {
    const h=harness();const acquisition=h.el('speech-record').onclick();
    assert.equal(h.el('speech-record').disabled,true);
    const stop=h.el('stop-all').onclick();h.requests[0].reply({status:'stopped',message:'Stopped'});await stop;
    h.allow();await acquisition;
    assert.equal(h.recordings.length,0,'Permission granted after Stop must not start recording');
    assert.equal(h.stopped(),1,'Discarded permission stream must close');
  }
  {
    const h=harness();h.allow();await h.el('speech-record').onclick();
    const correcting=h.sandbox.sendConversation('Actually follow the book');
    await h.recordings[0].finish();
    assert.equal(h.requests.filter(r=>r.url==='/speech/transcribe').length,0,'Replaced recording must never upload');
    assert.equal(h.stopped(),1);
    h.requests[0].reply(h.proposal('corrected'));await correcting;
  }
  {
    const h=harness();h.sandbox.receiveConversation(h.proposal('exact-original'));h.allow();
    await h.el('speech-record').onclick();
    // Expiry can clear the visible proposal while a recording is in progress.
    h.sandbox.clearProposal();await h.el('speech-record').onclick();
    const finishing=h.recordings[0].finish();await flush();
    const audio=h.requests.find(r=>r.url==='/speech/transcribe');
    assert.equal(audio.options.headers['X-Proposal-Id'],'exact-original','Spoken yes is bound to the proposal present when recording began');
    audio.reply({transcript:'yes',transcription_ms:12,mission:{status:'expired',message:'Please ask again'}});await finishing;
  }
  {
    const h=harness();h.allow();await h.el('speech-record').onclick();
    await h.el('speech-record').onclick();
    assert.equal(h.el('speech-record').disabled,true,'Stopping disables restart until onstop cleanup');
    await h.el('speech-record').onclick();
    assert.equal(h.permissionRequests(),1,'Stop-to-onstop gap must not acquire a second microphone stream');
    const finishing=h.recordings[0].finish();await flush();
    const audio=h.requests.find(r=>r.url==='/speech/transcribe');
    const stopping=h.el('stop-all').onclick();
    assert.equal(audio.options.signal.aborted,true,'Stop aborts an in-flight transcription request');
    assert.equal(h.el('speech-record').disabled,false,'Stop makes the microphone control ready immediately');
    audio.reply({transcript:'stale',transcription_ms:1,mission:{status:'complete',message:'stale'}});
    h.requests.find(r=>r.url==='/conversation').reply({status:'stopped',message:'Stopped'});
    await stopping;await finishing;await flush();
  }
  {
    const h=harness();const first=h.sandbox.sendConversation('follow bottle');const second=h.sandbox.sendConversation('follow book');
    h.requests[1].reply(h.proposal('new'));await second;h.requests[0].reply(h.proposal('old'));await first;
    assert.equal(h.texts().includes('Review old'),false,'Obsolete reply must not replace current proposal');
    const confirm=h.el('confirm-mission').onclick();
    assert.equal(JSON.parse(h.requests[2].options.body).proposal_id,'new');
    await h.el('confirm-mission').onclick();assert.equal(h.requests.length,3,'Confirm consumes the displayed proposal once');
    h.requests[2].reply({status:'complete',message:'Done'});await confirm;
  }
  {
    const h=harness();h.sandbox.receiveConversation(h.proposal('pending-exact'));
    const asking=h.sandbox.sendConversation('How is the camera doing at the moment?');
    assert.equal(h.el('proposal-card').hidden,false,'The pending review card stays visible while the status question is checked');
    assert.equal(h.el('confirm-mission').disabled,true,'The proposal cannot be confirmed while the new request is unresolved');
    h.requests[0].reply({status:'status',message:'Camera is stale.',authority:'SIMULATION_ONLY',
      pending_proposal:{...h.proposal('pending-exact'),expires_in:30}});await asking;
    assert.equal(h.el('proposal-card').hidden,false,'A status answer restores the same unexpired exact proposal');
    const confirming=h.el('confirm-mission').onclick();
    assert.equal(JSON.parse(h.requests[1].options.body).proposal_id,'pending-exact');
    h.requests[1].reply({status:'complete',message:'Done'});await confirming;
  }
  {
    const h=harness();h.sandbox.receiveConversation(h.proposal('possibly-retired'));
    const sending=h.sandbox.sendConversation('Could you find a book?');
    h.requests[0].fail(new Error('Connection lost'));await sending;
    assert.equal(h.el('proposal-card').hidden,true,'A failed response must not revive a proposal the server may have retired');
    assert.equal(h.texts().at(-1),'I could not verify whether the earlier proposal is still current. Ask for status before confirming anything.');
  }
  for(const control of ['stop-all','cancel-mission']) {
    const h=harness();const stopping=h.el(control).onclick();const next=h.sandbox.sendConversation('follow book');
    h.requests[1].reply(h.proposal('new'));await next;h.requests[0].reply({status:'stopped',message:'Old stop reply'});await stopping;
    assert.equal(h.el('proposal-card').hidden,false,control+' delayed response must not hide newer proposal');
    assert.equal(h.texts().includes('Old stop reply'),false);
  }
  for(const control of ['person-select','clear','object-clear']) {
    const h=harness();h.sandbox.receiveConversation(h.proposal('displayed-manual-replaced'));
    assert.equal(h.el('proposal-card').hidden,false,'Precondition: proposal is displayed');
    let replacing;
    if(control==='person-select')replacing=h.sandbox.select(7);
    else replacing=h.el(control).onclick();
    assert.equal(h.el('proposal-card').hidden,true,control+' must retire the displayed proposal directly');
    h.requests[0].reply(control==='person-select'?{status:'Tracking',tracks:[],object_tracking:{status:'idle'},enrollment:{status:'idle'},hardware:{}}:{status:'idle'});
    await replacing;
  }
  for(const control of ['person-select','clear','object-clear']) {
    const h=harness();h.sandbox.receiveConversation(h.proposal('manual-replaced'));
    const old=h.sandbox.sendConversation('old language request');
    let replacing;
    if(control==='person-select')replacing=h.sandbox.select(7);
    else replacing=h.el(control).onclick();
    assert.equal(h.el('proposal-card').hidden,true,control+' keeps the replaced proposal hidden');
    h.requests[0].reply(h.proposal('obsolete-language'));await old;
    const replacementRequest=h.requests[1];
    replacementRequest.reply(control==='person-select'?{status:'Tracking',tracks:[],object_tracking:{status:'idle'},enrollment:{status:'idle'},hardware:{}}:{status:'idle'});
    await replacing;
    assert.equal(h.texts().includes('Review obsolete-language'),false,control+' must ignore an older language reply');
  }
  {
    const h=harness();const hostile='<img src=x onerror="alert(1)">';const sending=h.sandbox.sendConversation(hostile);
    h.requests[0].reply({status:'unsupported',message:hostile});await sending;
    assert.deepEqual(h.texts(),[hostile,hostile],'User and model content must stay literal text');
  }
  {
    const h=harness();h.el('face-range-start').onclick();h.el('face-range-stop').onclick();
    h.requests[0].reply({quality:'good',message:'Reliable',box:[0,0,20,20],estimated_distance_m:1});await flush();
    assert.equal(h.el('face-range-state').textContent,'Guide stopped','In-flight guide result cannot revive stopped overlay');
    h.sandbox.drawFaceRange();assert.equal(h.drawing.strokes,0);
    h.el('face-range-start').onclick();h.requests[1].reply({quality:'good',message:'Reliable',box:[0,0,20,20],estimated_distance_m:1});await flush();
    h.sandbox.drawFaceRange();assert.equal(h.drawing.strokes,1);
    h.setNow(751);h.sandbox.drawFaceRange();assert.equal(h.drawing.strokes,1,'Old face observation must not keep a trusted box');
  }
  console.log('Conversation UI: permission cleanup, superseded audio, exact confirmation, response ordering, manual intent retirement, safe text and face-overlay races passed.');
}
run().catch(error=>{console.error(error);process.exitCode=1;});
