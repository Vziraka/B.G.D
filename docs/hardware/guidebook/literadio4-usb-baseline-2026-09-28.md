# BETAFPV LiteRadio 4: USB-only identity and settings read (revision 1, 28 September 2026)

**Scope:** inspect the received handheld radio on the Windows PC while the aircraft flight battery, flight controller and ELRS receiver remain disconnected. This is a **read-only** preparation card. Do not bind, flash firmware, save changed settings, calibrate, open the case, or arm anything under this card. Runbook C4 remains **NOT RELEASED** for the complete radio/receiver/flight-controller setup. Perform one numbered action at a time and check its result before advancing.

The ordered item is [RaceDayQuads' BETAFPV LiteRadio 4 ELRS 2.4 GHz](https://www.racedayquads.com/products/betafpv-literadio-4-radio-transmitter-elrs-2-4ghz), retailer SKU `23386`. RaceDayQuads' page does **not** specify Mode 1 or Mode 2. BETAFPV sells both: **Mode 2** means left-hand throttle; **Mode 1** means right-hand throttle. The actual received item must be identified before pilot training or changing controls. [BETAFPV product](https://betafpv.com/products/literadio-4-radio-transmitter); [BETAFPV mode-change guide](https://support.betafpv.com/hc/en-us/articles/51982092867609-How-to-switch-LiteRadio-4-joystick-operation-mode).

## 0. Identify the radio and mechanical stick mode

Leave the radio **OFF** and unplugged, with its separate receiver and aircraft disconnected. Read its box or underside label for `LiteRadio 4` and any `Mode 1`/`Mode 2` wording. Do not mistake the newer **LiteRadio 4 Neo** or **4 SE** for this model; their firmware files are different. With a fingertip, move each stick vertically and let go. The throttle axis usually stays where placed; the other vertical axis springs toward the center. Use the label and this feel check together: left-hand non-centering vertical axis suggests Mode 2; right-hand suggests Mode 1. Do not open or modify the radio to investigate a mismatch. [BETAFPV model choices](https://betafpv.com/products/literadio-4-radio-transmitter); [mode-change guide](https://support.betafpv.com/hc/en-us/articles/51982092867609-How-to-switch-LiteRadio-4-joystick-operation-mode).

**Pass:** model and physical throttle side are identified without a mismatch. **Report:** exact model/mode label (or “no mode label”) and which stick's vertical travel stays put. A photo is needed only if the model marking is ambiguous.

## 1. Open the correct Windows configurator

The agent downloaded the official [BETAFPV Configurator **V2.0.1** Windows x64 release](https://github.com/BETAFPV/BETAFPV_Configurator/releases/tag/V2.0.1) to `C:\Users\zvent\Downloads\BGD-BETAFPV-Configurator-v2.0.1\BETAFPV_Configurator_win32_x64_v2.0.1_20250804_2d3b75e.exe`. The ZIP matched the official GitHub asset size and extracted without error; the executable is an installer and has **not yet been run**. BETAFPV's [LiteRadio 4 support page](https://support.betafpv.com/hc/en-us/articles/36869017436953-LiteRadio-4) specifies this version for radio connection. Run the installer, then open the app and select its **radio transmitter** configuration area. Avoid a flight-controller firmware screen or a Betaflight/ExpressLRS generic flasher. Do not click **Firmware Flasher**, **Reset**, **Save**, **Calibrate**, **Bind**, or any update button.

**Pass:** BETAFPV Configurator V2.0.1 opens with a radio-transmitter connection control. **Report:** app version or exact error. A standard-path check on this PC on 28 September did not find a prior BETAFPV Configurator installation; it might still exist in a portable location.

## 2. Connect the radio, still switched OFF

With the radio's power button **OFF**, plug the included Type-C USB **data** cable into the radio and PC. BETAFPV explicitly says to leave the radio off for configuration: when it is turned on normally, its USB port does not send the configurator signal. In BETAFPV Configurator select the **radio transmitter** area and click **Connect radio transmitter** at the upper right. Do **not** hold the SETUP button while pressing Power; that enters the firmware-flash mode. [BETAFPV manual, pages 5–6 and 17](https://support.betafpv.com/hc/en-us/article_attachments/57653571112473); [product USB warning](https://betafpv.com/products/literadio-4-radio-transmitter).

**Pass:** the configurator identifies a LiteRadio 4 and displays its settings. **If it fails:** unplug USB, confirm the radio is off, retry with its included data cable, and report the exact application/Windows error. Do not install a random driver or flash firmware as a connection workaround. BETAFPV's [mode guide](https://support.betafpv.com/hc/en-us/articles/51982092867609-How-to-switch-LiteRadio-4-joystick-operation-mode) links its official USB driver if it proves necessary.

## 3. Record the untouched configuration

Read and write down only what the application **actually displays**:

| Field to look for | What to record |
| --- | --- |
| Radio model and joystick/stick mode | Exact displayed model and Mode 1/Mode 2; compare with step 0. |
| Mainboard/controller firmware | Exact version, or `not shown`. |
| Internal ELRS transmitter-module firmware | Exact version, or `not shown`—do not infer it from the mainboard version. |
| Channel or switch assignment page | Which physical `SA`, `SB`, `SC`, `SD`, `SE`, `SF` control maps to each channel; if live input bars exist, move **one** control at a time and observe which bar changes. Record `not shown` for any unavailable field. |
| Radio settings | Displayed packet rate, output power, switch mode and binding-phrase state, only if shown. Do not reveal an existing binding phrase in a shared project note; record simply `set`, `unset`, or `not shown`. |

BETAFPV's manual shows the **factory-default** map `CH1 roll`, `CH2 pitch`, `CH3 throttle`, `CH4 yaw`, then `CH5=SA`, `CH6=SB`, `CH7=SC`, `CH8=SD`, `CH9=SE`, `CH10=SF`; its diagram labels the physical switches. Defaults are a comparison, **not** evidence of this received radio's current settings. Save the observed values as a short local text note, for example `LiteRadio4-before-changes-2026-09-28.txt`. If the Configurator offers an explicit **export/backup** action, do not use it until the agent checks its effect; handwritten or typed observations are sufficient for this first pass. [BETAFPV LiteRadio 4 manual, pages 4–6](https://support.betafpv.com/hc/en-us/article_attachments/57653571112473).

**Pass:** mode/firmware/switch observations are recorded, with unknown fields marked unknown. Click **Disconnect** in the app and unplug USB. **Report:** the note's full path and any surprising difference from the manual map. There is no routine photo request; the agent can inspect the note on the shared PC.

## What this prepares, and what remains gated

The project intends `CH5/SA` for a two-position arm command and `CH6/SB` for a three-position flight-mode command, subject to actual receiver and Mission Planner channel tests. ExpressLRS 3's common Hybrid/Wide switch modes transmit `CH5/AUX1` as a two-position arming channel while `CH6` can carry multiple positions. This is a **planned assignment**, not an observed radio/receiver pass. Do not assume a switch's role solely from its letter; verify its actual channel and end positions later on the connected flight controller. [ExpressLRS switch configuration](https://www.expresslrs.org/software/switch-config/); [project interface review](../../research/build-compatibility-recheck-2026-09-20.md).

BETAFPV currently posts separate LiteRadio 4 **mainboard** firmware `v1.1.3` and **ELRS transmitter-module** firmware `v1.0.6` (28 April 2026), the latter fixing low radio output power. Those are published files, **not proof of what is installed**. The selected receiver's actual ExpressLRS major version also remains unread. After the baseline, the agent must verify exact LiteRadio 4 hardware and both actual versions, choose the matching manufacturer update if required, back up the relevant settings, perform the manufacturer's post-flash joystick calibration, then establish a version-compatible receiver bind and verify channel mapping, disarm, takeover, and link-loss behavior. Do not use LiteRadio 4 Neo/SE files or a generic ExpressLRS binary for this manufacturer's fork. [BETAFPV LiteRadio 4 support files and release notes](https://support.betafpv.com/hc/en-us/articles/36869017436953-LiteRadio-4); [BETAFPV manual](https://support.betafpv.com/hc/en-us/article_attachments/57653571112473).
