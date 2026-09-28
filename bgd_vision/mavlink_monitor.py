"""Read-only MAVLink telemetry monitor; sends presence heartbeats, never commands."""

import argparse
import json
import math
import time


class TelemetryMonitor:
    def __init__(self, stale_after=5.0):
        self.stale_after = stale_after
        self.started_at = time.monotonic()
        self.last_heartbeat_at = None
        self.system_id = None
        self.component_id = None
        self.messages = {}

    def observe(self, message, now=None):
        now = time.monotonic() if now is None else now
        kind = message.get_type()
        if kind == "BAD_DATA":
            return
        values = message.to_dict()
        self.messages[kind] = self._telemetry(kind, values)
        if kind == "HEARTBEAT":
            self.last_heartbeat_at = now
            self.system_id = message.get_srcSystem()
            self.component_id = message.get_srcComponent()

    def snapshot(self, now=None):
        now = time.monotonic() if now is None else now
        heartbeat_age = None if self.last_heartbeat_at is None else round(now-self.last_heartbeat_at, 2)
        connected = heartbeat_age is not None and heartbeat_age <= self.stale_after
        return {
            "status": "connected" if connected else "waiting" if heartbeat_age is None else "link_lost",
            "authority": "READ_ONLY",
            "actuator_output": False,
            "system_id": self.system_id,
            "component_id": self.component_id,
            "heartbeat_age_s": heartbeat_age,
            "uptime_s": round(now-self.started_at, 1),
            "telemetry": dict(self.messages),
        }

    @staticmethod
    def _telemetry(kind, values):
        if kind == "HEARTBEAT":
            return {key: values.get(key) for key in ("custom_mode", "base_mode", "system_status")}
        if kind == "ATTITUDE":
            return {key: round(math.degrees(values[key]), 2) for key in ("roll", "pitch", "yaw")}
        if kind == "GLOBAL_POSITION_INT":
            return {
                "latitude_deg": round(values["lat"]/1e7, 7),
                "longitude_deg": round(values["lon"]/1e7, 7),
                "relative_altitude_m": round(values["relative_alt"]/1000, 2),
                "velocity_m_s": [round(values[key]/100, 2) for key in ("vx", "vy", "vz")],
            }
        if kind in {"BATTERY_STATUS", "SYS_STATUS"}:
            voltage = values.get("voltage_battery")
            if voltage is None:
                voltage = next((value for value in values.get("voltages", []) if value != 65535), None)
            return {
                "voltage_v": None if voltage is None else round(voltage/1000, 2),
                "current_a": None if values.get("current_battery", -1) < 0 else round(values["current_battery"]/100, 2),
                "remaining_percent": None if values.get("battery_remaining", -1) < 0 else values["battery_remaining"],
            }
        return {}


def run(endpoint, duration, interval, stale_after):
    from pymavlink import mavutil

    connection = mavutil.mavlink_connection(endpoint, autoreconnect=True)
    monitor = TelemetryMonitor(stale_after)
    deadline = time.monotonic()+duration
    next_heartbeat = 0
    next_report = 0
    telemetry_requested = False
    while time.monotonic() < deadline:
        message = connection.recv_match(blocking=True, timeout=.25)
        if message is not None:
            monitor.observe(message)
        now = time.monotonic()
        if monitor.system_id is not None and now >= next_heartbeat:
            send_gcs_heartbeat(connection, mavutil.mavlink)
            next_heartbeat = now+1
        if monitor.system_id is not None and not telemetry_requested:
            request_telemetry(connection, mavutil.mavlink, monitor.system_id, monitor.component_id)
            telemetry_requested = True
        if now >= next_report:
            print(json.dumps(monitor.snapshot(now)), flush=True)
            next_report = now+interval
    return monitor.snapshot()


def send_gcs_heartbeat(connection, mavlink):
    """Advertise a healthy observer; this fixed packet has no command payload."""
    connection.mav.heartbeat_send(
        mavlink.MAV_TYPE_GCS, mavlink.MAV_AUTOPILOT_INVALID, 0, 0, mavlink.MAV_STATE_ACTIVE)


def request_telemetry(connection, mavlink, system_id, component_id):
    """Request only observer data at bounded rates; no vehicle-state command is exposed."""
    for message_id, interval_us in ((1, 500_000), (30, 250_000), (33, 500_000)):
        connection.mav.command_long_send(
            system_id, component_id, mavlink.MAV_CMD_SET_MESSAGE_INTERVAL, 0,
            message_id, interval_us, 0, 0, 0, 0, 0)


def main():
    parser = argparse.ArgumentParser(description="Observe MAVLink telemetry without sending commands")
    parser.add_argument("--endpoint", default="udpin:0.0.0.0:14550")
    parser.add_argument("--duration", type=float, default=30)
    parser.add_argument("--interval", type=float, default=1)
    parser.add_argument("--stale-after", type=float, default=5)
    args = parser.parse_args()
    result = run(args.endpoint, args.duration, args.interval, args.stale_after)
    print(json.dumps(result), flush=True)
    raise SystemExit(0 if result["status"] == "connected" else 1)


if __name__ == "__main__":
    main()
