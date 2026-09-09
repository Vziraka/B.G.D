# Issue 10 — no-Mac phone build options

**Decision update — Q72, 2026-08-30:** the user approved **evaluating Candidate A** as the planning direction: native iPhone app, legitimate personal signing refreshed through Windows at least every seven days, and private hosted-Mac builds within free quotas. Periodic internet/account access and maintenance are accepted; flight operation remains offline. Concrete account/device trust, installation, service setup and source uploads remain for later review, and no paid membership or overage is approved. Actual compatibility, renewal and locked/pocketed operation remain M2 engineering/device-validation gates. This update supersedes the original unselected wording below; it does not establish a working or permanently free route. See [Q72 in the decision record](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

Checked 2026-08-30. New, uncommitted research in the main checkout; not part of base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. Supports [issue 10](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments), without implementing any phone or PC ticket. No account access, installation, upload, credentials, recording or purchase occurred.

## Requirements retained

Existing iPhone 17 Pro and USB-C EarPods; no owned/borrowable Mac. Deliberately enabled voice sessions must work while locked/pocketed, with offline command/identity processing and offline inspection video/status. The independent radio, onboard face verification and owner arming requirements remain. Development can use the internet; operation cannot depend on an internet service. M2 remains the phone milestone.

## Newly resolved fact

**The previously examined $99/year EAS signing route is not the only documented route worth considering.** AltStore Classic documents personal-app installation from Windows and periodic signing renewal. Together with a hosted Mac build, that supplies a plausible no-membership-fee engineering path, with substantial maintenance/trust constraints. It is **not yet a verified build/install of this project's app**, and does not make all phone integration free or complete.

### Native audio is a supported building block

Apple documents native audio capture continuing through background/screen lock when the app declares the audio background mode and has microphone permission. Calls and other audio interruptions remain possible. Therefore native audio is the better-supported design direction for the required intentional hands-free session. Neither the API nor a selected architecture proves our recognition, anti-spoofing, network, battery or recovery behavior. A browser-only route has no equivalent project evidence here. [Apple recording category](https://developer.apple.com/documentation/avfaudio/avaudiosession/category-swift.struct/record)

### Candidate A — hosted build, personal signing on Windows

GitHub offers hosted macOS runners. Private repositories receive a plan-specific quota; GitHub Free currently lists 2,000 monthly minutes and 500 MB artifact storage. Runner charging differs by OS, so this is not 2,000 free Mac minutes. Usage/storage beyond allowances can cost money. A proposed private build workflow must block paid overages, minimize stored artifacts and pause if quota is exhausted; do not silently publish the project to obtain unlimited public-repository minutes. [GitHub billing](https://docs.github.com/en/billing/concepts/product-billing/github-actions), [runner platforms](https://docs.github.com/en/actions/reference/runners/github-hosted-runners)

AltStore's Windows installation guide requires compatible Apple device-support software, device/computer trust and Apple-account authentication through AltServer. On supported iOS versions it also requires Developer Mode. Those are security-relevant setup changes for a later explicit review, not permission to install old dependency versions automatically. The vendor says credentials go to Apple; that statement is not an independent security audit. [AltStore Windows guide](https://faq.altstore.io/altstore-classic/how-to-install-altstore-windows)

AltStore supports installing application `.ipa` files; its personal-account apps expire after seven days and stop opening unless refreshed. Automatic refresh attempts are not a reliability guarantee. Its documented limit is three concurrently sideloaded apps. Apple independently documents seven-day Personal Team provisioning expiry. [AltStore app installation](https://faq.altstore.io/about-us/press-kit), [refresh and limits](https://faq.altstore.io/altstore-classic/your-altstore), [Apple membership comparison](https://developer.apple.com/support/compare-memberships/)

**Engineering proposal/inference:** compile our own native device binary on an authorized private hosted Mac, download it and apply legitimate personal-device signing locally with AltServer/AltStore. Do not send Apple credentials, device pairing material, faceprints, voiceprints or recovery codes into cloud builds. Use compiled/local model execution rather than assuming access to JIT or special entitlements. Exact SDK/device compatibility, packaging, entitlement eligibility, installation and refresh still require an M2 build/device spike. No workaround to platform access controls or third-party app redistribution is proposed.

**Cost treatment:** $0 proposed membership/build-service fee only while the selected tools and private free quota suffice. Weekly maintenance, internet/account access for refresh, compatibility repair and possible quota exhaustion are real obligations. If an entitlement or build path requires payment, stop and revise the cost/decision; do not assume an approved $99 fallback. An expired or interrupted controller must not affect independent emergency radio control.

### Candidate B — hosted native build with paid Apple signing

The earlier [phone feasibility report](iphone-handheld-feasibility.md#q47-supplement--windows-development-without-a-mac) documents Expo's Windows-triggered cloud build route and its paid-signing prerequisite for physical iPhone builds. Apple lists membership at **$99 per year**; EAS has a free tier with usage limits. Membership is not a promise of permanent installation, successful review or no other maintenance. Budget the first membership period in the initial build and disclose later renewals; any renewal needed before project completion is still an initial-build cost. [Expo build paths](https://docs.expo.dev/develop/development-builds/introduction/), [Expo build prerequisites](https://docs.expo.dev/build/setup/), [Apple membership comparison](https://developer.apple.com/support/compare-memberships/)

This candidate avoids relying on the Personal Team weekly renewal policy, but adds an unapproved recurring fee and still needs integration/device validation. No payment or source/signing upload is authorized.

### Candidate C — browser-only controller

A website avoids native signing but has not established the required locked-screen microphone/model/link behavior on this phone. Foreground inspection UI remains technically distinct from background voice control. Do not mark browser-only feature parity resolved or replace the required locked/pocketed sessions with keeping the screen on. Research did not prove universal impossibility; this is an unsupported alternative for the present baseline.

## Decision and validation boundary

| Item | Classification | Closure treatment |
| --- | --- | --- |
| Native versus browser direction | Answerable now | Recommend native for the documented background-audio capability; user selects the maintenance/cost tradeoff. |
| Weekly personal signing versus paid membership | Answerable now | Present the complete BOM impact first. Recommend evaluating Candidate A before accepting a fee, if the user accepts weekly upkeep and later trust/setup review. Neither route is selected yet. |
| Cloud source handling | Answerable now | Propose private source-only builds, no biometric/account secrets, quota limits; actual service setup/upload requires separate authorization. |
| SDK/entitlement/packaging build | Answerable now, future software engineering | A named M2 build spike precedes integration; actual code is not required to finish issue 10's sketch-level roadmap. If it fails, revise the route before spending on dependent hardware. |
| Installation/renewal on actual iPhone | Requires physical validation | Test installed OS, legal personal provisioning, expiry behavior, manual refresh and state preservation before accepting the route for use. No aircraft is needed for this test. |
| Locked/pocketed microphone, local recognition/video/link workload | Requires physical validation | Test with user-consented audio, local models and internet unavailable; include calls, headset unplug, lock/unlock, restart, termination, stale results and loss of local Wi-Fi. No automatic authorization or impact on emergency radio. |
| 100 m local link and concurrent RC/video | Requires physical validation | Ground range/coexistence evidence before flight integration; no range guarantee from Wi-Fi presence. |

Physical tests remain future work, not perpetual planning questions. Choosing Candidate A would acknowledge a conditional implementation route, not prove a complete secure phone controller or approve a device/account change.
