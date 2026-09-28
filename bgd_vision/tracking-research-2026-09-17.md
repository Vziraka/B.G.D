# Person tracking reassessment — 17 September 2026

Scope: desk-camera selected-person continuity after the observed wrong-person recovery. This is a scoped investigation and implementation recommendation, not evidence of a passing real-person test. The revised candidate is now deployed for one local physical check; full acceptance remains unfinished.

## Recommendation

Use **BoxMOT 25.0.0 DeepOcSort** with the separately provisioned **OSNet MSMT17 person-ReID encoder**, through the public direct tracker API. The isolated Pi probe established that BoxMOT preserves both IDs through the fixed synthetic crossing/complete-occlusion case where Ultralytics did not. Keep a small application gate for whether a selected target is sufficiently supported to display as Tracking. Recovery checks the frozen selected-person reference and remembered competitors as well as all currently visible candidates; a changed tracker number is allowed only after those independent checks agree. A tracker proposes associations; neither its ID nor an embedding similarity establishes personal identity.

This dependency is now justified by measured association failure, rather than added speculatively. Public-video and local-camera evaluation remain necessary; the synthetic pass does not establish real appearance accuracy.

### Executed isolated comparison

On the Pi, BoxMOT 25.0.0 and its missing import dependency SciPy 1.18.1 were installed with `--no-deps --target /home/bgd-pi/bgd-vision/candidates/boxmot25`. The base vision environment was not upgraded. The direct precomputed-embedding path imported and ran with existing Torch/NumPy dependencies; this does not establish that every optional BoxMOT feature is installed. Run this candidate with per-process `PYTHONPATH=/home/bgd-pi/bgd-vision/candidates/boxmot25`. Sources: [BoxMOT release metadata](https://pypi.org/pypi/boxmot/25.0.0/json), [SciPy release metadata](https://pypi.org/pypi/scipy/1.18.1/json). BoxMOT source identifies AGPL-3.0 licensing; SciPy distribution metadata identifies BSD licensing.

| Fixed synthetic case | Ultralytics stock | Ultralytics hard appearance veto | BoxMOT stock |
| --- | --- | --- | --- |
| Three empty observations, same-position return | Pass | Pass | Pass |
| Opposing crossing, one person fully missing for three updates, both return with original IDs | Fail | Fail | Pass |
| Different orthogonal appearance at exactly the same position retains old ID | Yes, undesirable | No | Yes, undesirable |

Ultralytics results were reported by the main integration agent; BoxMOT and its actual `PersonTracker` adapter were executed by this investigation. The runnable BoxMOT comparison is `probe_boxmot.py`; `python -m bgd_vision.tracking` exercises the active adapter. The wrong-appearance case is deliberately reported, not hidden by a success assertion.

The pinned Ultralytics merge step removes a tracked/lost pair as duplicates using IoU alone, irrespective of different descriptors. Its global helper is not a tracker-method override. A cost veto alone cannot prevent that lost-track pruning. BoxMOT maintains unmatched tracks until maximum age in its DeepOcSort implementation instead. [Ultralytics pool helper](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/trackers/utils/stracks.py), [BoxMOT tracker source](https://github.com/mikel-brostrom/boxmot/blob/master/boxmot/trackers/box/deepocsort/tracker.py)

## Primary-source comparison

| Option | Verified capability and consequential limit | Decision |
| --- | --- | --- |
| Existing ByteTrack plus custom recovery | Existing application separately associates only currently visible candidates to one positive reference. The observed single-candidate false match bypassed its uniqueness margin. | Replace association, retain explicit selected-target uncertainty. |
| Ultralytics BoT-SORT | The pinned implementation adds Kalman motion, optional ReID and camera compensation. Its final association cost is the minimum of motion and appearance cost; rejecting an appearance match does not veto a strong positional match. | Established option, but changing to it alone does not fix the demonstrated failure. |
| Ultralytics Deep OC-SORT | Already included in 8.4.154. Adds observation history, observation-centric recovery and confidence-adaptive appearance updates. Also uses minimum-cost appearance fusion, so it still needs the selected-target veto. | Investigated; synthetic complete-occlusion crossing failed even with an association veto. |
| Ultralytics TrackTrack | Weighted appearance/motion cost instead of minimum fusion; missing descriptors fall back to motion. Uses IoU support and optional relaxed rebinding. A weighted cost is still not a hard appearance veto. | No demonstrated reason to adopt its additional association paths first. |
| BoxMOT DeepOcSort | Maintainer documents appearance embeddings supplied externally or produced by a ReID backend, with adaptive appearance/motion association. | Current candidate after the measured synthetic improvement. |

Sources: [pinned BoT-SORT](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/trackers/bot_sort.py), [pinned Deep OC-SORT](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/trackers/deep_oc_sort.py), [pinned OC-SORT recovery](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/trackers/oc_sort.py), [pinned TrackTrack](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/trackers/track_tracker.py), [BoxMOT maintainer documentation](https://mikel-brostrom.github.io/boxmot/trackers/deepocsort/).

## Active BoxMOT runtime seam

`from boxmot import DeepOcSort; from boxmot.structures import Boxes, Detections`.
Construct `DeepOcSort(cmc_off=True, use_embeddings=True, min_hits=1, det_thresh=0.35, max_age=30)`.
Pass `Detections(geometry=Boxes(float32_Nx4_tensor), scores=float32_N_tensor, class_ids=int64_N_tensor, sample_id=str, embeddings=float32_Nx512_tensor)` and the BGR frame into `tracker.update(batch, frame)`.
Read `Tracks.geometry.values`, `track_ids`, `scores`, and `detection_indices`. These signatures were inspected and executed against the installed 25.0.0 wheel. The adapter computes appearances once, drops unusable descriptors, maps output indices to that filtered detection batch, and advances with empty observations. All selection timestamps remain exposure-based; `max_age` remains a count of processed updates, not a wall-clock loss deadline.

## Investigated Ultralytics runtime seam (not active)

`DeepOCSORT(args)` consumes `tracker.update(result.boxes.cpu().numpy(), frame, feats=features)`. The output for axis-aligned boxes is `[x1,y1,x2,y2,id,score,class,original_detection_index]`; the pinned base tracker restores the index after confidence filtering. Map descriptors through that index, not the position in the returned track list. Advance the tracker on empty detections too. [Pinned base tracker](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/trackers/byte_tracker.py)

For this direct API, `with_reid: true` and `model: auto` use supplied feature arrays through the shared pass-through encoder. This is deliberately different from calling `YOLO.track()` with the same configuration: its callback falls back to `yolo26n-cls.pt` when native detector feature hooks are unsupported, including the NCNN detector path. Therefore do not route this configuration through `model.track()` or assume `auto` means a person-ReID network. The shared encoder also recognizes dedicated `yolo26n-reid.onnx` assets, but the current OSNet runtime is separately provisioned. [Pinned shared encoder](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/trackers/utils/reid.py), [pinned callback](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/trackers/track.py)

Start with fixed-camera GMC disabled, low-confidence ByteTrack second association disabled, and a 30-update track buffer. Preserve the repository's detection thresholds. These are engineering starting values, not calibrated accuracy thresholds. The buffer counts inference updates, not camera frames or seconds: at 5 updates/second, 30 updates is about six seconds. The UI freshness/loss deadline must use camera exposure timestamps independently. [Pinned configuration](https://raw.githubusercontent.com/ultralytics/ultralytics/v8.4.154/ultralytics/cfg/trackers/deepocsort.yaml)

## Initial selected-target review — subsequent decisions below supersede ID/deadline restrictions

These conclusions are engineering review of the local selector, rather than claims made by tracker authors.

1. **Remember the competing person.** Freeze the target descriptor and descriptors of clearly separated nearby competitors before an overlap. During recovery, compare a candidate both to the target and these remembered competitors, even when the target is completely hidden and only its occluder remains. Comparing only currently visible candidates gives that sole occluder an artificial uniqueness win. Do not add mixed/overlapping crops to either reference. If target and competitor references are inseparable, remain uncertain.
2. **Require evidence for every green state.** The old same-ID path accepted similarity at least 0.80 and slowly adapted the reference, even though recovery used 0.90. An ID swap can therefore remain green without ever entering recovery. Check supported appearance and ambiguity on continuity as well as on recovery. A three-frame stable wrong association is still wrong; raising 0.90 slightly above the observed 0.939 does not establish a calibrated solution.
3. **Let the established tracker handle association.** The selector should not assign a new ID because it wins its own cosine ranking. It can resume a supported original track after a short gap, with clear separated observations and competitor vetoes; otherwise it reports uncertainty or terminal loss. Tracker reuse of the same ID must not bypass the gate.
4. **Separate absence display from association memory.** Immediately stop green Tracking on missing/ambiguous observations. The original accepted requirement is Lost within one second after full exit, followed by explicit reselection. Keep that deadline and terminal latch independent of the tracker's longer internal buffer. Recovery is only eligible before terminal loss. A longer automatic recovery window after total disappearance changes that accepted behavior; it must not be introduced merely by raising the buffer.
5. **The 0.9-second timeout is short at five updates/second.** Three clear observations already span about 0.4 seconds. An overlap consuming more than roughly half the window leaves little opportunity to recover. Extending only the overlap/Checking period while the selected person remains visibly supported can help ordinary crossings, but complete disappearance still uses the <=1-second terminal deadline. Repeated occluder observations must not restart the missing-target clock.
6. **Physical exit versus complete occlusion is not perfectly observable.** A camera alone may see the same missing-detection sequence for either event. Do not claim guaranteed long-occlusion recovery and guaranteed terminal loss within one second of every hidden exit simultaneously. Keep conservative uncertainty and document what duration the replay actually supports.

Negative memory is a veto, not another identity classifier. Missing or uninformative competitor evidence must not be interpreted as proof that the remaining person is the selected person. Threshold calibration needs separate positive and negative examples, including similar clothing and back/side views.

## Small public replay fixture

The University of Edinburgh CAVIAR publisher provides **EnterExitCrossingPaths1cor**, approximately 2 MB as MPEG, with hand-labeled XML. It is much smaller than downloading a full MOT dataset. The publisher describes downloadable data and asks publications to acknowledge the EC Funded CAVIAR project/IST 2001 37540. No standard SPDX license or general commercial redistribution grant was identified on that page. Keep downloaded test media in the local ignored cache; cite the source, do not describe it as public domain, and do not bundle it into the application. [Official dataset and terms](https://groups.inf.ed.ac.uk/vision/DATASETS/CAVIAR/CAVIARDATA1/)

- [Crossing video](https://groups.inf.ed.ac.uk/vision/DATASETS/CAVIAR/CAVIARDATA2/EnterExitCrossingPaths1cor/EnterExitCrossingPaths1cor.mpg)
- [Ground-truth XML](https://groups.inf.ed.ac.uk/vision/DATASETS/CAVIAR/CAVIARDATA2/EnterExitCrossingPaths1cor/ceecp1gt.xml)
- [Alternate crossing view](https://groups.inf.ed.ac.uk/vision/DATASETS/CAVIAR/CAVIARDATA2/EnterExitCrossingPaths1front/EnterExitCrossingPaths1front.mpg)
- [Alternate-view ground truth](https://groups.inf.ed.ac.uk/vision/DATASETS/CAVIAR/CAVIARDATA2/EnterExitCrossingPaths1front/feecp1gt.xml)

Recommended replay: choose and record a ground-truth person before crossing, run the actual detector/encoder/tracker/selector on timestamped frames at the Pi's observed inference cadence, and measure wrong-person green frames, clearly-visible selected-person coverage, recovery time, and terminal-loss behavior. Fix that interval before tuning; use a second interval/view as holdout. An identity switch hidden by a long Checking/Lost period is not a successful continuity result. Actual clip suitability and frame intervals still need inspection; the source listing alone does not prove the fixture contains the exact failure.

Synthetic tracker probes complement this replay: identical-position wrong appearance, two opposing tracks with one fully missing, stale frames, and terminal loss followed by same-ID return. They test integration and state semantics; they do not validate OSNet accuracy, camera quality, or flight behavior. Real local crossings remain a final bounded check after replay, not the debugging loop.


## First measured candidate replay

The full383-frame CAVIAR corridor fixture at25fps was evaluated once using shared YOLO26n detections. The first run used conf0.1/default max_det300; the revised harness aligns these to the live conf0.15/max_det10 for subsequent revisions. Greedy one-to-one IoU>=0.5 matching excludes GT pairs overlapping>=0.3; these are proxy counts, not standard MOT metrics.

ByteTrack:1075 matches of1335 eligible GT observations,260 missing,1 matched-ID change. Stock DeepOCSORT+OSNet:1012 matches,323 missing,2 matched-ID changes. For the once-selected GT0, the stricter selector had97.32% eligible correct coverage,0 matched wrong-person Tracking frames, and one Checking→Tracking recovery (frames106→126). Its actual GT0 overlap was108–117,0.4s. This does not establish broad improvement or local-camera acceptance.

The actual library integration probe exposed a separate failure: a three-frame absence recovered, but synthetic opposing crossings did not preserve both IDs. Identical-position wrong-appearance observations also retained the prior ID. A small appearance-veto subclass repaired the latter but not the crossing failure. Pinned library pool merging also prunes overlapping tracked/lost entries based on geometry alone; this motivates evaluating BoxMOT rather than accumulating overrides around library internals.

[Retained first report](evidence/caviar-baseline-proxy-2026-09-17.json). The live camera service remained active throughout; initial default-thread detector timings are not isolated or representative live performance. No user video was saved. Automatic recovery remains disabled pending further validation.


## Approved recovery policy and measured limitations

The owner explicitly approved up to three seconds of **Temporarily hidden**, with no green box, for ambiguous blockage/hidden exit. Stale inference still expires at 750 ms and terminal Lost requires manual reselection. The initial engineering-only same-ID restriction was removed after BoxMOT assigned a new ID to the returning correct person. Both people must be separately visible; positive similarity, remembered competitor rejection, current competitor margin, spatial support and temporal evidence remain necessary.

With this revision, corridor1 recovered once after 0.84 seconds, with 97.05% eligible correct coverage and no matched wrong-person Tracking frames. The alternate front view never provided a selectable clear target: its selector result is inconclusive, not a pass. In corridor2, GT2 was chosen from labels before inference because it had a clear approach and a crossing. That run failed recovery (88.14% eligible coverage, no matched wrong-person Tracking). These are small public-video proxy evaluations, not standard MOT metrics or live qualification.

The retained corridor2 trace isolates the failure: after separation the correct person was detected and was the strongest appearance candidate at frames 219–231. A fixed pre-blockage position rejected otherwise strong observations at 224 and 226; appearance fluctuated around the provisional 0.90 threshold. From frame 232 the detector missed the selected person. Increasing detector input from 320 to 640 did not recover those missing detections and raised median detection time from 23.9 to 96.6 ms. Keep 320; do not interpret the missing-detection interval as a recoverable valid candidate or remove the competing-person requirement to pass it.

Reports are retained in `evidence/caviar-boxmot-recovery-3s-2026-09-17.json`, `caviar-front-boxmot-recovery-3s-2026-09-17.json`, `caviar-cor2-boxmot-recovery-3s-2026-09-17.json`, `caviar-cor2-diagnostic-trace-2026-09-17.json`, and `caviar-cor2-320-vs-640-2026-09-17.json`. Public fixtures used to diagnose changes are now development examples, not untouched holdouts.


### Motion and evidence accumulation repair

A bounded constant-velocity fit now uses only recent clear selected-person observations; prediction and appearance memory freeze through uncertainty. Predicted displacement is capped at two original spatial radii, with residual uncertainty capped at one quarter radius. This fixes the stationary-position assumption without allowing arbitrary jumps. Sharp acceleration or turns may still fail the gate.

The strong-positive threshold remains0.90. Confirmation requires at least three strong observations spanning150ms inside500ms. One0.80–0.90 observation may preserve that sequence only if both competitor margins and every geometry/separation check pass; it never counts or completes recovery. A second weak observation or contradictory evidence resets it. This addresses frame-to-frame crop variation without treating a weak appearance match as a recovered identity.44 vision tests cover recovery, incorrect substitution, bounded motion, weak evidence, expiry, stale input and HTTP controls;35 simulator tests also pass. Final replay results are recorded separately.


Final motion/temporal replays used identical source hashes. Corridor1 recovered after0.84s with97.05% eligible coverage; corridor2 recovered after0.72s with90.25% coverage before a later appearance/detection failure. Neither showed a matched wrong-person Tracking frame. Corridor2 remains below95%; these clips are development evidence, not proof of generalization. Reports: `evidence/caviar-cor1-motion-temporal-2026-09-17.json` and `caviar-cor2-motion-temporal-2026-09-17.json`. The live candidate has been deployed and browser/runtime/source-hash checked; one local crossing and full acceptance remain.
