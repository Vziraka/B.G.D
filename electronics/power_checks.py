"""Reproduce labeled E1 power calculations; no complete-budget pass is possible."""
import json
import hashlib
import math
from pathlib import Path


def i2c_window(capacitance_pf, rise_ns, v_pullup=3.3, vol_max=.4, sink_ma=3):
    """TI SLVA689 calculation; device sink capability is a scenario input."""
    args = (capacitance_pf, rise_ns, v_pullup, vol_max, sink_ma)
    if not all(math.isfinite(v) and v > 0 for v in args) or v_pullup <= vol_max:
        raise ValueError("Positive finite parameters and pullup voltage above VOL required")
    r_min = (v_pullup - vol_max) / (sink_ma / 1000)
    r_max = rise_ns * 1e-9 / (.8473 * capacitance_pf * 1e-12)
    return {"minimum_ohm":r_min, "maximum_ohm":r_max, "feasible_in_scenario":r_min <= r_max}


def main():
    closed_v = 3.3 * 330 / (4700 + 330)
    result = {
        "status": "PARTIAL_CALCULATIONS_NOT_HARDWARE_QUALIFICATION",
        "pack_full_charge_v": 6 * 4.2,
        "compute_capacity_allocation_a": 3 + .2,
        "compute_capacity_allocation_w": 5.2 * (3 + .2),
        "compute_source_unallocated_a": 5 - 3 - .2,
        "pi4_usb_aggregate_limit_a": 1.2,
        "sensor_known_partial_a": .2 + .2 + .001,
        "sensor_unallocated_ceiling_a": 2 - .2 - .2 - .001,
        "solenoid_at_exact_5v_min_specified_resistance_a": 5 / (4.5 * .95),
        "lamp_investigation_scenario_a_NOT_maximum": 2 * 4 / 5,
        "peripheral_left_for_servos_control_in_scenario_a": 5 - 2 * 4 / 5 - 5 / (4.5 * .95),
        "ir_inherited_nominal_allowance_a_NOT_maximum": 6 / 3.3,
        "ir_rating_minus_nominal_allowance_a": 3 - 6 / 3.3,
        "shunt_loss_at_85_9232a_w": 85.9232 ** 2 * .0002,
        "shunt_loss_at_107_404a_w": 107.404 ** 2 * .0002,
        "switch_closed_nominal_v": closed_v,
        "two_switches_closed_nominal_a": 2 * 3.3 / (4700 + 330),
        "switch_rising_tau_us": 4700 * 100e-9 * 1e6,
        "switch_closing_tau_us": (4700 * 330 / (4700 + 330)) * 100e-9 * 1e6,
        "compute_full_5a_output_input_at_18v_eta88_a_excludes_iq": 5.2 * 5 / (18 * .88),
        "compute_full_5a_output_input_at_25_2v_eta88_a_excludes_iq": 5.2 * 5 / (25.2 * .88),
        "unknowns": ["Full lamp module current", "Coincident servo/stall currents", "RP1 and Finder peak demand",
                     "Pi/camera/scanner measured aggregate and USB inrush", "Fan allowed5.2V tolerance",
                     "IR module curve and actual regulator efficiency", "Protection coordination and thermal derating"]
    }
    result["continuation_2026_09_06"] = {
        "sources": {
            "fuse_family":"https://www.littelfuse.com/assetdocs/fuse-selection-guide?assetguid=1d99e3a6-f314-48d7-b124-9d5d56955f09",
            "compute_regulator":"https://www.mateksys.com/?portfolio=bec12s-pro",
            "i2c":"https://www.ti.com/lit/pdf/slva689",
            "scanner":"https://www.waveshare.com/wiki/D500_LiDAR_Kit"
        },
        "fuse_5a_family_opening_cases": [
            {"input_current_a":5 * multiple,"minimum_seconds":minimum,"maximum_seconds":maximum}
            for multiple,minimum,maximum in [(1.1,360000,None),(1.35,.75,600),(2,.15,5),(3.5,.08,.5),(6,.03,.1)]
        ],
        "compute_documented_short_tolerance_seconds":2,
        "output_fault_guaranteed_cleared_by_input_fuse":False,
        "note":"False means not established; no measured fault result or failure-time prediction.",
        "scanner_sensor_published_operating_a_NOT_peak":.290,
        "pi_usb_limit_minus_scanner_operating_a_before_adapter_others":1.2-.290,
        "tfmini_loop_resistance_ceiling_scenarios_ohm": {
            str(v):(v-4.9)/.2 for v in [4.9,4.95,5.0,5.1]
        },
        "tfmini_note":"Includes both conductors/joints. Source voltages are conditional worst-case terminal values; no noise allowance or installed-wire qualification.",
        "i2c_assumed_device_sink_ma_NOT_verified":3,
        "i2c_windows": {
            f"{cap}pF_{rise}ns":i2c_window(cap,rise) for cap in [50,100,200,400] for rise in [1000,300]
        },
        "i2c_4700ohm_100pf_rise_ns":.8473*4700*100e-12*1e9,
        "i2c_two_4700_parallel_100pf_rise_ns":.8473*(4700/2)*100e-12*1e9,
        "c4_ideal_1a_deficit_time_to_0_1v_droop_ms":1000e-6*.1/1*1000,
        "c4_note":"Nominal ideal capacitor only; ESR/ESL, tolerance and supply response excluded. Not sustained-load capacity."
    }
    assert .21 < closed_v < .22
    assert 1.16 < result["solenoid_at_exact_5v_min_specified_resistance_a"] < 1.18
    assert 2.2 < result["peripheral_left_for_servos_control_in_scenario_a"] < 2.3
    assert result["sensor_known_partial_a"] < 2
    example = i2c_window(200,300)
    assert math.isclose(example["minimum_ohm"],966.6666666667)
    assert 1770 < example["maximum_ohm"] < 1771  # Published TI worked example.
    assert not i2c_window(400,300)["feasible_in_scenario"]
    for bad in (0,-1,float("nan"),float("inf")):
        try:
            i2c_window(bad,300)
        except ValueError:
            pass
        else:
            raise AssertionError("Invalid I2C input accepted")
    root = Path(__file__).resolve().parents[1]
    evidence = [Path(__file__), root/"electronics/component-evidence-review.md"]
    result["calculation_source_hashes"] = {p.relative_to(root).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in evidence}
    Path(__file__).with_name("power-calculations.json").write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
