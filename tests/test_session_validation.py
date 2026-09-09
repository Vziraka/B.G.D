"""Noninteractive checks for the explicit real-session validation harness."""

import unittest
from pathlib import Path
import tempfile

from session_lock_validation import different_console_session, write_report


class SessionValidationTests(unittest.TestCase):
    def test_only_a_real_different_console_session_counts_as_an_account_switch(self):
        self.assertFalse(different_console_session(-1, 1))
        self.assertFalse(different_console_session(0xFFFFFFFF, 1))
        self.assertFalse(different_console_session(1, 1))
        self.assertTrue(different_console_session(2, 1))

    def test_new_attempt_atomically_replaces_a_stale_success_with_incomplete(self):
        with tempfile.TemporaryDirectory() as directory:
            report = Path(directory) / "result.txt"
            report.write_text("passed=True complete=True\n", encoding="utf-8")
            write_report(report, "passed=False mode=switch complete=False")
            self.assertEqual(report.read_text(encoding="utf-8"),
                             "passed=False mode=switch complete=False\n")
            self.assertFalse(report.with_suffix(".pending").exists())


if __name__ == "__main__":
    unittest.main()
