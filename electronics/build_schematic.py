"""Generate the fixed R1.1 functional schematic and typed harness reconciliation.

Python stdlib only. This is an electrical node model, never a connector-view or
wire-cut generator. Unknown factory cable internals remain explicit holds.
"""

import csv
import hashlib
import json
from pathlib import Path
import re
from uuid import NAMESPACE_URL, uuid5

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "electronics/schematics/bgd-master"
BASE = ROOT / "docs/hardware/baseline-r1"
SOURCES = [BASE / name for name in ("harness-netlist.csv", "pin-allocation.csv",
           "electrical-build.md", "firmware-manifest.json", "safety-state-tables.md")]
SOURCES += [ROOT / "cad/component-inventory.csv", ROOT / "cad/engineering-progress-2026-09-05.md"]
SOURCES += [BASE / "firmware-manifest.md", ROOT / "cad/robust-aio-review.md",
            ROOT / "cad/received-frame-inspection-gate.md"]
SOURCES += [Path(__file__), ROOT / "electronics/pinouts/sources.md"]

# ref: value, sheet, inventory id, evidence key. Module terminal identifiers are
# functional labels unless the register explicitly establishes numeric pins.
PARTS = {
    "BAT1": ("Nexus 6S2P P50B / factory QS8F", 10, "PACK-001", "S10"),
    "JBAT1": ("Genuine QS8 male / single pack", 10, "CONN-001", "S10"),
    "MON1": ("Matek I2C-INA-BM", 10, "MON-001", "S2"),
    "CM1": ("1000uF 35V EEU-FR1V102B", 10, "CAP-001", "S10"),
    "F1": ("5A 32V 0297005.WXNV", 20, "FUSE-002", "S10"),
    "F2": ("5A 32V 0297005.WXNV", 20, "FUSE-002", "S10"),
    "REG1": ("BEC12S-PRO / 5.2V", 20, "BEC-001", "S2"),
    "REG2": ("Hobbywing 30607000 / 5.0V", 20, "BEC-002", "S9"),
    "REG3": ("DFR1015 / 3.3V only", 20, "BEC-003", "S9"),
    "FC1": ("MicoAir743v2-AIO45A", 30, "FC-001", "S1"),
    "GPS1": ("Micro M10 case IST8310 / 12044", 30, "GNSS-001", "S6"),
    "RX1": ("RadioMaster RP1 V2", 30, "RX-001", "S8"),
    "RANGE1": ("TFmini-S / UART", 30, "SENSE-002", "S7"),
    "BZ1": ("VIFLY Finder2", 30, "BUZZ-001", "S8"),
    "PI1": ("Pi4 J8 used pins / physical numbering", 40, "PI-001", "S3"),
    "FAN1": ("Adafruit 3368 / always on", 40, "COOL-001", "S3"),
    "U1": ("SN74AHCT125N / PDIP14", 50, "LOGIC-001", "S4"),
    "DRV1": ("Pololu 2802 / bridges OPEN", 50, "ACT-002", "S5"),
    "SERVO1": ("Pan servo / Adafruit1967 kit", 50, "GIM-001", "S9"),
    "SERVO2": ("Tilt servo / Adafruit1967 kit", 50, "GIM-001", "S9"),
    "LED1": ("Adafruit5162 RGBW / first", 50, "LIGHT-002", "S9"),
    "LED2": ("Adafruit5162 RGBW / second", 50, "LIGHT-002", "S9"),
    "IR1": ("Waveshare IR Board B / left", 20, "LIGHT-001", "S9"),
    "IR2": ("Waveshare IR Board B / right", 20, "LIGHT-001", "S9"),
    "JH1": ("Pololu2180 / aircraft source", 50, "ACT-005", "S11"),
    "JH2": ("Pololu2181 / removable holder", 50, "ACT-005", "S11"),
    "SOL1": ("Adafruit2776 / 5V nominal1.1A", 50, "ACT-001", "S5"),
    "SW1": ("Pololu1402 / seated AND lid closed", 40, "ACT-003", "S5"),
    "SW2": ("Pololu1402 / bolt through strike", 40, "ACT-004", "S5"),
    "CHG1": ("ToolkitRC M6AC / ground only", 60, "CHG-001", "S10"),
    "JCHG1": ("Separate QS8 male / CHARGE ONLY 5A", 60, "CHG-002", "S10"),
}
for i in range(1, 5):
    PARTS[f"M{i}"] = (f"XING-E2809 800KV / motor{i}", 10, "MOTOR-001", "S10")
