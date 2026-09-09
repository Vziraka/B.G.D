"""Check real KiCad XML/ERC outputs against the baseline and safety invariants.

Run KiCad export/ERC first; this never opens a device or modifies shared sources.
"""
import copy
import csv
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
ELEC = ROOT / "electronics"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def csv_rows(path):
    with path.open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def check_shared_corrections(pin_table, fw, harness):
    """Protect the reviewed E01/E05 corrections even after source regeneration."""
    for net in ("HOLDER_CLOSED", "LATCH_ENGAGED", "PI_LOGIC_PULLUP"):
        row = next(r for r in pin_table if r["net"] == net)
        prose = " ".join(row.values()).lower()
        require("4.7k" in prose and "10k" not in prose, f"E01 regressed: {net}")
    contract = fw["pi_reference"]["switch_contract"].lower()
    require("4.7k" in contract and "10k" not in contract, "E01 firmware contract regressed")
    for wire in ("W060", "W061"):
        row = next(r for r in harness if r["id"] == wire)
        require(row["max_cut_mm"] == "80" and "HOLD" in row["termination"], f"E05 regressed: {wire}")


def invariant_checks(nodes, values):
    # Independent circuit expectations: deliberately not imported from generator.
    groups = {
        "PACK_POS": "BAT1.+ JBAT1.+ MON1.BAT+",
        "GND": "BAT1.- JBAT1.- FC1.GND U1.7 U1.1 U1.4 U1.10 U1.13 PI1.6 PI1.9 PI1.14 PI1.20 SW1.COM SW2.COM DRV1.GND",
        "BUS_POS": "MON1.ESC+ FC1.VBAT CM1.+ F1.IN F2.IN",
        "FUSED_F1": "F1.OUT REG1.VIN+",
        "FUSED_F2": "F2.OUT REG2.VIN+",
        "PI_5V2": "REG1.VOUT+ PI1.2 PI1.4 FAN1.+",
        "PER_5V": "REG2.VOUT+ U1.14 DRV1.VCC DRV1.LOAD_HIGH JH1.+ JH2.+ SOL1.+ LED1.5V LED2.5V SERVO1.5V SERVO2.5V C4.1",
        "AIO_5V": "FC1.5V MON1.5V GPS1.5V RX1.5V RANGE1.5V BZ1.5V",
        "AIO_12V": "FC1.12V REG3.IN+",
        "IR_3V3": "REG3.OUT+ IR1.+ IR2.+",
        "PI_3V3": "PI1.1 R6.1 R7.1",
        "PI_TX_FC_RX": "PI1.8 FC1.RX1", "FC_TX_PI_RX": "FC1.TX1 PI1.10",
        "GPS_TX": "GPS1.TX FC1.RX3", "GPS_RX": "FC1.TX3 GPS1.RX",
        "CRSF_TX": "RX1.TX FC1.RX6", "CRSF_RX": "FC1.TX6 RX1.RX",
        "RANGE_TX": "RANGE1.TX FC1.RX4", "RANGE_RX": "FC1.TX4 RANGE1.RX",
        "I2C1_SCL": "FC1.SCL GPS1.SCL MON1.SCL", "I2C1_SDA": "FC1.SDA GPS1.SDA MON1.SDA",
        "PIXEL_DATA3V3": "PI1.12 U1.2 R1.1", "PIXEL_DATA5V": "U1.3 R5.1",
        "LED_DIN": "R5.2 LED1.DIN", "LED_CHAIN_DATA": "LED1.DOUT LED2.DIN",
        "PAN_PWM3V3": "FC1.M5 U1.9 R3.1", "PAN_PWM5V": "U1.8 SERVO1.SIG",
        "TILT_PWM3V3": "FC1.M6 U1.12 R4.1", "TILT_PWM5V": "U1.11 SERVO2.SIG",
        "RELEASE_PWM3V3": "FC1.M7 U1.5 R2.1", "RELEASE_PWM5V": "U1.6 DRV1.RC_IN",
        "SOLENOID_LOW": "DRV1.LOAD_LOW JH1.- JH2.- SOL1.-",
        "SW_A_RAW": "SW1.NO R8.1", "SW_B_RAW": "SW2.NO R9.1",
        "HOLDER_CLOSED": "PI1.16 R6.2 R8.2 C2.1",
        "LATCH_ENGAGED": "PI1.18 R7.2 R9.2 C3.1",
        "CHARGE_POS": "CHG1.+ JCHG1.+", "CHARGE_NEG": "CHG1.- JCHG1.-",
    }
    checked = 0
    for net, members in groups.items():
        for node in members.split():
            require(nodes.get(node) == net, f"{node}: expected {net}; got {nodes.get(node)}")
            checked += 1
    for motor in range(1, 5):
        for phase in "ABC":
            for node in (f"FC1.ESC{motor}_{phase}", f"M{motor}.{phase}"):
                require(nodes.get(node) == f"M{motor}_{phase}", f"Motor phase {node} mismapped")
                checked += 1
    for node in ("DRV1.GOOD", "DRV1.OUT", "DRV1.VRC", "DRV1.LRN", "SW1.NC", "SW2.NC", "LED2.DOUT"):
        require(nodes.get(node, "").startswith("unconnected-"), f"{node} must remain isolated")
    for ref, expected in {"R1":"10k","R2":"10k","R3":"10k","R4":"10k","R5":"330","R6":"4.7k","R7":"4.7k","R8":"330","R9":"330","C1":"100nF 16V","C2":"100nF 16V","C3":"100nF 16V","C4":"1000uF 10V"}.items():
        require(values.get(ref) == expected, f"{ref} expected {expected}")
    require(nodes["R5.1"] != nodes["R5.2"], "LED resistor bypassed")
    require(nodes["MON1.BAT+"] != nodes["MON1.ESC+"], "Monitor shunt bypassed")
    require(nodes["DRV1.LOAD_LOW"] != nodes["DRV1.GND"], "Solenoid forced on")
    require(len({nodes[n] for n in ("FC1.5V","FC1.12V","REG1.VOUT+","REG2.VOUT+","REG3.OUT+","PI1.1")}) == 6, "Supply domains merged")
    return checked


