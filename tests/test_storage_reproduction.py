"""Storage concurrency regression: synthetic workflows, isolated HKCU/DPAPI/files."""

from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import random
import subprocess
import sys
import tempfile
import time
import unittest

from pc_biometric.enrollment import Enrollment, References
from pc_biometric.storage import ProfileStore, StorageError
from registry_fixture import authority_for


REOPEN = r'''
import json, sys, winreg
from pathlib import Path
from pc_biometric.authority import RegistryAuthority
from pc_biometric.storage import ProfileStore
for directory, key in json.load(sys.stdin):
    authority = RegistryAuthority(key=key, hive=winreg.HKEY_CURRENT_USER)
    assert ProfileStore(Path(directory), authority).load() is not None, "Fresh process could not load committed profile"
print("fresh_process_reopen_passed=True")
'''


class StorageReproductionTests(unittest.TestCase):
    def test_temporary_open_reader_does_not_abort_enrollment_publication(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            authority = authority_for(root)
            owner = Enrollment(root, authority=authority, account=lambda: "synthetic-owner",
                               verify_windows=lambda: True, capture=lambda: References(b"face", b"voice"))
            self.assertEqual(owner.start(consented=True).state, "save-code")
            try:
                with ThreadPoolExecutor(max_workers=1) as pool:
                    with (root / "ownership.bin").open("rb"):
                        completion = pool.submit(owner.complete, code_saved=True)
                        time.sleep(.05)
                        self.assertFalse(completion.done())
                    self.assertEqual(completion.result(timeout=2).state, "enrolled")
                self.assertEqual(owner.status().state, "enrolled")
            finally:
                owner.cancel()

    def test_persistent_open_reader_fails_closed_without_publishing_authority(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            authority = authority_for(root)
            owner = Enrollment(root, authority=authority, account=lambda: "synthetic-owner",
                               verify_windows=lambda: True, capture=lambda: References(b"face", b"voice"))
            self.assertEqual(owner.start(consented=True).state, "save-code")
            started = time.monotonic()
            try:
                with (root / "ownership.bin").open("rb"):
                    self.assertEqual(owner.complete(code_saved=True).state, "unavailable")
                self.assertLess(time.monotonic() - started, 2)
                self.assertFalse(authority.read().profile)
                self.assertIsNone(ProfileStore(root, authority).load())
                self.assertEqual(list(root.glob(".pending-*")), [])
            finally:
                owner.cancel()

    def test_cancelled_setups_then_delayed_publication_survive_status_reads_and_restart(self):
        count = int(os.environ.get("BGD_DIAG_ITERATIONS", "1"))
        self.assertGreaterEqual(count, 1, "BGD_DIAG_ITERATIONS must include at least one regression case")
        rng = random.Random(90203)
        reopened = []
        with tempfile.TemporaryDirectory() as directory:
            for iteration in range(count):
                root = Path(directory) / str(iteration)
                authority = authority_for(root)

                def workflow(publish=None):
                    return Enrollment(root, authority=authority, publish=publish,
                                      account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                      capture=lambda: References(b"synthetic-face", b"synthetic-voice"))

                # Always cover repeated cancellation; extra opt-in iterations vary the schedule.
                for _ in range(2 if iteration == 0 else rng.randrange(3)):
                    cancelled = workflow()
                    self.assertEqual(cancelled.start(consented=True).state, "save-code")
                    cancelled.cancel()
                delay = .002 if iteration == 0 else rng.random() * .002

                def publish(candidate, _lease):
                    time.sleep(delay)
                    authority.commit(candidate.owner, candidate.profile, candidate.digest,
                                     installation=candidate.installation)

                owner = workflow(publish)
                observer = workflow()
                self.assertEqual(owner.start(consented=True).state, "save-code")
                try:
                    with ThreadPoolExecutor(max_workers=1) as pool:
                        completion = pool.submit(owner.complete, code_saved=True)
                        while not completion.done():
                            observer.status()
                        result = completion.result()
                    try:
                        readable = ProfileStore(root, authority).load() is not None
                    except StorageError as error:
                        self.fail(f"iteration={iteration} state={result.state}: {error}")
                    self.assertEqual(result.state, "enrolled",
                                     f"iteration={iteration} authority_committed={bool(authority.read().profile)} "
                                     f"public_profile_readable={readable} observer_state={observer.status().state}")
                    self.assertTrue(readable)
                    self.assertEqual(observer.status().state, "enrolled")
                    reopened.append((str(root), authority.key))
                finally:
                    owner.cancel()
            reopened_process = subprocess.run([sys.executable, "-c", REOPEN], input=json.dumps(reopened),
                                              text=True, capture_output=True, timeout=30,
                                              creationflags=subprocess.CREATE_NO_WINDOW)
            self.assertEqual(reopened_process.returncode, 0, reopened_process.stderr)
            self.assertIn("fresh_process_reopen_passed=True", reopened_process.stdout)


if __name__ == "__main__":
    unittest.main()
