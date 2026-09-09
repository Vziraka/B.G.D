# PC biometric development checks

Run from the repository root with the existing Windows environment. Automated tests
use synthetic biometric inputs and temporary files/isolated HKCU fixtures; some open
Tk windows and exercise real Windows storage and process boundaries. They do not run
the manual camera, microphone, Windows verification or UAC validation harnesses.

For a change, run the affected test modules first. Run the full suite once before
handoff; repeat it only after a relevant change or failure:

```powershell
.scratch/pc-biometric-desk/.venv/Scripts/python.exe -m unittest discover -s tests -v
```

The storage concurrency regression defaults to one fixed scenario: two cancelled
setups, delayed publication during status reads, and a fresh-process reopen. The
separate temporary/persistent open-reader regressions remain in the ordinary suite.
For storage/concurrency changes, opt into a longer sweep with `BGD_DIAG_ITERATIONS`
(positive integer; the first scenario stays fixed, additional scenarios vary their
cancellation count and delay):

```powershell
$testPreviousIterations = $env:BGD_DIAG_ITERATIONS
try {
    $env:BGD_DIAG_ITERATIONS = '100'
    .scratch/pc-biometric-desk/.venv/Scripts/python.exe -m unittest discover -s tests -p test_storage_reproduction.py -v
} finally {
    $env:BGD_DIAG_ITERATIONS = $testPreviousIterations
}
```

Keep device/participant validation separate and use its approved session consent and
data plan. Passing synthetic checks does not establish biometric accuracy, timing,
spoof resistance or aircraft acceptance. Existing manual harnesses remain available;
their filenames intentionally do not match default `test_*.py` discovery.
