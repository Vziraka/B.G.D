"""Ticket 01: public readiness workflow; fixtures contain no biometrics."""

import tempfile
import unittest
from importlib.metadata import PackageNotFoundError
from types import SimpleNamespace
from pathlib import Path
from unittest.mock import patch

from pc_biometric.workflow import Check, DeskWorkflow


class ReadinessTests(unittest.TestCase):
    def test_unsupported_windows_and_wrong_package_version_are_not_available(self):
        with tempfile.TemporaryDirectory() as directory:
            with patch("sys.getwindowsversion", return_value=SimpleNamespace(build=19045)), \
                 patch("importlib.metadata.version", return_value="0.0.0"):
                report = DeskWorkflow(Path(directory), device_probe=lambda: ()).refresh()
            self.assertEqual(next(c.state for c in report.checks if c.group == "Platform"), "Failed")
            runtimes = [c for c in report.checks if c.group == "Runtime"]
            self.assertTrue(all(c.state == "Failed" for c in runtimes))
            self.assertFalse(report.authorized)

    def test_present_files_and_enumerated_devices_stay_unverified(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            speaker = root / "vosk-model-spk-0.4"
            speaker.mkdir()
            for name in ("final.ext.raw", "mean.vec", "transform.mat", "mfcc.conf"):
                (speaker / name).write_bytes(b"synthetic placeholder, not biometric data")
            workflow = DeskWorkflow(root, device_probe=lambda: (
                Check("Devices", "Camera", "Unverified", "Enumerated; capture untested"),
            ))
            report = workflow.refresh()
            self.assertEqual(next(c.state for c in report.checks if c.name == "Speaker recognition"), "Failed")
            self.assertFalse(report.authorized)
            self.assertFalse(report.capture_active)
            for page in ("Setup", "Account", "Recovery"):
                self.assertIn("not available", workflow.task(page)[2])
            self.assertIn("Development only", workflow.task("Verify")[2])

    def test_missing_runtime_and_failed_device_query_are_actionable_and_private(self):
        def broken_devices():
            raise OSError("sensitive device details must not be shown")

        with tempfile.TemporaryDirectory() as directory:
            with patch("importlib.metadata.version", side_effect=PackageNotFoundError):
                report = DeskWorkflow(Path(directory), device_probe=broken_devices).refresh()
            runtimes = [check for check in report.checks if check.group == "Runtime"]
            self.assertTrue(runtimes)
            self.assertTrue(all(check.state == "Missing" for check in runtimes))
            self.assertTrue(any(check.state == "Failed" for check in report.checks))
            self.assertNotIn("sensitive", str(report))
            self.assertFalse(report.authorized)

    def test_damaged_or_incomplete_models_do_not_become_ready(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "face_detection_yunet_2023mar.onnx").write_bytes(b"not a model")
            (root / "vosk-model-spk-0.4").mkdir()
            report = DeskWorkflow(root).refresh()
            models = {check.name: check for check in report.checks if check.group == "Models"}
            self.assertEqual(models["Face detection"].state, "Failed")
            self.assertEqual(models["Speaker recognition"].state, "Missing")
            self.assertFalse(report.authorized)

    def test_launch_with_missing_models_explains_blockers_without_authorizing(self):
        with tempfile.TemporaryDirectory() as directory:
            with patch("socket.socket.connect", side_effect=AssertionError("network used")):
                report = DeskWorkflow(Path(directory)).refresh()
            models = [check for check in report.checks if check.group == "Models"]
            self.assertEqual(len(models), 4)
            self.assertTrue(all(check.state == "Missing" for check in models))
            self.assertTrue(all("Install" in check.detail for check in models))
            self.assertFalse(report.authorized)
            self.assertFalse(report.capture_active)
            self.assertEqual(list(Path(directory).iterdir()), [])


if __name__ == "__main__":
    unittest.main()