for i, value in enumerate(["10k", "10k", "10k", "10k", "330", "4.7k", "4.7k", "330", "330"], 1):
    PARTS[f"R{i}"] = (value, 50 if i <= 5 else 40, "LOGIC-002", "D1")
for i, value in enumerate(["100nF 16V", "100nF 16V", "100nF 16V", "1000uF 10V"], 1):
    PARTS[f"C{i}"] = (value, 40 if i in (2, 3) else 50, "LOGIC-002", "D1")

URLS = {
    "S1": "https://micoair.cn/zh/docs/flight-controller/micoair743-aio-series/micoair743v2-aio-45a-manual",
    "S2": "https://www.mateksys.com/?portfolio=i2c-ina-bm",
    "S3": "https://www.raspberrypi.com/documentation/computers/raspberry-pi.html",
    "S4": "https://www.ti.com/lit/ds/symlink/sn74ahct125.pdf",
    "S5": "https://www.pololu.com/docs/0J60/all",
    "S6": "https://holybro.com/products/micro-m10-gps",
    "S7": "https://en.benewake.com/uploadfiles/2023/03/20230331102010281.pdf",
    "S8": "https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver",
    "S9": "https://www.dfrobot.com/product-2599.html",
    "S10": "../../../docs/hardware/baseline-r1/electrical-build.md",
    "S11": "https://www.pololu.com/product/2180",
    "D1": "../../../docs/hardware/baseline-r1/electrical-build.md",
}
ALIASES = {"PI_FAN5V2": "PI_5V2", "SOLENOID_POS": "PER_5V"}
PART_URLS = {
    "REG1": "https://www.mateksys.com/?portfolio=bec12s-pro",
    "REG2": "https://www.hobbywing.com/en/products/ubec-5a93",
    "SERVO1": "https://www.adafruit.com/product/1967", "SERVO2": "https://www.adafruit.com/product/1967",
    "LED1": "https://www.adafruit.com/product/5162", "LED2": "https://www.adafruit.com/product/5162",
    "IR1": "https://www.waveshare.com/product/infrared-led-board-b.htm", "IR2": "https://www.waveshare.com/product/infrared-led-board-b.htm",
    "SOL1": "https://www.adafruit.com/product/2776", "FAN1": "https://www.adafruit.com/product/3368",
    "BZ1": "https://viflydrone.com/collections/drone-buzzer/products/vifly-finder-v2-fpv-racing-drone-buzzer",
    "SW1": "https://www.pololu.com/product/1402", "SW2": "https://www.pololu.com/product/1402",
    "JH2": "https://www.pololu.com/product/2181",
}
PREFIX = {"Nexus": "BAT1", "AIRCRAFT_QS8M": "JBAT1", "INA": "MON1", "AIO": "FC1",
          "CAP_MAIN": "CM1", "BEC_PI": "REG1", "BEC_PER": "REG2", "DFR1015": "REG3",
          "PI40": "PI1", "PAN": "SERVO1", "TILT": "SERVO2", "RELEASE": "DRV1",
          "J_HOLDER_SOURCE": "JH1", "J_HOLDER_LOAD": "JH2", "SOLENOID": "SOL1",
          "M10": "GPS1", "RP1": "RX1", "TFMINI": "RANGE1", "FINDER": "BZ1",
          "FAN": "FAN1", "SW_A": "SW1", "SW_B": "SW2", "M6AC": "CHG1", "CHARGE_QS8M": "JCHG1"}
JUNCTIONS = ("BUS+", "BUS-", "PI_SPLICE", "PER_STAR", "SENSOR_STAR")
HELD = {"W100": "15-pin CSI factory cable; retain; internal pin mapping not modeled",
        "W101": "USB A-MicroB factory cable;5V/data cable budget and route held",
        "W102": "D500 kit sensor lead; internal mapping and received variant held",
        "W103": "RP1 factory RF/coax mate; no scalar signal-net equivalence",
        "W106": "6S balance B0..B6 order requires exact delivered connector view"}


