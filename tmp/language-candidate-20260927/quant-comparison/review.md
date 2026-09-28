# Same-weight precision comparison — 27 September 2026

Decision: **do not adopt Q6_K**. The public `bartowski/Qwen_Qwen3.5-4B-GGUF` Q6_K file was downloaded at pinned revision `4168f45a16a1290d65a4ec0fa312ae917a4c15d6`; its 3,805,358,048-byte size and SHA-256 `5a5bc7a3f9375b395e9f81fb69109038cf160c84606b8192f13cbb8355ca59f2` match the Hugging Face repository metadata. Q4_K_M is 3,013,027,808 bytes. The `preflight.json` fixed the rev9 source snapshot, already-open 49-case corpus, runtime, both model hashes and acceptance before either run. Both runs used the same frozen source/prompt/schema, localhost llama.cpp b11095 with two CPU threads, seed and 30-second evaluation timeout. The server stopped between runs; `q4/` and `q6/` contain raw model diagnostics, per-case routes/results and manifests. This was PC text-only development evidence, not a sealed or Pi trial.

| Format | Exact | Consequential | Ordinary | Cold first model request | Model median / p95 |
| --- | ---: | ---: | ---: | ---: | ---: |
| Q4_K_M | 47/49 | 19/19 | 28/30 | 25.729 s | 4.193 / 9.727 s |
| Q6_K | 46/49 | 17/19 | 29/30 | 30.011 s timeout | 5.125 / 8.235 s |

Q6 corrected the two Q4 location-question false clarifications (`d03`, `d05`), but its first follow request timed out even at the 30-second evaluation cap. More seriously, for `fn02` (“Never continue observing the yellow cup”) it proposed `follow yellow cup` plus `scout`, reversing explicit negation. For `b19` (“Could you guide me to the teal vase”) it proposed targetless `scout` for a navigation request. Those proposals remained diagnostic-only, but they are consequential meaning failures. Q6 violates the predeclared no-consequential-regression gate and is slower on warm median requests. The eight-second production client timeout remains incompatible with either format's cold request.

The one-off Windows process working-set samples were ~4.68 GB for Q4 and ~4.15 GB for Q6, taken at different times during their runs. Windows file mapping/cache behavior and non-matched sampling make these **unsuitable as a Pi memory comparison**. Q6's on-disk artifact is 792,330,240 bytes larger. No Pi load or thermal conclusion is drawn. Q4 remains the experimental baseline while the deterministic boundary and targetless-scout acceptance are repaired. No weights were fine-tuned.
