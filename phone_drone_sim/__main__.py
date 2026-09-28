"""Generate an offline, interactive playback of actual Python simulator traces."""

import argparse
import json
from pathlib import Path

from .model import Phone, Simulator


def scenarios():
    traces = {}
    names = ["Success: enrollment to commands", "Launch rejected", "Face failure then retry success",
             "Liveness failure and retry exhausted", "Verification timeout", "Preview lost",
             "Phone disconnected", "Restart invalidates requests", "Replay rejected",
             "Speech interrupted", "Return unavailable: radio takeover"]
    for name in names:
        aircraft = Simulator()
        frames = []

        def capture(title):
            frames.append({"title": title, **aircraft.snapshot()})

        capture("All observations in this demonstration are SIMULATED")
        aircraft.connect()
        phone = Phone(aircraft)
        aircraft.maintenance_gesture(physical_radio=True)
        enrollment = aircraft.begin_enrollment()
        capture("Owner enrollment: synthetic live guidance, motors inhibited")
        aircraft.guidance = "SIMULATED move left, step back, improve lighting — advisory only"
        capture("Framing cues cannot establish identity or liveness")
        aircraft.inject_enrollment_result(enrollment, face_match=True, live=True)
        capture("Onboard enrollment test double passes; no image or reference stored")
        challenge = aircraft.issue_challenge()
        request = phone.request("launch_request", challenge_id=challenge.payload["challenge_id"],
                                hold_confirmed=True)
        aircraft.receive(request)
        capture("Deliberate paired-phone hold answers a one-use 15-second challenge")
        if name == "Launch rejected":
            aircraft.ready["energy"] = False
        result = aircraft.resolve_pending()
        assert phone.receive_result(result)
        capture("Aircraft " + ("accepts launch; spoken commands still denied" if
                               result.payload["accepted"] else "rejects launch: energy readiness failed"))
        if not result.payload["accepted"]:
            traces[name] = frames
            continue
        aircraft.arrive_at_pose()
        for message in aircraft.status_messages():
            assert phone.receive_status(message)
        capture("Fixed verification pose: animated synthetic camera preview")
        old_verification = aircraft.verification_id
        if name == "Face failure then retry success":
            aircraft.inject_onboard_face_result(old_verification, face_match=False, live=True)
            capture("Onboard test double: face FAIL, liveness PASS; one retry remains")
            aircraft.advance(5)
            aircraft.retry_verification()
            for message in aircraft.status_messages():
                assert phone.receive_status(message)
            capture("Owner explicitly retries within 30 seconds")
        elif name == "Liveness failure and retry exhausted":
            aircraft.inject_onboard_face_result(old_verification, face_match=True, live=False)
            capture("Onboard test double: face PASS, liveness FAIL")
            aircraft.retry_verification()
            capture("One explicit retry; a new result is required")
            aircraft.inject_onboard_face_result(aircraft.verification_id, face_match=True, live=False)
            capture("Second failure: protective recovery, no command session")
        elif name == "Verification timeout":
            aircraft.advance(30)
            capture("At the illustrative 30-second attempt deadline: timeout")
        elif name == "Preview lost":
            aircraft.lose_preview()
            capture("Synthetic camera disconnected: blank preview, commands denied")
        elif name == "Phone disconnected":
            aircraft.disconnect()
            phone.disconnect()
            capture("Disconnect: video and pending verification stop; motors are not cut")
            aircraft.connect()
            capture("Reconnection creates no resumed launch or owner permission")
        elif name == "Restart invalidates requests":
            aircraft.restart()
            phone.disconnect()
            capture("New boot epoch; no automatic rearm or flight-rescue claim")
            aircraft.connect()
            assert not aircraft.inject_onboard_face_result(old_verification, face_match=True, live=True)
            capture("Prior-boot face result rejected; command permission stays denied")
        elif name == "Return unavailable: radio takeover":
            aircraft.return_healthy = False
            aircraft.disconnect()
            capture("Return unavailable and degraded policy unqualified: no blind return")
            aircraft.manual_takeover()
            capture("Independent radio takes control without biometric approval")
            aircraft.disconnect()
            capture("Further phone loss does not override manual authority")
        if aircraft.state == "VERIFYING":
            aircraft.inject_onboard_face_result(aircraft.verification_id, face_match=True, live=True)
            capture("Onboard test double passes face AND liveness; current command session granted")
            for message in aircraft.status_messages():
                assert phone.receive_status(message)
            window = aircraft.open_speech_window()
            capture("Deliberate speech window: at most one command in 10 seconds")
            command = phone.request("command_request", window_id=window, command="inspect_once")
            aircraft.receive(command)
            if name == "Speech interrupted":
                aircraft.interrupt_speech("incoming call")
                assert aircraft.resolve_pending() is None
                capture("Incoming call discards queued speech; nothing executes on resume")
            else:
                response = aircraft.resolve_pending()
                assert phone.receive_result(response)
                capture("Exact request accepted onboard: bounded synthetic inspection")
                if name == "Replay rejected":
                    assert not phone.receive_result(response)
                    assert not aircraft.receive(command)
                    capture("Duplicate result and command rejected; no second execution")
            aircraft.stop()
            capture("Explicit Stop revokes commands and enters protective recovery")
        aircraft.land_and_disarm()
        capture("Trusted simulated landed/disarmed observation; no physical landing claimed")
        traces[name] = frames
    return traces


