"""Conservative plan-view packaging screen, not as-built flight clearance."""
import json
import math
from pathlib import Path

motor_offset = 450 / (2 * math.sqrt(2))
prop_radius = 120  # live design's conservative 240 mm prop envelope
motors = [(sx*motor_offset, sy*motor_offset) for sx in (-1, 1) for sy in (-1, 1)]
boxes = {
    "reserved_pi_and_restrained_wires": [-40, 40, -50, 55],
    "camera_and_forward_depth": [-32, 28, 45, 92],
    "battery_and_end_stops": [-34, 34, -83, 83],
    "stack_adapter": [-24, 24, -32, 32],
    "downward_sensor_and_support": [29, 81, -19, 19],
    "rear_restrained_connector_corridor": [-15, 15, -110, -80],
}
def clearance(box, motor):
    x0, x1, y0, y1 = box
    x, y = motor
    return math.hypot(max(x0-x, 0, x-x1), max(y0-y, 0, y-y1)) - prop_radius

results = {name: round(min(clearance(b, m) for m in motors), 2) for name, b in boxes.items()}
assert all(d >= 20 for d in results.values()), results
# Conservative optical origin at inboard body edge, above actual lens.
flow_gap = 65 - 20.8/2 - 0.5 - 57*math.tan(math.radians(21)) - 51/2
assert flow_gap > 0
output = {"plan_clearance_mm": results, "flow_to_battery_margin_mm": round(flow_gap, 2),
          "assumptions": "450 mm square-X diagonal wheelbase, 240 mm prop disks, reserved rectangular envelopes; rigid nominal geometry only. No flex, legs, cables outside corridors, thermal or measured-fit qualification."}
Path(__file__).with_name("layout-clearance-screen.json").write_text(json.dumps(output, indent=2)+"\n")
print(json.dumps(output, indent=2))
