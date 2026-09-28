// Actual browser loop with deterministic 30 Hz presentation and 20 ms local delivery.
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
async function run(stale = false, failSecond = false, objectOverlay = false, genericTracking = false, transferDelay = 2) {
  let now = 0, frames = 0, strokes = 0, sequence = 0;
  const queue = [], elements = new Map();
  const later = (delay, callback) => queue.push({at: now + delay, callback});
  const delay = ms => new Promise(resolve => later(ms, resolve));
  const context = new Proxy({}, {get: (_, key) => key === 'strokeRect' ? () => strokes++ : () => {}});
  const element = () => { const strong={textContent:''}; return {textContent: '', dataset: {}, classList: {toggle(){},contains(){return false;}},
    setAttribute(){}, replaceChildren(){}, append(){}, querySelector:()=>strong, width: 960, height: 540, getContext: () => context}; };
  const document = {hidden:false,body:element(),addEventListener(){},createElement:element,
    getElementById(id){if(!elements.has(id)) elements.set(id,element());return elements.get(id);},
    querySelector:()=>({content:'test'})};
  const sandbox = {document,performance:{now:()=>now},AbortSignal:{timeout:()=>({})},
    setTimeout:(callback,ms)=>later(ms,callback),setInterval(){},requestAnimationFrame(callback){
      later((Math.floor(now/(1000/30))+1)*(1000/30)-now,callback);
    },async fetch(url){
      if(!url.startsWith('/frame')) return {ok:true,json:async()=>({})};
      await delay(16);
      if(failSecond && sequence === 1) throw new Error('test interruption');
      const meta={sequence:++sequence,status:'Tracking',selected_id:1,tracks:[{id:1,box:[0,0,50,100]}],
        object_tracking:genericTracking?{status:'tracking',box:[100,100,200,250],box_age_ms:0,label:'Selected object',reason:'Tracking'}:{status:'idle',box:null,label:'Selected object',reason:'No object selected.'},
        capture_age_ms:20,vision_age_ms:stale?900:20,vision_fps:20,hardware:{},model:'test',image_size:320};
      return {ok:true,headers:{get:()=>JSON.stringify(meta)},async blob(){await delay(transferDelay);return {};}};
    },async createImageBitmap(){await delay(2);frames++;return {width:960,height:540,close(){}};}};
  vm.runInNewContext(fs.readFileSync('bgd_vision/app.js','utf8'),sandbox);
  if(objectOverlay) sandbox.showMissionResult({
    status:'complete',message:'Currently visible: 1 bottle.',authority:'SIMULATION_ONLY',
    interpretation:{steps:[{action:'find_object',target:'bottle'}]},
    detections:[{label:'bottle',confidence:.91,box:[100,100,200,250]}]
  });
  sandbox.showFaceResult({passed:true,minimum:.5,median:.6,maximum:.7,threshold:.363});
  assert.equal(elements.get('face-state').textContent,'Passed');
  assert.equal(elements.get('verification-status').querySelector('strong').textContent,'Waiting for liveness');
  sandbox.showLivenessResult({passed:true,frames:5,real_labels:5,minimum:.9,median:.95,maximum:1});
  assert.equal(elements.get('liveness-state').textContent,'Passed');
  assert.equal(elements.get('verification-status').querySelector('strong').textContent,'Diagnostic checks passed');
  for(let step=0;step<2000&&now<(failSecond?80:5000);step++) {
    for(let i=0;i<12;i++) await Promise.resolve();
    queue.sort((a,b)=>a.at-b.at);
    assert(queue.length,'Preview stalled');
    const next=queue.shift();now=next.at;next.callback(now);
  }
  return {frames,strokes,fps:parseFloat(elements.get('display').textContent),
    display:elements.get('display').textContent,state:elements.get('state').textContent};
}
(async()=>{
  const normal=await run();
  assert(normal.fps>=25,`30Hz preview should not wait two ticks per frame: ${JSON.stringify(normal)}`);
  const stale=await run(true);
  assert.equal(stale.strokes,0,'Stale tracking boxes must not be drawn');
  const objectOverlay=await run(false,false,true);
  assert(objectOverlay.strokes>normal.strokes,'A fresh object result must draw a transient box');
  const genericTracking=await run(false,false,false,true);
  assert(genericTracking.strokes>normal.strokes,'An active generic object must draw a persistent prototype box');
  const interrupted=await run(false,true);
  const delayedObject=await run(false,false,false,true,800);
  assert.equal(delayedObject.strokes,0,'Slow frame delivery must suppress both person and object boxes');
  assert.notEqual(delayedObject.state,'Tracking object','Stale object must not be presented as currently tracking');
  assert.equal(interrupted.display,'—','Deferred presentation must not restore metrics after interruption');
  assert.equal(interrupted.state,'Connection interrupted');
  console.log(JSON.stringify({normal,stale,interrupted}));
})().catch(error=>{console.error(error);process.exitCode=1;});