PAGE = r'''<!doctype html>
<html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>B.G.D — SIMULATED phone/onboard demonstration</title>
<style>
:root{font-family:system-ui,sans-serif;color:#eaf1fa;background:#0c1522;color-scheme:dark}
*{box-sizing:border-box}body{margin:0 auto;max-width:1120px;padding:30px 22px}
h1{font-size:clamp(1.6rem,4vw,2.4rem);margin:.4em 0}p{line-height:1.55;color:#b9c9dc}
.badge{display:inline-block;background:#fbc85a;color:#222;padding:5px 10px;font-weight:800;border-radius:5px}
.layout{display:grid;grid-template-columns:1.1fr 1fr;gap:22px;margin:24px 0}
.card{border:1px solid #354861;background:#132134;border-radius:15px;padding:20px}
label{display:block;margin-bottom:8px}select,button{font:inherit;border:1px solid #56708e;border-radius:7px;padding:11px;background:#23374e;color:white}
select{width:100%}button{cursor:pointer;margin:4px 4px 4px 0}button:disabled{opacity:.4;cursor:default}
button:focus-visible,select:focus-visible{outline:3px solid #fbc85a;outline-offset:3px}
.screen{position:relative;margin:16px 0;border:1px solid #45607b;border-radius:9px;overflow:hidden;background:#0b1723;aspect-ratio:4/3}
svg{width:100%;height:100%}.caption{position:absolute;top:12px;left:12px;background:#101925dd;padding:6px;font-size:.8rem}
#face{animation:framing 3s ease-in-out infinite;transform-origin:200px 155px}
@keyframes framing{0%,100%{transform:translate(-12px,3px)}50%{transform:translate(12px,-3px)}}
@media(prefers-reduced-motion:reduce){#face{animation:none}}
.off #face,.off #framing{display:none}#offText{display:none}.off #offText{display:block}
.cue{min-height:3em;color:#fbc85a}.stat{border-bottom:1px solid #354861;padding:12px 0}.stat small{display:block;color:#aebed1;margin-bottom:5px}
#permission{font-size:1.2rem;font-weight:bold}#reason{font-size:.95rem}#step{font-size:.85rem;color:#aebed1}
.timeline{max-height:230px;overflow:auto;padding-left:24px}.timeline li{margin:9px 0;color:#a8bdd5}.timeline .current{color:#fff;font-weight:700}
.note{font-size:.9rem}a{color:#8cceff}@media(max-width:740px){.layout{grid-template-columns:1fr}body{padding:18px 14px}}
</style>
<header><span class="badge">SIMULATED · ACTUATOR-FREE</span><h1>Phone → onboard owner verification</h1>
<p>Explore launch, live guidance, command permission and recovery. These are Python-generated test traces with an animated synthetic face. No camera, microphone, biometric model, device connection or motor output is used.</p></header>
<label for="scenario">Choose a scenario</label><select id="scenario"></select>
<div class="layout"><section class="card" aria-label="Simulated phone screen">
<span class="badge">SIMULATED CAMERA GUIDANCE</span>
<div id="screen" class="screen off"><span class="caption">SYNTHETIC FRAME · NOT RECORDED</span>
<svg viewBox="0 0 400 300" role="img" aria-label="Animated synthetic face with advisory framing target">
<defs><pattern id="grid" width="25" height="25" patternUnits="userSpaceOnUse"><path d="M25 0H0V25" fill="none" stroke="#234056" stroke-width="1"/></pattern></defs>
<rect width="400" height="300" fill="url(#grid)"/>
<g id="framing" fill="none" stroke="#7acfe6" stroke-width="3"><rect x="112" y="50" width="176" height="206" rx="25" stroke-dasharray="12 8"/><path d="M190 153h20m-10-10v20"/></g>
<g id="face" fill="#6d8eac" stroke="#a6c4db" stroke-width="2"><ellipse cx="200" cy="140" rx="47" ry="61"/><path d="M125 290v-29q0-54 75-54t75 54v29"/><g fill="#15273c"><circle cx="182" cy="131" r="5"/><circle cx="218" cy="131" r="5"/></g><path d="M183 168q17 12 34 0" fill="none"/></g>
<g id="offText"><text x="200" y="146" text-anchor="middle" fill="#b9c9dc" font-size="18">SIMULATED PREVIEW OFF</text><text x="200" y="174" text-anchor="middle" fill="#8b9fb7" font-size="12">No biometric success can be inferred</text></g>
</svg></div><div class="cue" id="guidance"></div><p class="note">Framing and movement are advisory. Only a current onboard test-double result can grant simulated command permission.</p>
</section><section class="card" aria-live="polite" aria-atomic="true"><div id="step"></div><h2 id="title"></h2>
<div class="stat"><small>Aircraft state</small><strong id="state"></strong></div>
<div class="stat"><small>Owner command permission</small><span id="permission"></span></div>
<div class="stat"><small>Onboard face + liveness result</small><span id="faceResult"></span></div>
<div class="stat"><small>Why this state</small><span id="reason"></span></div>
<p id="flight"></p><button id="back">← Previous</button><button id="next">Next step →</button><button id="play">Play scenario</button>
</section></div><details><summary>Trace steps generated by the Python state machine</summary><ol id="timeline" class="timeline"></ol></details>
<footer><p class="note">Simulation limits: pairing identities and maintenance approvals are fixtures, not real cryptography or stored biometric references. Flight geometry is disabled. A recovery branch label does not prove safe navigation, landing or survival of a flight-controller reset. Real iPhone/EarPods behavior, encrypted local Wi-Fi/video, onboard liveness, storage, flight control and physical engineering remain separate validation gates.</p><p class="note">Run: <code>python -m phone_drone_sim</code> · Tests: <code>python -m unittest discover -s tests/phone_drone_sim -v</code></p></footer>
<script id="traces" type="application/json">__TRACES__</script>
<script>
'use strict';
const traces=JSON.parse(document.getElementById('traces').textContent);
const byId=id=>document.getElementById(id);
const select=byId('scenario');let index=0,timer=null;
for(const name of Object.keys(traces)){const o=document.createElement('option');o.textContent=name;select.appendChild(o);}
function stop(){if(timer!==null)clearInterval(timer);timer=null;byId('play').textContent='Play scenario';}
function render(){const frames=traces[select.value],s=frames[index];
for(const [id,key] of [['title','title'],['state','state'],['permission','permission'],['guidance','guidance'],['faceResult','face_result'],['reason','reason']])byId(id).textContent=s[key];
byId('step').textContent=`SIMULATED step ${index+1} / ${frames.length} · aircraft clock ${s.time} s`;
byId('screen').classList.toggle('off',!s.preview);
byId('permission').style.color=s.permission.endsWith('GRANTED')?'#8bdfac':'#fbc85a';
byId('flight').textContent=`SIMULATED airborne: ${s.airborne?'yes':'no'} · armed: ${s.armed?'yes':'no'}. These are state flags, not hardware outputs.`;
byId('back').disabled=index===0;byId('next').disabled=index===frames.length-1;
byId('timeline').replaceChildren(...frames.map((f,i)=>{const li=document.createElement('li');li.textContent=f.title;if(i===index)li.className='current';return li;}));
if(index===frames.length-1)stop();}
select.addEventListener('change',()=>{stop();index=0;render();});
byId('back').addEventListener('click',()=>{stop();index--;render();});
byId('next').addEventListener('click',()=>{stop();index++;render();});
byId('play').addEventListener('click',()=>{if(timer!==null){stop();return;}if(index===traces[select.value].length-1)index=0;render();byId('play').textContent='Pause';timer=setInterval(()=>{index++;render();},1900);});
render();
</script></html>'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--demo", type=Path, default=Path("docs/phone-drone/simulator-demo.html"))
    parser.add_argument("--text", action="store_true", help="Print all scenario traces without writing HTML")
    args = parser.parse_args()
    traces = scenarios()
    if args.text:
        for name, frames in traces.items():
            print("\nSIMULATED SCENARIO: " + name)
            for frame in frames:
                print(f"  {frame['state']}: {frame['title']} ({frame['permission']})")
        return
    args.demo.parent.mkdir(parents=True, exist_ok=True)
    data = json.dumps(traces, ensure_ascii=True).replace("<", "\\u003c")
    args.demo.write_text(PAGE.replace("__TRACES__", data), encoding="utf-8")
    print("SIMULATED demo: " + str(args.demo.resolve()))
    print("Open this local HTML file in a browser; no server or installation required.")


if __name__ == "__main__":
    main()
