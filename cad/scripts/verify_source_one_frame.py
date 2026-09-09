"""Verify the pinned TBS Source One V6 7-inch DXF without CAD dependencies."""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from collections import defaultdict
from datetime import date
from pathlib import Path


CAD = Path(__file__).resolve().parents[1]
ROOT = CAD.parent
REFERENCE = CAD / "reference/source-one-v6-7in"
SOURCE_MANIFEST = REFERENCE / "source.json"
DEFAULT_REPORT = REFERENCE / "frame-2d-verification.json"


def pairs(path: Path):
    with path.open(encoding="latin-1", errors="replace") as handle:
        while True:
            code_line = handle.readline()
            if not code_line:
                return
            value_line = handle.readline()
            if not value_line:
                raise ValueError("DXF ended between a group code and value")
            try:
                code = int(code_line.strip())
            except ValueError:
                continue
            yield code, value_line.rstrip("\r\n")


def parse_relevant_entities(path: Path):
    header: dict[str, str] = {}
    texts: list[str] = []
    circles: list[dict[str, float | str]] = []
    polylines: list[dict[str, object]] = []
    current_type: str | None = None
    current: list[tuple[int, str]] = []
    header_var: str | None = None
    section = ""
    next_section = False

    def flush() -> None:
        nonlocal current_type, current
        if current_type == "CIRCLE":
            values = defaultdict(list)
            for code, value in current:
                values[code].append(value)
            try:
                circles.append({
                    "layer": values[8][0] if values[8] else "",
                    "x": float(values[10][0]),
                    "y": float(values[20][0]),
                    "z": float(values[30][0]) if values[30] else 0.0,
                    "radius": float(values[40][0]),
                })
            except (IndexError, ValueError):
                pass
        elif current_type == "LWPOLYLINE":
            layer = next((value for code, value in current if code == 8), "")
            flags = int(next((value for code, value in current if code == 70), "0"))
            xs = [float(value) for code, value in current if code == 10]
            ys = [float(value) for code, value in current if code == 20]
            if xs and len(xs) == len(ys):
                polylines.append({"layer": layer, "closed": bool(flags & 1), "vertices": list(zip(xs, ys))})
        elif current_type in {"TEXT", "MTEXT"}:
            value = "".join(value for code, value in current if code in {1, 3}).strip()
            if value:
                texts.append(value)
        current_type = None
        current = []

    keep = {"CIRCLE", "LWPOLYLINE", "TEXT", "MTEXT"}
    for code, value in pairs(path):
        if code == 0 and value in {"SECTION", "ENDSEC"}:
            flush()
            section = ""
            header_var = None
            next_section = value == "SECTION"
            continue
        if next_section and code == 2:
            section = value
            next_section = False
            continue
        if section == "HEADER" and code == 9:
            header_var = value
            continue
        if header_var and code in {1, 2, 40, 70, 280}:
            header[header_var] = value.strip()
            header_var = None
        if section != "ENTITIES":
            continue
        if code == 0:
            flush()
            current_type = value if value in keep else None
        elif current_type:
            current.append((code, value))
    flush()
    return header, texts, circles, polylines


def rounded(value: float) -> float:
    return round(value, 6)


def distance(a: dict[str, float], b: dict[str, float]) -> float:
    return math.hypot(a["x"] - b["x"], a["y"] - b["y"])


