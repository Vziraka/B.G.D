"""Dependency-free consistency check for engineering manifests and saved CAD."""
from __future__ import annotations

import csv
import hashlib
import json
from pathlib import Path

CAD = Path(__file__).resolve().parents[1]
ROOT = CAD.parent
ALLOWED_REPS = {"1", "2", "3", "4", "5"}
ALLOWED_EVIDENCE = {
    "VERIFIED DIGITALLY",
    "STILL REQUIRES RECEIVED-PART MEASUREMENT",
    "STILL REQUIRES BENCH VALIDATION",
    "STILL REQUIRES FLIGHT VALIDATION",
}
REQUIRED_GATES = {
    "M02", "M03", "M05", "M08", "M09", "M22",
    "P02", "P05", "P10", "P11", "P12", "P14", "P15", "P16",
    "P19", "P22", "P24", "P25", "P27",
    "D03", "D06", "D07", "D08", "D09", "D10", "D13", "D14",
    "D19", "D20", "D21", "D22", "D23", "D24",
}


def rows(name: str) -> list[dict[str, str]]:
    with (CAD / name).open(encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def main() -> None:
    inventory = rows("component-inventory.csv")
    assert inventory and len({row["id"] for row in inventory}) == len(inventory)
    assert all(row["representation_class"].split(maxsplit=1)[0] in ALLOWED_REPS for row in inventory)

    backlog = rows("custom-fabrication-backlog.csv")
    assert [row["id"] for row in backlog] == [f"CAD-{n:02d}" for n in range(1, 14)]

    gates = rows("digital-validation-gates.csv")
    assert gates and len({row["digital_gate"] for row in gates}) == len(gates)
    assert {row["evidence_class"] for row in gates} <= ALLOWED_EVIDENCE
    covered = {gate.strip() for row in gates for gate in row["source_gates"].split(";")}
    assert covered == REQUIRED_GATES, (sorted(REQUIRED_GATES - covered), sorted(covered - REQUIRED_GATES))

    source_file = CAD / "reference/source-one-v6-7in/source.json"
    source = json.loads(source_file.read_text(encoding="utf-8"))
    cache = ROOT / source["local_cache"]
    if cache.exists():
        digest = hashlib.sha256(cache.read_bytes()).hexdigest()
        assert digest == source["sha256"]
        assert cache.stat().st_size == source["bytes"]

    snapshot = CAD / "assemblies/reference-r1-manifest.json"
    checked = 0
    if snapshot.exists():
        manifest = json.loads(snapshot.read_text(encoding="utf-8"))
        assert manifest["source_sha256"] == source["sha256"]
        assert manifest["status"] == "UNRELEASED_REFERENCE_AND_ADAPTER_STUDY"
        assert manifest["visible_solid_interference_count"] == 0
        for item in manifest["artifacts"] + manifest["scripts"]:
            path = (ROOT / item["path"]).resolve()
            assert path.is_relative_to(CAD.resolve()), path
            assert hashlib.sha256(path.read_bytes()).hexdigest() == item["sha256"], path
            if "bytes" in item:
                assert path.stat().st_size == item["bytes"]
            checked += 1
    print(
        f"OK: {len(inventory)} physical inventory rows; {len(backlog)} custom items; "
        f"{len(gates)} digital checks cover {len(covered)} source gates; Source One cache verified={cache.exists()}; "
        f"{checked} snapshot/script hashes checked (not fabrication qualification)"
    )


if __name__ == "__main__":
    main()
