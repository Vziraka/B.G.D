# Pi CPU thread comparison — 22 September 2026

The owned Pi 5 was reachable; its camera service was stopped after a reboot. Starting the existing service restored 30 capture/vision fps without a power or thermal flag. Tests below used the existing YOLOE-26n weights and eight-label prompt profile, confidence 0.1, fresh live camera frames, unchanged NCNN service and visible private browser. The camera saw a static wall/ceiling, so these are compute comparisons, **not target accuracy or active person/object tracking qualification**. No images or biometric features were saved.

## Matched short runs

| Input / Torch threads | Inferences | Model fps | Full-loop fps | Median model-call ms | Minimum vision fps | Minimum display fps | Maximum browser delay p95 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
|320 /3|180|3.01|2.90|336.5|25.2|25.49|186.7|
|320 /1|180|6.35|5.93|157.8|28.9|26.29|138.2|
|320 /2|180|4.05|3.87|249.0|25.7|12.64|231.6|
|640 /3|30|1.40|1.37|729.3|20.9|20.47|277.6|
|640 /1|30|1.97|1.93|508.1|27.3|20.67|220.3|

Every run had no service error or throttle/power flag and stayed below 68 C. The two-thread run **fails** the existing 15 fps display floor. Other short runs pass the sampled 15 fps / 300 ms / 80 C limits. Browser/network variability remains possible; no tab interactions occurred during comparisons. Short runs do not resolve the historical ten-minute qualification by themselves.

One thread improved model throughput 2.11x at 320 and 1.41x at 640 while increasing vision throughput. Resolution, weights and confidence were unchanged. Sequential unannotated live frames are not an accuracy comparison. Model-only throughput omits frame retrieval; the new `end_to_end_fps` includes it.

Raw numeric samples and configuration:

- `perf-three-20260922.json`
- `perf-one-20260922.json`
- `perf-two-20260922.json`
- `perf-640-3-20260922.json`
- `perf-640-1-20260922.json`

## Mechanism and regression

Installed Ultralytics 8.4.154 `select_device` calls `torch.set_num_threads(NUM_THREADS)` for CPU; `NUM_THREADS` is 3 on this four-core Pi. Merely selecting a smaller count before predictor creation therefore does not preserve the requested budget. The production adapter now registers the documented `on_predict_start` callback, restoring 1 thread for ordinary and replacement visual-prompt predictors. The existing adapter lock serializes its text/visual calls. NCNN's own 2-thread net remains unchanged.

Actual Pi regression command, using already installed model assets:

```sh
BGD_MODEL_TESTS=1 .venv/bin/python -m unittest test_open_vocabulary_performance -v
```

The copied repository test is `tests/vision/test_open_vocabulary.py`. Old adapter: **FAIL, 3 != 1**. Updated adapter: **PASS, 9.053 seconds**. It checks text detection, initial visual prompting and refreshed visual prompts. Raw outputs for the same seeded synthetic tensor match between 3 and 1 threads within `rtol=1e-3,atol=1e-4`. This checks numerical preservation, not recognition accuracy.

`benchmark_workload.py` retains only whitelisted numeric service measurements, flags a missing/hidden preview as incomplete, and fails the unchanged 15 fps / 300 ms criteria. A local regression supplies the historical 14.2 / 14.5 fps misses and verifies both failures rather than averaging them away. Temperature/power/error checks are included; memory time-series interpretation remains explicit.

Sources rechecked 22 September 2026: [PyTorch thread API](https://docs.pytorch.org/docs/2.14/generated/torch.set_num_threads.html), [Ultralytics CPU device selection](https://docs.ultralytics.com/reference/utils/torch_utils/), [Ultralytics prediction callbacks](https://docs.ultralytics.com/usage/callbacks/). The installed package source, rather than current web-version assumptions, establishes the actual reset-to3 behavior.

## Sustained acceptance

The integrated UI/service deployment matched all transferred source/UI file hashes. The final full vision suite ran147 tests locally with5 expected skips and on the Pi with3 expected skips; all remaining tests passed. The final restart loaded the hash-matched source. Vision rose from a13.6fps startup sample to20.5–21.4fps over the next four samples while a person was detected, then returned to30.0fps at uptime589seconds with30.0 capture fps,22.1ms inference,59.8C,0x0 power flags, no error and a visible29.997fps browser. This is post-deployment health, not another sustained run.

The sustained run started `2026-09-22T06:17:07Z`, finished `06:27:14Z`, returned0 without timeout and retained599 service samples over606.49seconds. Minimum vision/display rates were28.0/15.0499659fps; maximum browser-delay p95 was240.1ms and maximum temperature68.1C. Every throttle value was0x0 and no application error occurred. Service memory stayed456.4–462.7MB; the first/last60-sample means were458.955/460.197MB (+1.242MB) while the first/last samples were456.6/456.4MB, so the bounded series shows no clear monotonic growth. The display floor passed by only0.0499659fps and should not be described as generous margin.

The parallel benchmark completed3,413 inferences in600.18seconds:5.69 end-to-end fps,6.08 sustained model fps,162.1ms median/172.3ms p95 model inference, one Torch thread, and435.2→438.2MB benchmark-process RSS. Full raw evidence is [`perf-sustained-integrated-20260922.json`](perf-sustained-integrated-20260922.json), SHA-256 `b6fdf297905967f875ff0c433114e57cf00a738a607e8f1b2215484dc4b9436d`. The camera viewed a static wall/room; this qualifies measured compute contention only. Broad recognition, active tracking/occlusion, voice reliability, moving-camera operation and flight remain separate qualifications.
