# Hardened desk-phase biometric threat model — decision support

Date checked: **2026-08-30**. Scope: ticket 10, offline Windows desk phase. Status: supporting research and proposed acceptance framing, **not a validated security design**. Authored directly in the main checkout; no source worktree or implementation changes.

The required face-and-voice biometric command gate, liveness checks, replay resistance, encrypted biometric storage and polished enrollment remain in scope. This note does not choose thresholds, remove requirements, authorize biometric motor arming or establish a $0 desk phase/$600 lifetime fit.

## Recognition accuracy is not attack resistance

NIST distinguishes false matches (an impostor matches) from false non-matches (a genuine person fails to match). It describes biometric matching as probabilistic and states that false-match performance does not account for active impersonation. It also identifies sensor/processing integrity as necessary alongside presentation attack detection (PAD). Therefore, recognition benchmark accuracy cannot establish that a photograph, replay or synthetic sample will be rejected. [NIST SP 800-63B-4, Use of Biometrics](https://pages.nist.gov/800-63-4/sp800-63b.html#use-of-biometrics)

**Applicability warning:** SP 800-63B-4's own authentication context requires a physical authenticator alongside biometrics and prohibits voice-based biometric comparison. This is reference guidance, not automatically applicable law or certification for this hobby project. The selected face-plus-voice policy must not be described as NIST-compliant merely because some guidance is consulted. This finding does not authorize replacing the user's policy.

## Threat classes that need separate acceptance evidence

| Class | What the test must distinguish | Evidence boundary |
|---|---|---|
| Ordinary recognition error | Genuine owner versus another real person, including varying capture conditions | Matching accuracy alone does not measure deliberate spoofing. |
| Face presentation attack | A present person versus photographs or screen-displayed images/video presented to the camera | NIST lists photo/video replay as presentation attacks and evaluates passive software PAD separately from identity matching. [NIST FATE PAD](https://pages.nist.gov/frvt/html/frvt_pad.html) |
| Voice replay or synthetic speech | Live owner speech versus recorded playback and generated/converted speech resembling the owner | ASVspoof treats replay, speech synthesis and voice conversion as distinct evaluation conditions; success on one condition does not establish coverage of the others. [ASVspoof evaluation](https://www.asvspoof.org/index2021.html), [organizers' analysis](https://arxiv.org/abs/2210.02437) |
| Digital capture injection | Sensor-produced input versus substituted media delivered inside the capture/processing path | NIST defines injection as media insertion between capture and comparison, distinct from holding media in front of the sensor. Matching and PAD do not cover every injection case. [NIST SP 800-63A-4, digital injection](https://pages.nist.gov/800-63-4/sp800-63a.html#digital-injection-prevention-and-forged-media-detection) |

“Liveness” must be defined operationally: detecting a living subject is not by itself proof of that subject's identity, intent or a trustworthy capture path. Report combined gate behavior as well as each component; do not multiply face/voice error rates without evidence that their failures are independent. These are recommended evaluation distinctions, not results already obtained.

## Host trust is an explicit decision, not an invisible assumption

For the next decision, separate attackers presenting media to an intact desk system from attackers able to substitute capture inputs, and from attackers controlling Windows, administrator privileges, verifier code or key storage. These are different capabilities, not interchangeable meanings of “hardened.” NIST's capture-integrity discussion motivates this separation; its remote-proofing requirements are not automatically this project's requirements.

**Engineering inference:** an attacker controlling the component that decides authorization may alter its decision rather than defeat biometric recognition. Encrypted files alone do not establish protection against a compromised process that can access decryption keys or plaintext. Likewise, ordinary physical proximity to a webcam is different from hardware replacement, disk access or sustained physical tampering. Do not silently exclude injection, local data theft or host compromise; ask which must be resisted and which may be explicit trust assumptions, then assess feasibility.

## Finite tests support bounded claims

Zero unauthorized accepts in a finite test set means **zero observed in that set**, not a zero underlying probability or immunity to unseen attacks. NIST's statistical handbook explains confidence intervals for binomial proportions; sample size and assumptions determine uncertainty. Repeated attempts from the same recording or session are not automatically independent representative trials. [NIST statistical handbook](https://www.itl.nist.gov/div898/handbook/prc/section2/prc241.htm)

Recommended acceptance wording: “Under the specified host/capture assumptions, hardware and software versions, environment, identities and attack classes, the gate met the agreed genuine-user and unauthorized-acceptance criteria on a separate evaluation set; results include attempt counts, failures and uncertainty. Untested conditions and remaining risks are listed.” Define criteria before evaluation; do not tune and certify against the same examples or infer deployment thresholds from a model benchmark.

Keep separate acceptance checks for authorized enrollment/replacement/recovery, storage confidentiality and integrity, freshness, and failure handling. None is demonstrated by successful identity recognition. The next user decision should fix the adversary's capabilities and trust assumptions; exact defenses, test counts, thresholds, usability limits and cost remain unresolved.

## Recovery-code proposal — checked 2026-08-30, not approved

Q19 assumes an uncompromised Windows host/verifier; fake-input and presentation/replay/synthetic-media tests remain required.

**Reference principles:** NIST distinguishes replacement binding from recovery after losing authentication capability. Its saved codes are securely stored offline, protected against guessing, invalidated after use and replaced. Recovery authorization depends on assurance context; a saved code alone is not universally sufficient. These are reference principles, not automatic requirements or a compliance claim. [NIST binding](https://pages.nist.gov/800-63-4/sp800-63b.html#binding-an-additional-authenticator), [saved codes](https://pages.nist.gov/800-63-4/sp800-63b.html#saved-recovery-codes), [recovery requirements](https://pages.nist.gov/800-63-4/sp800-63b.html#recovery-requirements-by-ialaal)

**Design implications, still proposed:**

- “Code required” makes it necessary for replacing owner enrollment; it does not decide whether possession alone suffices or what additional ownership evidence is required.
- If possession alone permits replacing both biometrics, a thief with the code and access to that workflow could enroll their own face/voice. Requiring both afterward would not prevent that takeover. “Not an arming code” does not remove this indirect risk.
- First enrollment needs its own trusted bootstrap procedure; an ordinary reset must not silently recreate unrestricted first enrollment.
- Decide what happens when the code is lost, stolen, or unavailable alongside failed recognition. Do not invent an unauthenticated reset; do not require successful recognition in every recovery path and thereby make recovery impossible when recognition fails.
- After authorized replacement, preserve face-and-voice verification and existing safeguards; recovery grants no flight/arming authorization. Code protection, replacement, recovery evidence and lost-code handling remain undecided.

Later guest authorization remains a separate open decision; selecting a subject never grants command authority.

## Q21 Windows account check — checked 2026-08-30, UNAPPROVED

**Q20 status:** Ticket 10 approves an offline private code as one prerequisite for lockout recovery, not sufficient authorization alone or a policy for ordinary updates, first setup or guests.

**Documented capability:** Windows offers action-specific verification using PIN/Windows Hello, including desktop interoperation. Microsoft's example verifies the logged-on user, not an independently designated drone owner. The documented desktop interface requires Windows build 22000; successful API invocation is distinct from its asynchronous verification result. [UserConsentVerifier](https://learn.microsoft.com/en-us/uwp/api/windows.security.credentials.ui.userconsentverifier?view=winrt-26100), [desktop interface](https://learn.microsoft.com/en-us/windows/win32/api/userconsentverifierinterop/nf-userconsentverifierinterop-iuserconsentverifierinterop-requestverificationforwindowasync)

**UNAPPROVED Q21 proposal:** Require fresh Windows verification of the designated owner's account alongside the recovery code, without requiring the failed drone biometrics. Account binding must distinguish the owner from another logged-on user. Cancellation, errors, unavailable verification or non-verified results cannot authorize recovery. This separates recovery evidence from drone recognition, not from Q19's host-trust assumption.

No API is selected. Offline behavior, CPU/native-Windows Python integration, account binding, supported Windows configuration and PIN-only enforcement remain unvalidated. Recovery still grants no arming permission; both drone biometrics remain required afterward.

**Decision status update, 2026-08-30:** The user subsequently approved Q21's first-PC-phase requirement for fresh owner Windows-account verification alongside the offline recovery code. See [ticket 10's dated comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments) for the authoritative scope; the preceding unapproved proposal is retained as history. This ratification does not select an API or establish offline integration, a complete recovery protocol, or lost-code/account fallback behavior.
