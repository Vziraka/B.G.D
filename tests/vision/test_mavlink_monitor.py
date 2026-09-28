import unittest

from bgd_vision.mavlink_monitor import TelemetryMonitor, request_telemetry, send_gcs_heartbeat


class Message:
    def __init__(self, kind, values, system=1, component=1):
        self.kind = kind
        self.values = values
        self.system = system
        self.component = component

    def get_type(self): return self.kind
    def to_dict(self): return dict(self.values)
    def get_srcSystem(self): return self.system
    def get_srcComponent(self): return self.component


class TelemetryMonitorTests(unittest.TestCase):
    def test_only_outbound_packet_is_a_fixed_gcs_heartbeat(self):
        calls = []
        connection = type("Connection", (), {"mav":type("Mav", (), {
            "heartbeat_send":lambda self, *values: calls.append(values)})()})()
        constants = type("Constants", (), {
            "MAV_TYPE_GCS":6, "MAV_AUTOPILOT_INVALID":8, "MAV_STATE_ACTIVE":4})
        send_gcs_heartbeat(connection, constants)
        self.assertEqual(calls, [(6, 8, 0, 0, 4)])

    def test_only_fixed_observer_telemetry_is_requested(self):
        calls = []
        connection = type("Connection", (), {"mav":type("Mav", (), {
            "command_long_send":lambda self, *values: calls.append(values)})()})()
        constants = type("Constants", (), {"MAV_CMD_SET_MESSAGE_INTERVAL":511})
        request_telemetry(connection, constants, 1, 1)
        self.assertEqual([call[:4] for call in calls], [(1,1,511,0)]*3)
        self.assertEqual([call[4:6] for call in calls], [(1,500_000),(30,250_000),(33,500_000)])

    def test_reads_telemetry_and_fails_closed_when_heartbeat_stales(self):
        monitor = TelemetryMonitor(stale_after=5)
        monitor.started_at = 0
        monitor.observe(Message("HEARTBEAT", {"custom_mode":3, "base_mode":81, "system_status":4}), now=10)
        monitor.observe(Message("ATTITUDE", {"roll":0.1, "pitch":-0.2, "yaw":1.0}), now=10)
        monitor.observe(Message("GLOBAL_POSITION_INT", {
            "lat":389000000, "lon":-770000000, "relative_alt":12500, "vx":120, "vy":-30, "vz":5}), now=10)
        monitor.observe(Message("BATTERY_STATUS", {
            "voltages":[22200,65535], "current_battery":153, "battery_remaining":74}), now=10)
        monitor.observe(Message("SYS_STATUS", {
            "voltage_battery":22100, "current_battery":150, "battery_remaining":73}), now=10)

        connected = monitor.snapshot(now=14.9)
        self.assertEqual(connected["status"], "connected")
        self.assertEqual(connected["authority"], "READ_ONLY")
        self.assertFalse(connected["actuator_output"])
        self.assertEqual(connected["telemetry"]["GLOBAL_POSITION_INT"]["relative_altitude_m"], 12.5)
        self.assertEqual(connected["telemetry"]["BATTERY_STATUS"]["voltage_v"], 22.2)
        self.assertEqual(connected["telemetry"]["SYS_STATUS"]["voltage_v"], 22.1)
        self.assertEqual(monitor.snapshot(now=15.1)["status"], "link_lost")


if __name__ == "__main__":
    unittest.main()