def endpoint(text):
    if text.startswith(JUNCTIONS):
        return None
    device, pin = text.split(".", 1)
    if device.startswith("MOTOR_"):
        return f"M{device[-1]}.{pin.removeprefix('lead')}"
    ref = PREFIX.get(device, device)
    if ref in ("BAT1", "JBAT1"):
        pin = "+" if ("positive" in pin or pin.endswith("+")) else "-"
    elif ref in ("JH1", "JH2", "FAN1"):
        pin = "+" if pin.startswith("red") else "-"
    elif ref.startswith("SERVO"):
        pin = "5V" if "power" in pin else "GND" if "return" in pin else "SIG"
    elif ref.startswith("LED"):
        pin = {"IN5V": "5V", "INGND": "GND"}.get(pin.split()[0], pin.split()[0])
    elif ref.startswith("IR"):
        pin = pin.removeprefix("marked")
    elif ref == "CHG1":
        pin = pin.removeprefix("XT60")
    elif ref == "BZ1" and pin == "signal":
        pin = "BZ-"
    elif ref == "FC1" and pin.startswith("ESC"):
        pin = pin.replace(" phase", "_")
    else:
        pin = pin.split()[0]
        if pin.startswith("GND"):
            pin = "GND"
    return f"{ref}.{pin}"


def uid(text):
    return str(uuid5(NAMESPACE_URL, "bgd-electrical-r1/" + text))


def q(text):
    return json.dumps(str(text), ensure_ascii=False)


def effects(size=1.27, extra=""):
    return f"(effects (font (size {size} {size})) {extra})"


def write_csv(path, rows):
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def model():
    pins, reconciliation = {}, []

    def connect(node, net):
        if node is None:
            return
        if node in pins and pins[node] != net:
            raise ValueError(f"Conflicting node {node}: {pins[node]} / {net}")
        pins[node] = net

    rows = list(csv.DictReader((BASE / "harness-netlist.csv").open(encoding="utf-8-sig")))
    passive = {
        "C005": ("R1", "PIXEL_DATA3V3", "GND"), "C006": ("R2", "RELEASE_PWM3V3", "GND"),
        "C007": ("R3", "PAN_PWM3V3", "GND"), "C008": ("R4", "TILT_PWM3V3", "GND"),
        "C009": ("R5", "PIXEL_DATA5V", "LED_DIN"),
        "C010": ("R6", "PI_3V3", "HOLDER_CLOSED"), "C011": ("R7", "PI_3V3", "LATCH_ENGAGED"),
        "C012": ("R8", "SW_A_RAW", "HOLDER_CLOSED"), "C013": ("R9", "SW_B_RAW", "LATCH_ENGAGED"),
        "C014": ("C1", "PER_5V", "GND"), "C015": ("C2", "HOLDER_CLOSED", "GND"),
        "C016": ("C3", "LATCH_ENGAGED", "GND"), "C017": ("C4", "PER_5V", "GND"),
    }
    for row in rows:
        ident = row["id"]
        a, b, kind, note = "", "", "wire", "Logical continuity only; physical release held"
        net = ALIASES.get(row["net"], row["net"])
        if ident in HELD or ident.startswith("NC"):
            kind = "factory-cable-hold" if ident in HELD else "intentional-isolation"
            note = HELD.get(ident, row["from"] + ": " + row["routing_or_hold"])
            net = ""
        elif ident == "W030":
            kind, net, note = "factory-cable-expanded", "PER_5V;GND;LED_CHAIN_DATA", "Three conductors; never one equipotential node"
            for node, target in [("LED1.DOUT", "LED_CHAIN_DATA"), ("LED2.DIN", "LED_CHAIN_DATA"),
                                 ("LED2.5V", "PER_5V"), ("LED2.GND", "GND")]:
                connect(node, target)
            a, b = "LED1.DOUT;LED1.5V;LED1.GND", "LED2.DIN;LED2.5V;LED2.GND"
        elif ident in passive:
            ref, n1, n2 = passive[ident]
            a, b, net, kind = ref + ".1", ref + ".2", n1 + ";" + n2, "passive-component"
            connect(a, n1)
            connect(b, n2)
            note = PARTS[ref][0] + "; separate electrical nodes across component"
        else:
            a, b = endpoint(row["from"]), endpoint(row["to"])
            connect(a, net)
            connect(b, net)
        reconciliation.append({"id": ident, "kind": kind, "source_net": row["net"], "schematic_net": net,
                               "from_node": a or "junction", "to_node": b or "junction", "note": note})
    for node, net in {"LED1.DIN": "LED_DIN", "PI1.1": "PI_3V3", "PI1.16": "HOLDER_CLOSED",
                      "PI1.18": "LATCH_ENGAGED"}.items():
        connect(node, net)
    # No-connects are actual known terminals only; aggregated cable/unused GPIO
    # declarations stay in the reconciliation register instead of invented pins.
    for node in ["SW1.NC", "SW2.NC", "DRV1.VRC", "DRV1.GOOD", "DRV1.OUT", "DRV1.LRN", "LED2.DOUT"]:
        connect(node, "NC")
    for pin in ("M8", "LED", "TX2", "RX2", "TX5", "RX5", "TX8", "RX8"):
        connect("FC1." + pin, "NC")
    return pins, reconciliation


