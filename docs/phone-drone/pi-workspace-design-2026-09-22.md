# Pi camera workspace — 22 September 2026

The owner authorized improvements to tracking, natural speech, Pi performance under load, and the difficult desk-test interface using existing hardware. Engineering details and test cases are delegated. Native phone delivery remains after first hover; this browser workspace exercises camera tasks without aircraft output.

## Accepted interaction

The default workspace combines a live camera, persistent selected-target state, and a conversation. A request produces an exact action/target proposal. The owner confirms that proposal with its button or a deliberately recorded “yes”; a correction replaces it. A proposal expires after 45 seconds and can be consumed only once. Cancel discards the proposal; Stop cancels pending work and clears both trackers immediately. Status does not need confirmation. Model output never directly controls hardware.

Keep meaningful answers visible in the conversation and speak them using an installed local browser voice when available. Recording is deliberate, at most 30 seconds, and local Pi transcription uses temporary audio discarded after processing. Speech recognition does not establish speaker identity. Camera images and temporary biometric/object references are not uploaded for language interpretation. Online assistance remains an optional future path; none is configured or enabled by this implementation.

The conversation records up to 30 messages in the current page only. Restarting discards temporary enrollment. Confirmation identifiers and pending text are excluded from public camera/status telemetry. Existing session authentication and loopback SSH transport remain in place.

## Design and implementation

[Editable Figma design](https://www.figma.com/design/y6naEaCOp7cpkXOsdn6Ga6?node-id=2-129) contains the desktop camera, persistent target card, conversation, exact-task review, composer, and Stop control. It uses an illustrative camera placeholder; private camera imagery was not sent to Figma. The implementation adapts that design to the existing plain HTML/CSS/JavaScript app without a frontend framework or new runtime dependency.

Mobbin search was attempted through the requested connector, which reported that a paid plan is required. No Mobbin screens were retrieved and no subscription was purchased.

- Conversation opens first; Face setup and Test tools retain the diagnostic controls.
- Performance, range experiments, categories and raw task details use expandable sections.
- Stop stays available when scrolling and when video is expanded.
- The narrow layout stacks the camera and conversation with touch-sized primary controls, visible keyboard focus, a skip link, status announcements and reduced-motion handling.
- Connection labels distinguish connecting, live and interrupted video. Stale person/object boxes are suppressed at display time, including transfer delay. Searching does not imply a trusted target.
- The language capability label distinguishes limited commands from an experimental local language model. The interface must not imply unrestricted natural understanding when that candidate has not qualified.

Design rationale: keep current system state visible, disclose advanced tools when requested, and require review where an ambiguous request could change the selected target. Sources: [Nielsen Norman Group, progressive disclosure](https://www.nngroup.com/articles/progressive-disclosure/), [confirmation dialogs](https://www.nngroup.com/articles/confirmation-dialog/), [W3C status messages](https://www.w3.org/WAI/WCAG21/Understanding/status-messages), [minimum target size](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum). These informed the design; this is not a full accessibility conformance audit.

## Verification and remaining physical evidence

Browser review used the real local application at desktop width and a 390 × 844 viewport. There was no horizontal overflow. Exercised request → exact review → confirmation, correction replacing an earlier proposal, Stop, and expanded-video Stop. The camera-free local preview reported missing fresh observations rather than inventing a count.

Node regressions cover pending microphone permission after Stop, obsolete audio never uploaded, exact proposal binding, one-shot confirmation, out-of-order replies, literal text rendering, stale camera overlays and stopped face guides. Python tests cover proposal expiry, model response validation, authentication, cancellation during interpretation/detection/tracker initialization, and bounded person recovery. These do not establish natural-language accuracy, identity accuracy, moving-camera tracking or flight readiness.

The final Pi measurements are maintained in [CPU/load evidence](../../bgd_vision/evidence/pi-thread-budget-2026-09-22.md); candidate language results in [language research](../research/pi-conversation-design-2026-09-22.md); person recovery limits in [tracking evidence](../../bgd_vision/evidence/person-bounded-search-2026-09-22.md).

After automated work, consolidate only changed behavior into one physical session: review and correct a spoken task; confirm the exact proposal; interrupt it using Stop; briefly hide the selected person for 3–10 seconds; and check a lookalike/competing-person case. Preserve previously accepted unchanged tests. A live actor, different people/lighting and an accurate physical latency measurement remain necessary to qualify those outcomes.