def main():
    manifest = json.loads((ELEC / "source-manifest.json").read_text())
    for name, digest in manifest["inputs"].items():
        require(hashlib.sha256((ROOT/name).read_bytes()).hexdigest() == digest,
                f"Upstream changed: {name}; review before regenerating")
    for name, digest in manifest["schematic_sources"].items():
        require(hashlib.sha256((ROOT/name).read_bytes()).hexdigest() == digest, f"Schematic changed since generation: {name}")
    tree = ET.parse(ELEC / "exports/bgd-master.net.xml").getroot()
    nodes = {}
    for net in tree.findall("./nets/net"):
        for node in net.findall("node"):
            key = node.get("ref") + "." + node.get("pin")
            require(key not in nodes, f"Duplicate exported node {key}")
            nodes[key] = net.get("name")
    values = {c.get("ref"):c.findtext("value") for c in tree.findall("./components/comp")}
    expected = csv_rows(ELEC / "pinouts/schematic-pins.csv")
    expected = [r for r in expected if not r["node"].startswith("#FLG")]
    require(set(nodes) == {r["node"] for r in expected}, "Exported pin set differs from declared circuit")
    for row in expected:
        actual = nodes[row["node"]]
        require(actual.startswith("unconnected-") if row["net"] == "NC" else actual == row["net"],
                f"Export mismatch at {row['node']}")
    invariant_count = invariant_checks(nodes, values)
    # Show these checks actually reject dangerous mutations of the exported data.
    mutations = [("supply bridge","U1.14","PI_5V2"), ("coil ground bypass","SOL1.-","GND"),
                 ("swapped PWM","U1.5","PAN_PWM3V3"), ("LED resistor bypass","R5.2","PIXEL_DATA5V"),
                 ("input fuse bypass","REG1.VIN+","BUS_POS"), ("removed ground","PI1.9",None)]
    for name, node, net in mutations:
        broken = copy.copy(nodes)
        if net is None:
            del broken[node]
        else:
            broken[node] = net
        try:
            invariant_checks(broken, values)
        except ValueError:
            pass
        else:
            raise ValueError(f"Mutation escaped: {name}")
    broken_values = dict(values, R6="10k")
    try:
        invariant_checks(nodes, broken_values)
    except ValueError:
        pass
    else:
        raise ValueError("Wrong pullup value escaped")
    baseline = csv_rows(ROOT / "docs/hardware/baseline-r1/harness-netlist.csv")
    ledger = csv_rows(ELEC / "harness/reconciliation.csv")
    require(len(ledger) == len(baseline) == 135, "Harness record count changed")
    require({r["id"] for r in ledger} == {r["id"] for r in baseline}, "Harness coverage gap/duplicate")
    allowed = {"wire","passive-component","factory-cable-expanded","factory-cable-hold","intentional-isolation"}
    require(all(r["kind"] in allowed for r in ledger), "Unknown reconciliation treatment")
    require(sum(r["kind"] == "factory-cable-hold" for r in ledger) == 5, "Held factory cable count changed")
    for row in ledger:
        if row["kind"] == "wire":
            for node in (row["from_node"],row["to_node"]):
                require(node == "junction" or nodes.get(node) == row["schematic_net"], f"Harness edge {row['id']} missing")
        elif row["kind"] == "passive-component":
            n1,n2 = row["schematic_net"].split(";")
            require(nodes[row["from_node"]] == n1 and nodes[row["to_node"]] == n2 and n1 != n2, f"Passive {row['id']} collapsed")
    inventory = {r["id"] for r in csv_rows(ROOT / "cad/component-inventory.csv")}
    require(all(r["inventory_id"] in inventory for r in expected), "Symbol lacks inventory trace")
    pin_table = csv_rows(ROOT / "docs/hardware/baseline-r1/pin-allocation.csv")
    require(len(pin_table) == 43, "Pin allocation count changed")
    mcu = {r["physical_pin_or_pad"]:r["mcu_or_bcm_pin"] for r in pin_table if r["controller"] == "FC"}
    for pin, chip in {"TX1":"PA9","RX1":"PA10","TX3":"PD8","RX3":"PD9","TX4":"PA0","RX4":"PA1","TX6":"PC6","RX6":"PC7","M5":"PB1","M6":"PB0","M7":"PD12","SCL":"PB8","SDA":"PB9"}.items():
        require(mcu[pin] == chip, f"FC pin mapping differs: {pin}")
    fw = json.loads((ROOT / "docs/hardware/baseline-r1/firmware-manifest.json").read_text())
    check_shared_corrections(pin_table, fw, baseline)
    correction_mutations = 0
    for target, old, new in (("pin", "4.7k", "10k"), ("firmware", "4.7k", "10k"), ("fan", "80", "150")):
        p, f, h = copy.deepcopy(pin_table), copy.deepcopy(fw), copy.deepcopy(baseline)
        if target == "pin":
            row = next(r for r in p if r["net"] == "HOLDER_CLOSED")
            row.update({k:v.replace(old,new) for k,v in row.items()})
        elif target == "firmware":
            f["pi_reference"]["switch_contract"] = f["pi_reference"]["switch_contract"].replace(old,new)
        else:
            next(r for r in h if r["id"] == "W060")["max_cut_mm"] = new
        try:
            check_shared_corrections(p, f, h)
        except ValueError:
            correction_mutations += 1
        else:
            raise ValueError(f"Shared correction mutation escaped: {target}")
    require(fw["timer_groups"] == {"TIM1":[1,2,3,4],"TIM3":[5,6],"TIM4":[7,8,11]}, "Timer allocation changed")
    require([d["address_hex"] for d in fw["i2c"]["external"]["devices"]] == ["0x45","0x0E"], "I2C allocation changed")
    erc = json.loads((ELEC / "exports/erc.json").read_text())
    violations = [v for sheet in erc["sheets"] for v in sheet["violations"]]
    require(not violations, "Native ERC has violations")
    counts = {kind:sum(r["kind"] == kind for r in ledger) for kind in sorted(allowed)}
    result = {"status":"PASS_WITH_DOCUMENTED_RELEASE_HOLDS", "kicad_version":erc["kicad_version"],
              "native_erc_violations":0,"native_erc_ignored_default_checks":erc["ignored_checks"],
              "exported_components":len(values),"exported_pins":len(nodes),"exported_nets":len(tree.findall('./nets/net')),
              "independent_node_expectations":invariant_count,"rejected_fault_mutations":7,
              "rejected_shared_record_mutations":correction_mutations,
              "shared_record_corrections":{"E01":"resolved documentation", "E05":"nominal tail corrected; physical route held"},
              "harness_records":len(ledger),"harness_treatments":counts,"pin_allocation_rows":len(pin_table),
              "source_hashes_checked":len(manifest["inputs"]),
              "explicit_limits":["Module-level connectivity only","Five factory cables lack scalar internal pin coverage",
                                 "ERC power assertions after shunt/fuses are not new hardware or physical evidence",
                                 "E05 80mm fan tails do not establish usable routed reach or voltage compatibility",
                                 "No route, thermal, current, runtime, physical connector or aircraft release"]}
    inputs = [ELEC/"exports/bgd-master.net.xml", ELEC/"exports/erc.json"]
    result["output_hashes"] = {p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs}
    (ELEC/"validation-report.json").write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__ == "__main__":
    main()