def electrical_type(ref, pin):
    if ref.startswith("#FLG"):
        return "power_out"
    if ref == "BAT1" or ref == "CHG1":
        return "power_out"
    if ref == "FC1":
        if pin in ("5V", "12V"):
            return "power_out"
        if pin == "VBAT":
            return "power_in"
        if pin.startswith("TX") or pin in ("M5", "M6", "M7", "M8", "LED") or pin.startswith("ESC"):
            return "output"
        if pin.startswith("RX"):
            return "input"
        if pin in ("SCL", "SDA"):
            return "bidirectional"
        if pin == "BZ-":
            return "open_collector"
    if ref.startswith("REG"):
        return "power_out" if pin in ("VOUT+", "OUT+") else "power_in" if pin in ("VIN+", "IN+") else "passive"
    if ref == "PI1":
        return {"1": "power_out", "2": "power_in", "4": "power_in", "8": "output", "10": "input",
                "12": "output", "16": "input", "18": "input"}.get(pin, "passive")
    if ref == "U1":
        return "power_in" if pin in ("7", "14") else "tri_state" if pin in ("3", "6", "8", "11") else "input"
    if ref == "DRV1":
        return {"VCC": "power_in", "RC_IN": "input", "LOAD_LOW": "open_collector",
                "GOOD": "output", "OUT": "output", "LRN": "input"}.get(pin, "passive")
    if pin in ("5V", "+") and ref in ("MON1", "GPS1", "RX1", "RANGE1", "BZ1", "FAN1", "IR1", "IR2", "LED1", "LED2", "SERVO1", "SERVO2"):
        return "power_in"
    if pin == "TX" or pin == "DOUT":
        return "output"
    if pin in ("RX", "DIN", "SIG"):
        return "input"
    if pin in ("SCL", "SDA"):
        return "bidirectional"
    return "passive"


TITLES = {10: "Pack, monitored distribution and motor phases", 20: "Regulated rails and branch protection",
          30: "Flight controller, radio and sensors", 40: "Compute power, UART and holder sensing",
          50: "Translated PWM, lighting and cargo release", 60: "Ground charging and factory-cable boundaries"}
NOTES = {
    10: ["DRAFT LOGICAL CIRCUIT - no physical pad or connector view is implied.",
         "PACK_POS -> INA shunt -> BUS_POS: all load branches remain downstream.",
         "Common GND uses dedicated sized returns; carbon is never a conductor.",
         "Motor A/B/C are commissioning IDs; actual pad identity/rotation remains held."],
    20: ["Regulator outputs stay separate. Shared GND does not permit sharing thin returns.",
         "F1/F2:5A32V INPUT fuses; not coordinated output-load or main-battery protection.",
         "DFR1015: remove5V bridge; select3.3V only; supply from AIO12V.",
         "IR load and servo peak demand remain provisional; no completed power-budget pass."],
    30: ["FC symbol uses named manufacturer pads; layout is NOT the physical board view.",
         "I2C pull-ups/revisions/rise time remain held; do not add blind pull-ups.",
         "Selected GPS is IST8310 SKU12044. Reserved UARTs/M8/LED remain unused.",
         "TFmini supply must stay4.9-5.1V at its connector; UART is3.3V."],
    40: ["PI1 numbers are PHYSICAL J8 pins; used subset only. Carrier2310 mates1:1.",
         "Equal22AWG tails to2/4 and6/9; inspect header joints/current sharing.",
         "No simultaneous Pi USB-C power. GPIO18 PWM audio/other waveform owners disabled.",
         "Switches: aircraft mounted, NO-to-GND only when safe; short-to-GND is not detected."],
    50: ["U1 peripheral5V island must never bridge the carrier Pi5V copper.",
         "All OEs LOW; all inputs10k pulldown. R5 at receiving LED end.",
         "DRV1 power bridges OPEN; LOAD_LOW is switched, never a permanent ground.",
         "FC-owned release timeout is mandatory: continuing stale PWM defeats pulse-loss safe-start."],
    60: ["CHARGE ONLY /5A MAX. Charge net names are deliberately separate from flight nets.",
         "No connection to a live flight configuration is represented or authorized.",
         "W100 CSI15: retain factory cable; orientation/motion loop requires mechanical review.",
         "W101 USB500mm + W102 D500100mm: cable internals/inrush/route remain held.",
         "W103 RF: exact factory mate. W106 balance: verify all7contacts B0..B6 before use.",
         "NC123-134: power bridges open, spare ports isolated; see reconciliation register."],
}