def polygon_area(vertices: list[tuple[float, float]]) -> float:
    return abs(sum(
        x1 * y2 - x2 * y1
        for (x1, y1), (x2, y2) in zip(vertices, vertices[1:] + vertices[:1])
    )) / 2


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()

    manifest = json.loads(SOURCE_MANIFEST.read_text(encoding="utf-8"))
    source = args.source or ROOT / manifest["local_cache"]
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    if digest != manifest["sha256"] or source.stat().st_size != manifest["bytes"]:
        raise SystemExit("Pinned DXF hash or size does not match source.json")

    header, texts, circles, polylines = parse_relevant_entities(source)
    motor_clearance = [
        c for c in circles
        if c["layer"] == "Cen" and math.isclose(float(c["radius"]), 91.0, abs_tol=0.001)
    ]
    if len(motor_clearance) != 4:
        raise SystemExit(f"Expected four Cen R91 motor/prop circles; found {len(motor_clearance)}")
    wheel_circles = [
        c for c in circles
        if c["layer"] == "Cen" and 150 < float(c["radius"]) < 160
    ]
    if len(wheel_circles) != 1:
        raise SystemExit(f"Expected one Cen wheelbase construction circle; found {len(wheel_circles)}")
    datum = wheel_circles[0]
    origin_raw = {"x": float(datum["x"]), "y": float(datum["y"])}

    motor_axis_holes = [
        c for c in circles
        if c["layer"] == "Frame-Arms" and math.isclose(float(c["radius"]), 3.5, abs_tol=0.001)
        and any(distance(c, m) <= 0.001 for m in motor_clearance)
    ]
    if len(motor_axis_holes) != 4:
        raise SystemExit(f"Expected four matching Frame-Arms R3.5 motor axes; found {len(motor_axis_holes)}")

    motors = []
    for circle in motor_axis_holes:
        aircraft_x = origin_raw["y"] - float(circle["y"])
        aircraft_y = float(circle["x"]) - origin_raw["x"]
        side = "left" if aircraft_y > 0 else "right"
        end = "front" if aircraft_x > 0 else "rear"
        motors.append({
            "id": f"{end}-{side}",
            "x_mm": rounded(aircraft_x),
            "y_mm": rounded(aircraft_y),
            "radial_mm": rounded(math.hypot(aircraft_x, aircraft_y)),
            "source_circle_radius_mm": rounded(float(circle["radius"])),
        })
    motors.sort(key=lambda m: m["id"])
    motor_by_id = {m["id"]: m for m in motors}

    relationships = []
    for a, b, name in [
        ("front-left", "front-right", "front transverse"),
        ("rear-left", "rear-right", "rear transverse"),
        ("front-left", "rear-left", "left side"),
        ("front-right", "rear-right", "right side"),
        ("front-left", "rear-right", "diagonal FL-RR"),
        ("front-right", "rear-left", "diagonal FR-RL"),
    ]:
        relationships.append({
            "relationship": name,
            "from": a,
            "to": b,
            "measured_mm": rounded(math.hypot(
                motor_by_id[a]["x_mm"] - motor_by_id[b]["x_mm"],
                motor_by_id[a]["y_mm"] - motor_by_id[b]["y_mm"],
            )),
        })

    def measured_pattern(pitch: float, targets: list[tuple[float, float]], tolerance: float = 0.001) -> dict:
        matched = []
        for target_x, target_y in targets:
            raw_x = origin_raw["x"] + target_y
            raw_y = origin_raw["y"] - target_x
            candidates = [c for c in circles if c["layer"] in {"Draw3", "Draw13", "Draw14"}
                          and math.hypot(float(c["x"]) - raw_x, float(c["y"]) - raw_y) <= tolerance]
            if not candidates:
                raise ValueError(f"No structural-layer mounting circle near {target_x}, {target_y}")
            c = min(candidates, key=lambda c: math.hypot(float(c["x"])-raw_x, float(c["y"])-raw_y))
            matched.append({"x": origin_raw["y"] - float(c["y"]),
                            "y": float(c["x"]) - origin_raw["x"],
                            "source_layer": c["layer"], "radius_mm": c["radius"]})
        edges = [distance(matched[a], matched[b]) for a, b in [(0, 1), (0, 2), (1, 3), (2, 3)]]
        return {"name": f"{pitch:g} x {pitch:g} mm central stack",
                "expected_pitch_mm": pitch,
                "measured_pitch_mm": [rounded(edge) for edge in edges],
                "measured_centers_fusion_mm": matched,
                "centers_found": True,
                "pitch_within_tolerance": all(abs(edge-pitch) <= tolerance for edge in edges)}

    stack_center_x = 27.845372
    patterns = [measured_pattern(pitch, [
        (stack_center_x - pitch/2, -pitch/2), (stack_center_x - pitch/2, pitch/2),
        (stack_center_x + pitch/2, -pitch/2), (stack_center_x + pitch/2, pitch/2),
    ]) for pitch in [30.5, 20.0]]

    profile_layers = ["Frame-Arms", "Draw3", "Draw13", "Draw14"]
    profile_extents = []
    for layer in profile_layers:
        layer_polys = [
            p for p in polylines
            if p["layer"] == layer
            and all(
                abs(x - origin_raw["x"]) <= 250 and abs(y - origin_raw["y"]) <= 250
                for x, y in p["vertices"]
            )
        ]
        if not layer_polys:
            continue
        closed_polys = [p for p in layer_polys if p["closed"]]
        largest = max(closed_polys, key=lambda p: polygon_area(p["vertices"])) if closed_polys else None
        all_vertices = [point for p in layer_polys for point in p["vertices"]]
        aircraft = [(origin_raw["y"] - y, x - origin_raw["x"]) for x, y in all_vertices]
        profile_extents.append({
            "source_layer": layer,
            "polyline_count": len(layer_polys),
            "closed_polyline_count": len(closed_polys),
            "combined_vertex_bounds_fusion_mm": {
                "x_min": rounded(min(x for x, _ in aircraft)),
                "x_max": rounded(max(x for x, _ in aircraft)),
                "y_min": rounded(min(y for _, y in aircraft)),
                "y_max": rounded(max(y for _, y in aircraft)),
            },
            "largest_chord_polygon_area_mm2": rounded(polygon_area(largest["vertices"])) if largest else None,
            "profile_measurement_limit": "Vertices/chords only; bulge arcs can extend bounds and change area. Not an exact profile measurement.",
            "semantic_plate_assignment": "UNRESOLVED until the Fusion layer/profile inspection",
        })

    radial_values = [m["radial_mm"] for m in motors]
    front_x = [m["x_mm"] for m in motors if m["id"].startswith("front")]
    rear_x = [m["x_mm"] for m in motors if m["id"].startswith("rear")]
    left_y = sorted(abs(m["y_mm"]) for m in motors if m["id"].endswith("left"))
    right_y = sorted(abs(m["y_mm"]) for m in motors if m["id"].endswith("right"))
    rotor_centroid_x = sum(m["x_mm"] for m in motors) / 4
    report = {
        "report_date": date.today().isoformat(),
        "scope": "2D source verification before Fusion import; this is not an assembled-frame model",
        "release_status": "PROVISIONAL CAD-T01 source analysis; no Fusion import or frame reference released",
        "source": {
            "manufacturer": manifest["manufacturer"],
            "model": manifest["model"],
            "repository": manifest["repository"],
            "commit": manifest["commit"],
            "path": manifest["path"],
            "bytes": source.stat().st_size,
            "sha256": digest,
        },
        "dxf_identity": {
            "acad_version": header.get("$ACADVER"),
            "insunits_code": int(header.get("$INSUNITS", "-1")),
            "insunits_meaning": "millimetres" if header.get("$INSUNITS") == "4" else "unexpected",
            "measurement_code": int(header.get("$MEASUREMENT", "-1")),
            "measurement_meaning": "metric" if header.get("$MEASUREMENT") == "1" else "unexpected",
            "required_identity_text_found": all(any(term in text for text in texts) for term in [
                "Source One V6 - 7 in DC", "2025-JUL-07"
            ]),
        },
        "coordinate_convention": {
            "origin": "DXF Cen-layer construction-circle center through all four motor axes",
            "origin_raw_dxf_mm": {"x": rounded(origin_raw["x"]), "y": rounded(origin_raw["y"])},
            "aircraft_axes": "PROPOSED right-handed FLU: +X toward wide/provisional front pair; +Y aircraft left; +Z upward",
            "fusion_mapping_after_alignment": "Fusion +X forward, +Y left, +Z up. Aircraft-right coordinate = -Fusion Y. Front orientation still requires inspection.",
            "raw_transform": "X_aircraft = 1461.258462156818 - DXF_Y; Y_aircraft = DXF_X - 1518.565263306285",
            "rotor_centroid_aircraft_mm": {"x": rounded(rotor_centroid_x), "y": 0.0},
            "front_assignment_status": "PROVISIONAL inference from wide dead-cat pair; camera-end orientation has not yet been inspected",
        },
        "checks": [
            {
                "check": "DXF declared units",
                "expected": "$INSUNITS=4 and $MEASUREMENT=1",
                "measured": f"$INSUNITS={header.get('$INSUNITS')}; $MEASUREMENT={header.get('$MEASUREMENT')}",
                "tolerance": "exact",
                "status": "PASS" if header.get("$INSUNITS") == "4" and header.get("$MEASUREMENT") == "1" else "FAIL",
            },
            {
                "check": "nominal wheelbase",
                "expected": "313 mm (TBS product specification)",
                "measured": f"{2 * float(datum['radius']):.6f} mm construction-circle diameter",
                "tolerance": "±0.5 mm for a whole-millimetre published nominal",
                "status": "PASS" if abs(2 * float(datum["radius"]) - 313) <= 0.5 else "FAIL",
            },
            {
                "check": "four motor axes on common circle",
                "expected": "4 axes, equal radius",
                "measured": f"4 axes; radial spread {max(radial_values) - min(radial_values):.6f} mm",
                "tolerance": "0.001 mm extraction tolerance",
                "status": "PASS" if max(radial_values) - min(radial_values) <= 0.001 else "FAIL",
            },
            {
                "check": "bilateral motor symmetry",
                "expected": "left/right mirrored about Y=0",
                "measured": f"front X spread {max(front_x)-min(front_x):.6f} mm; rear X spread {max(rear_x)-min(rear_x):.6f} mm; |Y| spread {max(abs(a-b) for a,b in zip(left_y,right_y)):.6f} mm",
                "tolerance": "0.001 mm extraction tolerance",
                "status": "PASS" if max(front_x)-min(front_x) <= 0.001 and max(rear_x)-min(rear_x) <= 0.001 and max(abs(a-b) for a,b in zip(left_y,right_y)) <= 0.001 else "FAIL",
            },
            *[
                {
                    "check": pattern["name"],
                    "expected": f"{pattern['expected_pitch_mm']} mm square pitch",
                    "measured": f"{pattern['measured_pitch_mm']} mm square pitch; all four centers present={pattern['centers_found']}",
                    "tolerance": "0.001 mm center extraction tolerance",
                    "status": "PASS" if pattern["pitch_within_tolerance"] else "FAIL",
                }
                for pattern in patterns
            ],
        ],
        "motor_centers_aircraft_mm": motors,
        "motor_center_relationships": relationships,
        "mounting_patterns": patterns,
        "profile_layer_measurements": profile_extents,
        "classification": {
            "verified_2d": [
                "source identity/hash", "declared millimetre units", "motor centers",
                "312.830 mm motor construction-circle diameter", "20 mm and 30.5 mm stack-hole centers",
                "source-layer polyline vertex coordinates only; curved profile bounds/area not verified",
            ],
            "derived": [
                "aircraft-axis transform", "front/rear naming", "rotor centroid", "pairwise motor distances",
            ],
            "unresolved_until_fusion": [
                "which source layers/profiles map to each physical plate", "Fusion import scale and transformed datum placement",
                "closed-profile usability after import",
            ],
            "missing_assembled_z": [
                "plate stacking order and gaps", "assembled Z datum", "standoff/fastener stack",
                "motor and propeller-plane Z", "as-built tolerances",
            ],
        },
    }
    if any(check["status"] != "PASS" for check in report["checks"]):
        raise SystemExit(json.dumps(report["checks"], indent=2))
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"OK: verified pinned DXF; wrote {args.report}")


if __name__ == "__main__":
    main()
