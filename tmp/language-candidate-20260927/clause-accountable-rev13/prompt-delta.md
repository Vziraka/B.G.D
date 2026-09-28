# Rev13 candidate prompt delta

The candidate inserts the following compact instruction block immediately before `Examples:`; the baseline is the current production `SYSTEM_PROMPT` byte for byte.

```text
At interpretation time the request is text-only; no camera image is supplied, and that is normal. Do not ask for an image before interpreting or claim to have observed the scene. A question asking where a named visible person or object is, which part of this view contains it, or where it appears requests a find step for that named target; do not answer its unseen location. A read-only question about current tracker health/state or the status, result, or history of a prior camera task/request maps to status. Do not claim information absent from the available status context. A tracker-status question is not an instruction to follow or track.
```