def library_symbol(ref, nodes):
    name = "BGD_" + ref
    count = (len(nodes) + 1) // 2
    height = max(10.16, (count + 1) * 5.08)
    discrete = (ref[0] in "RC" and ref[1:].isdigit()) or ref in ("CM1", "F1", "F2")
    body = f'(rectangle (start -20.32 {height/2}) (end 20.32 {-height/2}) (stroke (width 0.254) (type default)) (fill (type background)))'
    if discrete:
        height = 10.16
        line = lambda pts: f'(polyline (pts {pts}) (stroke (width 0.254) (type default)) (fill (type none)))'
        if ref.startswith("C"):
            body = line('(xy -1.27 3.81) (xy -1.27 -3.81)') + line('(xy 1.27 3.81) (xy 1.27 -3.81)')
            body += line('(xy -20.32 0) (xy -1.27 0)') + line('(xy 1.27 0) (xy 20.32 0)')
            if ref in ("C4", "CM1"):
                body += '(text "+" (at -3.81 3.81 0) (effects (font (size 1.27 1.27))))'
        else:
            body = '(rectangle (start -5.08 2.54) (end 5.08 -2.54) (stroke (width 0.254) (type default)) (fill (type none)))'
            body += line('(xy -20.32 0) (xy -5.08 0)') + line('(xy 5.08 0) (xy 20.32 0)')
            if ref.startswith("F"):
                body += line('(xy -5.08 0) (xy 5.08 0)')
    positions = {}
    for i, node in enumerate(nodes):
        pin = node.split(".", 1)[1]
        side = i // count
        x, y, angle = (-25.4 if side == 0 else 25.4), height/2 - 5.08 * (i % count + 1), (0 if side == 0 else 180)
        if discrete:
            y = 0
        positions[node] = (x, -y, side)
        label = {"PI1": {"1": "3V3", "2": "5V_A", "4": "5V_B", "8": "GPIO14_TX", "10": "GPIO15_RX", "12": "GPIO18", "16": "GPIO23", "18": "GPIO24"},
                 "U1": {"1": "1OE_n", "2": "1A", "3": "1Y", "4": "2OE_n", "5": "2A", "6": "2Y", "7": "GND", "8": "3Y", "9": "3A", "10": "3OE_n", "11": "4Y", "12": "4A", "13": "4OE_n", "14": "VCC"}}.get(ref, {}).get(pin, pin)
        body += f'(pin {electrical_type(ref,pin)} line (at {x} {y} {angle}) (length 5.08) (name {q(label)} {effects(1.0)}) (number {q(pin)} {effects(1.0)}))'
    value, _, inventory, evidence = PARTS[ref]
    properties = ''.join(f'(property {q(k)} {q(v)} (at 0 0 0) {effects(1.27,"(hide yes)")})' for k,v in
                         [("Reference", ref), ("Value", value), ("Footprint", ""), ("Datasheet", PART_URLS.get(ref,URLS[evidence])),
                          ("Description", f"Functional terminal model; {inventory}; evidence {evidence}; physical release held")])
    definition = f'(symbol {q(name)} (pin_names (offset 1.016)) (exclude_from_sim no) (in_bom yes) (on_board yes) {properties} (symbol {q(name+"_1_1")} {body}))'
    return definition, positions, height


