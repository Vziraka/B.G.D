# Biometric Guard Drone

Language for the current product. The September 10 product reset in [Issue10](.scratch/biometric-guard-drone/issues/10-milestone-ladder.md) supersedes older cargo, guest-role and endurance definitions; [the interaction contract](docs/phone-drone/interaction-contract.md) defines current command behavior.

The September11 budget amendment in Issue10 sets a hard **$1,000 delivered usable-system maximum**, including one flight battery, control/charging equipment and all required accessories, tax and shipping. Existing phone/computer/free lab access are credited; optional spares and development allowances are separate. Detailed work on the over-budget aircraft is paused for affordability review; capabilities remain required.

## Language

**Owner**:
The person directing the project and deciding who may use the unlocked paired phone for enrollment. The product does not require a separate administrator role for routine enrollment/removal.
_Avoid_: Sole authorized speaker, selected subject

**Enrolled user**:
A person whose onboard face reference is enrolled through the unlocked paired phone while landed/disarmed. Every enrolled user has the same spoken-command abilities after face/liveness verification. Enrollment does not grant independent radio authority or change device pairing/recovery.
_Avoid_: Guest permission tier, selected subject, verified speaker

**Retired delivery terms**:
Guest permission tiers, recipient, cargo holder, cargo and validated cargo limit belong to historical delivery designs, not current product requirements. Aircraft equipment mass still belongs in the selected design's full mass accounting.

**Conditional planning baseline**:
The exact component, interface, cost and acceptance package selected for specifications and build work before empirical acceptance. It preserves every requirement as a release gate; it does not claim that the aircraft has passed endurance, security or flight tests.
_Avoid_: Qualified aircraft, proven build, purchase authorization

**Pending physical validation**:
A defined requirement or interface whose future acceptance test is already specified but whose result depends on received hardware, fabrication or real operation. It is not an unanswered planning decision and does not permit a known incompatibility.
_Avoid_: Unresolved scope, assumed pass, waived requirement

**Faceprint**:
An enrolled person's facial reference used to compare later face captures for identity verification. A match is not by itself proof of liveness or permission to command the drone.
_Avoid_: Uploaded photo, proof of liveness, 3D face model

**Launch authority**:
Permission for one paired phone or paired radio to request one prepared launch and verification approach. It is request-bound, short-lived and distinct from permission to issue spoken mission commands.
_Avoid_: Biometric approval, reusable arm token, command session

**Enrolled-user command session**:
A permission created by onboard enrolled-user face and liveness verification for accepting new spoken mission commands during one flight session. Speech recognition identifies the requested action; it does not establish who spoke.
_Avoid_: Voice identity, biometric arming token, permanent unlock

**Independent manual authority**:
The paired radio pilot's ability to take control and land safely without another biometric check. It neither authorizes phone commands nor bypasses normal flight-controller safety checks.
_Avoid_: Biometric bypass, phone permission, emergency unlock

**Verification zone**:
The preflight-defined place where the enrolled user stands while the aircraft occupies its validated verification pose. It avoids searching for or following an unverified person before the enrolled-user check.
_Avoid_: Dynamic owner tracking, arbitrary meeting point

**Live guidance preview**:
A temporary, encrypted view from the aircraft's actual camera that helps the enrolled user frame their face and follow enrollment or verification instructions. It may carry non-authoritative alignment guidance, but it never supplies identity, liveness or command permission and is not recorded by default.
_Avoid_: Phone-side verification, biometric result, pilot video recorder

**Handheld voice controller**:
The phone, optionally with EarPods, used for deliberate speech input and flight-status feedback during an enrolled-user command session. It is distinct from the aircraft's flight controller and the independent radio.
_Avoid_: Flight controller, radio transmitter, speaker verifier

**Useful flight time**:
Time performing intended activity, excluding takeoff and landing. The current target is 10 minutes in the engineered operating envelope, with energy for takeoff and recovery/landing additional. An early battery-triggered recovery is necessary behavior but does not meet that flight's usefulness target.
_Avoid_: Total airtime, battery-to-empty airtime

**Recovery and landing energy**:
Energy needed to interrupt a task, reach a suitable landing spot and descend with margin. Battery monitoring must trigger early enough for this; whole-mission completion prediction is not required. Historical fixed-return reserve formulas are evidence for their original designs, not the current mandated calculation method.
_Avoid_: Optional landing energy, extra mission time, battery-to-empty trigger

**Working distance**:
Distance from the user to the aircraft. The initial design/test target is 100 m; this is neither total route length nor a qualified or permanent maximum. Movement of the user does not redefine a fixed landing destination.
_Avoid_: Total travel, distance from takeoff, proven radio range

**Natural-language mission**:
A request in ordinary phone speech expressing one or more supported actions. Interpretation must resolve necessary ambiguity and produce a checked executable plan; language breadth does not establish unlimited physical ability.
_Avoid_: Arbitrary instruction execution, memorized phrase list

**Digital zoom**:
Cropping and enlarging captured video. Additional distant detail requires a better capture, potentially by repositioning where conditions permit; enlargement itself supplies no new evidence.
_Avoid_: Optical magnification, guaranteed identification

**Selected subject**:
A person or object designated as the focus of an observation or movement command. Selection does not grant command authorization.
_Avoid_: Authorized subject, enrolled subject

**Following**:
Aircraft movement that accompanies the selected subject as it moves.
_Avoid_: Camera-only tracking

**Orbiting** (optional extension):
Aircraft movement around a selected subject for observation.
_Avoid_: Area patrol

**Watching** (optional extension):
Camera observation of a selected subject without a request for aircraft movement to follow it.
_Avoid_: Following

**Area patrol** (optional extension):
Repeated observation along an approved route or within an approved area.
_Avoid_: Orbiting a subject

**Fixed return point**:
A location designated as a flight's normal return-and-landing destination, unchanged by movement of the pilot or selected subject. It is specific to that flight, not a permanently assigned address.
_Avoid_: Permanent home location, current pilot position

**Landing destination**:
The location selected for a flight to end with touchdown, whether the fixed return point or an alternative landing site. Selecting a destination does not establish that it is suitable or reachable.
_Avoid_: Owner position, selected subject

**Landing reserve**:
Battery energy protected for the landing approach, descent, touchdown, and safety margin, rather than useful flight. It remains necessary when the landing destination is not the original takeoff point.
_Avoid_: Optional landing energy, extra mission time

**Land here**:
A command requesting landing at a user-selected and confirmed patch of ground near the user, not on the user or automatically beneath the drone. Selecting that destination does not establish its suitability or reachability.
_Avoid_: Land at my feet, descend in place
