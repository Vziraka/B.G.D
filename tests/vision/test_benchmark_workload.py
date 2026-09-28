import unittest

from bgd_vision.benchmark_workload import assess, sample_status


class WorkloadEvidenceTests(unittest.TestCase):
    def test_floor_and_missing_preview_cannot_pass(self):
        status = {"capture_fps": 30, "vision_fps": 14.2, "inference_ms": 20,
                  "hardware": {"temperature_c": 65, "memory_mb": 470, "voltage_v": 5,
                               "throttled": "0x0"},
                  "client": {"visible": True, "display_fps": 14.5,
                             "latency_upper_p95_ms": 240},
                  "tracks": [{"secret": "must not persist"}]}
        sample = sample_status(status)
        result = assess([sample], 0)
        self.assertEqual(result["failures"], ["vision_fps_below_floor", "display_fps_below_floor"])
        self.assertNotIn("tracks", sample)
        status["vision_fps"] = 30
        status["client"]["display_fps"] = 30
        self.assertEqual(assess([sample_status(status)], 0)["verdict"], "pass")
        status["client"]["available"] = False
        self.assertEqual(assess([sample_status(status)], 0)["verdict"], "incomplete")
        self.assertEqual(assess([], 0)["verdict"], "incomplete")
        self.assertEqual(assess([sample], 1)["verdict"], "fail")


if __name__ == "__main__":
    unittest.main()
