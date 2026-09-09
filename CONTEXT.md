# Biometric Guard Drone

Language for the project's identity, flight authorization, endurance, and observation and flight commands.

## Language

**Owner**:
The enrolled person who retains ownership and recovery authority and alone grants or revokes guest access.
_Avoid_: Guest, selected subject, current speaker

**Guest**:
A person other than the owner, using their own enrolled identity with command access explicitly granted by the owner. Guest status does not confer ownership, recovery control or independent arming authority.
_Avoid_: Co-owner, selected subject, recovery administrator

**Recipient**:
The person designated to receive a delivery, whose identity is verified before cargo release. Being a recipient is distinct from having permission to command the aircraft.
_Avoid_: Owner, guest, selected subject

**Cargo holder**:
The aircraft component that retains delivery cargo and controls its removal.
_Avoid_: Cargo, arming gate

**Cargo**:
The item carried for delivery, excluding the cargo holder and the aircraft's own required equipment. Cargo mass is additional to both aircraft mass and holder mass.
_Avoid_: Cargo holder, onboard computer, total takeoff mass

**Validated cargo limit**:
The maximum cargo mass permitted for a defined aircraft configuration and operating conditions after its required tests pass. An estimated carrying capability is not a validated cargo limit.
_Avoid_: Peak lifting thrust, predicted payload, unrestricted carrying capacity

**Conditional planning baseline**:
The exact component, interface, cost and acceptance package selected for specifications and build work before empirical acceptance. It preserves every requirement as a release gate; it does not claim that the aircraft has passed endurance, payload, security or flight tests.
_Avoid_: Qualified aircraft, proven build, purchase authorization

**Pending physical validation**:
A defined requirement or interface whose future acceptance test is already specified but whose result depends on received hardware, fabrication or real operation. It is not an unanswered planning decision and does not permit a known incompatibility.
_Avoid_: Unresolved scope, assumed pass, waived requirement

**Faceprint**:
An enrolled person's facial reference used to compare later face captures for identity verification. A match is not by itself proof of liveness or permission to command the drone.
_Avoid_: Uploaded photo, proof of liveness, 3D face model

**Biometric command gate**:
The authorization boundary combining verification of an enrolled person's face and voice with permission for the requested action. It is not a claim of perfect recognition or immunity to spoofing.
_Avoid_: Impenetrable biometric lock, perfect match

**Arming authorization**:
Permission to enable the motors for a new flight. Once the biometric command gate is enabled, every new arming request requires verification of the owner's face and voice, including guest flights and requests from the radio or voice control.
_Avoid_: Radio bypass, voice-only arming gate

**Emergency manual override**:
The pilot's independent ability to take control and land safely during flight without another biometric check. It is not permission to bypass the biometric command gate when starting a new flight.
_Avoid_: Biometric bypass, emergency unlock

**Handheld voice controller**:
The off-aircraft interface for an authorized person's voice commands and flight-status feedback. It is distinct from the aircraft's flight controller and the radio used for independent emergency manual control.
_Avoid_: Flight controller, radio transmitter, onboard companion computer

**Useful flight time**:
Time available for the drone's intended activity before using the separate energy reserved for reaching its landing destination and landing safely. It is not the total time until the battery is exhausted.
_Avoid_: Battery-to-empty airtime

**Return-and-landing reserve**:
Battery energy held back for returning to the fixed return point and landing safely, including the landing reserve. It is additional to the useful-flight allowance, not time counted toward it.
_Avoid_: Extra mission time

**Selected subject**:
A person or object designated as the focus of an observation or movement command. Selection does not grant command authorization.
_Avoid_: Authorized subject, enrolled subject

**Following**:
Aircraft movement that accompanies the selected subject as it moves.
_Avoid_: Camera-only tracking

**Orbiting**:
Aircraft movement around a selected subject for observation.
_Avoid_: Area patrol

**Watching**:
Camera observation of a selected subject without a request for aircraft movement to follow it.
_Avoid_: Following

**Area patrol**:
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