def text_item(text, x, y, size=1.27):
    return f'(text {q(text)} (at {x} {y} 0) {effects(size,"(justify left)")} (uuid {q(uid(text+str(x)+str(y)))}))'


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    pins, reconciliation = model()
    # Standard ERC source assertions downstream of passive shunt/fuses. The
    # validator separately proves the upstream source path; flags add no hardware.
    for i, (net, sheet) in enumerate((("BUS_POS",10),("FUSED_F1",20),("FUSED_F2",20)),1):
        ref = f"#FLG{i}"
        PARTS[ref] = (f"ERC source after {'shunt' if i == 1 else 'F'+str(i-1)}",sheet,"ERC_ONLY","D1")
        pins[ref+".1"] = net
    root_id = uid("root")
    libraries, geometries = {}, {}
    for ref in PARTS:
        nodes = sorted((n for n in pins if n.split(".")[0] == ref), key=lambda n: (len(n), n))
        if not nodes:
            raise ValueError(f"No pins for {ref}")
        libraries[ref], positions, height = library_symbol(ref, nodes)
        geometries[ref] = (positions, height)
    (OUT / "bgd.kicad_sym").write_text('(kicad_symbol_lib (version 20241209) (generator "kicad_symbol_editor")\n' + '\n'.join(libraries.values()) + ')\n', encoding="utf-8")
    (OUT / "sym-lib-table").write_text('(sym_lib_table (version 7) (lib (name "BGD") (type "KiCad") (uri "${KIPRJMOD}/bgd.kicad_sym") (options "") (descr "Documented BGD module terminals")))\n', encoding="utf-8")
    (OUT / "bgd-master.kicad_pro").write_text(json.dumps({"meta": {"filename": "bgd-master.kicad_pro", "version": 1}}, indent=2) + '\n', encoding="utf-8")
    root_sheets = []
    page_count = 1
    for sheet, title in TITLES.items():
        refs = [ref for ref in PARTS if PARTS[ref][1] == sheet]
        # Split dense logical groups into additional real child sheets, preserving
        # the approved group number. Fixed A3 cells prevent overlapping symbols.
        pages, current, used = [], [], 0
        for ref in refs:
            height = max(35.56, geometries[ref][1] + 15.24)
            if used + height > 185 and current:
                pages.append(current); current=[]; used=0
            current.append(ref); used += height
        if current:
            pages.append(current)
        for sub, subset in enumerate(pages, 1):
            page_count += 1
            slug = f"{sheet:02d}-{sub}"
            sheet_id = uid(slug)
            filename = slug + ".kicad_sch"
            embedded = '\n'.join(libraries[r].replace(q("BGD_"+r), q("BGD:BGD_"+r), 1) for r in subset)
            content = f'(kicad_sch (version 20250114) (generator "eeschema") (uuid {q(sheet_id)}) (paper "A3") (title_block (title {q("BGD electrical / group "+str(sheet))}) (date "2026-09-05") (rev "E1 LOGICAL DRAFT") (comment 1 "NO FABRICATION / POWER RELEASE")) (lib_symbols {embedded})'
            content += text_item(f"{sheet:02d}.{sub}  {title}", 15, 17, 2.2)
            for i, note in enumerate(NOTES[sheet]):
                content += text_item(note, 15, 25+i*5, 1.3)
            y = 76.2
            for ref in subset:
                positions, height = geometries[ref]
                x, cy = 205.74, y+height/2
                value, _, inventory, evidence = PARTS[ref]
                props = f'(property "Reference" {q(ref)} (at {x} {y-5} 0) {effects(1.6)}) (property "Value" {q(value)} (at {x} {y-1} 0) {effects(1.3)})'
                props += f'(property "Datasheet" {q(PART_URLS.get(ref,URLS[evidence]))} (at {x} {cy} 0) {effects(1,"(hide yes)")}) (property "Inventory_ID" {q(inventory)} (at {x} {cy} 0) {effects(1,"(hide yes)")})'
                content += f'(symbol (lib_id {q("BGD:BGD_"+ref)}) (at {x} {cy} 0) (unit 1) (in_bom yes) (on_board yes) (dnp no) (uuid {q(uid(ref))}) {props} (instances (project "bgd-master" (path {q("/"+root_id+"/"+sheet_id)} (reference {q(ref)}) (unit 1)))))'
                for node, (dx,dy,side) in positions.items():
                    px, py = round(x+dx,6), round(cy+dy,6)
                    net = pins[node]
                    if net == "NC":
                        content += f'(no_connect (at {px} {py}) (uuid {q(uid(node+"nc"))}))'
                        continue
                    lx = round(px+(-15.24 if side == 0 else 15.24),6)
                    content += f'(wire (pts (xy {px} {py}) (xy {lx} {py})) (stroke (width 0) (type default)) (uuid {q(uid(node+"wire"))}))'
                    angle = 0 if side == 0 else 180
                    content += f'(global_label {q(net)} (shape bidirectional) (at {lx} {py} {angle}) {effects(1.27,"(justify left)")} (uuid {q(uid(node+"label"))}) (property "Intersheetrefs" "${{INTERSHEET_REFS}}" (at {lx} {py} {angle}) {effects(1,"(hide yes)")}))'
                content += text_item(inventory+" | "+evidence+" | function-level terminals", 280, cy, 1.0)
                y += max(35.56,height+15.24)
            content += '(embedded_fonts no))\n'
            (OUT / filename).write_text(content, encoding="utf-8")
            root_sheets.append((slug,filename,sheet_id,str(page_count)))
    content = f'(kicad_sch (version 20250114) (generator "eeschema") (uuid {q(root_id)}) (paper "A3") (lib_symbols)'
    content += text_item("B.G.D  |  Hardware Issue11 electrical E1", 20,20,3)
    content += text_item("Functional connectivity / Q75 + R1.1 / not a fabrication or power release",20,30,1.8)
    content += text_item("Module pin layout is logical. Named terminals do not assign physical connector cavities.",20,40)
    short_titles = {10:"Pack and distribution",20:"Regulated rails",30:"FC / radio / sensors",40:"Compute / switches",50:"PWM / lights / release",60:"Charge / cable holds"}
    for i,(slug,filename,sheet_id,page) in enumerate(root_sheets):
        x,y=20+(i%3)*125,60+(i//3)*30
        content += f'(sheet (at {x} {y}) (size 110 20) (stroke (width 0.254) (type default)) (fill (color 0 0 0 0)) (uuid {q(sheet_id)}) (property "Sheetname" {q(slug+" "+short_titles[int(slug[:2])])} (at {x} {y-1.27} 0) {effects(1.0,"(justify left bottom)")}) (property "Sheetfile" {q(filename)} (at {x} {y+21.27} 0) {effects(1,"(justify left top)")}) (instances (project "bgd-master" (path {q("/"+root_id)} (page {q(page)})))))'
    content += f'(sheet_instances (path "/" (page "1"))) (embedded_fonts no))\n'
    (OUT / "bgd-master.kicad_sch").write_text(content, encoding="utf-8")
    write_csv(ROOT / "electronics/harness/reconciliation.csv", reconciliation)
    write_csv(ROOT / "electronics/pinouts/schematic-pins.csv", [{"node":n,"net":v,"type":electrical_type(*n.split('.',1)),"inventory_id":PARTS[n.split('.')[0]][2],"evidence":PARTS[n.split('.')[0]][3]} for n,v in sorted(pins.items())])
    manifest = {"status":"LOGICAL_DRAFT_NOT_RELEASED", "base_commit":"68e00796f56d1975b05efa8e8f3c5c5fd504b6ac",
                "inputs":{p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in SOURCES},
                "components":sum(not r.startswith('#') for r in PARTS),"erc_source_assertions":3,"pins":len(pins)-3,"harness_records":len(reconciliation),"sheets":page_count,
                "net_aliases":ALIASES,"held_factory_records":HELD}
    manifest["schematic_sources"] = {p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest()
                                     for p in sorted(OUT.iterdir()) if p.suffix in (".kicad_sch",".kicad_sym",".kicad_pro") or p.name == "sym-lib-table"}
    (ROOT / "electronics/source-manifest.json").write_text(json.dumps(manifest,indent=2)+'\n',encoding="utf-8")
    print(json.dumps({k:v for k,v in manifest.items() if k not in ("inputs","held_factory_records","schematic_sources")},indent=2))


if __name__ == "__main__":
    main()
