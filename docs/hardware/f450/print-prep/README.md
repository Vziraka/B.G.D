# F450 prototype print preparation — 22 September 2026

**September28 combined STL verified:** exported `C:/Users/zvent/Downloads/BGD-All-Seven-Parts-One-Plate.stl` and transfer ZIP `BGD-All-Parts-One-Plate-STL.zip`. Seven closed manifold shells/7,116 triangles; consistent winding, positive volumes, no degenerate faces; geometry/layout match prior combined 3MF within0.001mm. Actual STL imports/exports through Bambu Studio02.08.02.61 with geometry preserved within0.001mm. STL carries no support settings/blockers; ZIP includes the checked 3MF and instructions for the X1E/PETG print setup. Archive CRC/byte checks pass. Evidence: `docs/hardware/f450/print-prep/bambu-combined/stl-package/STL-verification.json`; reproduction `export_combined_stl.py`. No print/email sent; manual print approval and physical fit/strength checks remain.

**September28 combined print plate:** owner requested a single job for all mounts. Created `C:/Users/zvent/Downloads/BGD-All-Parts-One-Plate-X1E-PETG.zip`: one editable Bambu project, all six models/seven pieces, instructions and evidence. X1E/0.4 hardened/Textured PEI/Polymaker PETG; per-object supports and six bore blockers retained. Source geometry/orientation preserved; fresh combined slice and exported-project re-slice succeed without recorded warnings, about 3h/39.62g. Support paths clear of Pi tie tunnels and camera/depth bores; critical layers reviewed; generated paths within bed. ZIP CRC and byte preservation pass. Evidence/reproduction: `docs/hardware/f450/print-prep/bambu-combined/`, `combine_bambu.py`, `verify_combined.py`. Original separate projects retained. Destination operator opens as project, slices, maps actual PETG slot and awaits owner manual approval. No print/email sent; physical fit/strength remain unverified.

**September26 remaining-print verification:** all five remaining projects now freshly sliced and exported with Bambu Studio02.08.02.61 for X1E/0.4mm/Textured PEI/Polymaker PETG. Corrected camera support import: disable small-overhang skipping and enable bridge support, preserving four bore blockers. All five succeed without recorded warnings; mesh/orientation preserved and six camera/depth bores clear of support paths; critical layers visually reviewed. Five editable projects (six pieces, including two battery stops), instructions, license and evidence packaged in `C:/Users/zvent/Downloads/BGD-Remaining-PETG-Prints-Bambu-Verified.zip`. About2h56m/28.16g total across separate jobs. Archive integrity and project bytes verified. Package contains no runnable G-code; recipient opens each as a project, retains settings, slices and maps actual PETG slot. Pi carrier remains separate. Prototype-print readiness only; no physical print/fit/flight qualification and no email or print sent. Owner manual approval before printing still applies. Evidence: `docs/hardware/f450/print-prep/bambu-verified/review.json`.

**September 24 Bambu Studio update:** the Pi-only project has now been imported, saved and freshly sliced in Bambu Studio02.08.02.61. Use [the editable Bambu project](bambu-pi-carrier/pi-carrier-x1e-petg.3mf) for the first print; [local sliced archive](bambu-pi-carrier/pi-carrier-x1e-petg.gcode.3mf), [settings/check results](bambu-pi-carrier/review.json) and [critical layers](bambu-pi-carrier/critical-layers.png) are available. Estimate1h2m52s/13.17g. Imported geometry matches the original and checked tie tunnels contain no support paths. X1E,0.4mm hardened nozzle and gold Textured PEI are owner-confirmed. Owner now reports PETG loaded; owner confirms AMS slot 4; exact spool label and live AMS mapping remain unchecked. Studio cloud connection -6020 prevents live printer/AMS verification. **Owner requires manual approval before sending/starting any print; none is authorized or sent.** Other five projects below remain Orca-only preparations. Software verification does not establish physical fit or print quality.


**Receipt update, September 24:** owner reports the Amazon filament received. Confirm the physical spool label and lab printer setup before using the saved project. The September 22 PETG-unconfirmed statements below describe the earlier preparation state.

Six editable **OrcaSlicer 2.4.2 projects** are sliced and digitally reviewed. Start with the **Pi carrier only**, then inspect its fit before printing the rest. No printer was connected, heated or operated. PETG receipt remains unconfirmed.

These projects assume **Bambu X1E, standard 0.4 mm nozzle, textured PEI plate and the ordered 1.75 mm Polymaker PETG**. The actual lab nozzle/plate and spool label are not yet confirmed. At the printer, have the operator verify those settings and re-slice if different. Open the project in OrcaSlicer; cross-slicer import has not been tested. Included G-code is analysis output, not a substitute for that machine check.

| Part / editable project | Print orientation and support | Slicer filament, including support/brim | Estimated total time |
| --- | --- | ---: | ---: |
| [Pi carrier — first print](pi-carrier-core-draft/pi-carrier-core-draft.3mf) | Feet down; normal supports from bed under elevated ring; tie tunnels remain clear | 13.25 g | 59 min |
| [Camera bracket](camera-bracket/camera-bracket.3mf) | Base down; organic tree supports; four saved screw-hole support blockers | 4.27 g | 35 min |
| [Forward depth bracket](forward-depth-bracket/forward-depth-bracket.3mf) | Base down; normal supports; two saved screw-hole support blockers | 3.41 g | 29 min |
| [Battery stops, pair](battery-end-stops/battery-end-stops.3mf) | Feet down, both stops; supports off | 9.06 g | 44 min |
| [Flight-stack adapter](electronics-stack-adapter/electronics-stack-adapter.3mf) | Flipped X180°, Z+6 mm: broad face down, feet upward; supports off | 6.85 g | 35 min |
| [Downward sensor cradle](electronics-flow-support/electronics-flow-support.3mf) | Flat ring/root down; supports off | 4.56 g | 28 min |

Total slicer filament is **41.40 g including temporary material**, across six separate jobs. This is not installed aircraft mass. Retain the parent design's conservative 38.72 g solid-plastic estimate until actual cleaned parts are weighed; slicing is not a reason to spend the remaining aircraft mass allowance. Estimates are not measured print times or filament use, and machine calibration/purge consumption can vary.

## Saved setup

0.20 mm model layers; four walls; five top/bottom layers; 30% gyroid where a cavity remains; 3 mm outer brim with 0.2 mm separation. Outer walls 40 mm/s, inner walls 60 mm/s, first layer 20 mm/s; maximum material flow 8 mm³/s. Thin features are largely walls/solid fill, so “30%” does not describe every section. Arc fitting is disabled for reproducible segment inspection. Supports may use their own layer heights.

Provisional PETG settings: 250°C nozzle, 65°C textured bed, part cooling 20–60%, auxiliary fan off during part printing, no active chamber heating. These temperatures are inside [Polymaker's published PETG range](https://shop.polymaker.com/products/petg). Use the actual spool instructions and the lab's material/plate procedure; do not substitute PLA or assume a different PETG formula uses this profile. Moisture condition and extrusion calibration still affect bridges, holes and layer bonding.

The [X1E machine profile](profiles/x1e-0.4.json) is flattened from the shipped Orca preset, preserving its machine start/end instructions. Print/material overrides are saved beside it. No printer-specific calibration or network credentials are included.

## What was checked and corrected

- All six final projects slice with no warnings. Exported printable vertices match the corresponding oriented STL within 0.001 mm; support-blocker volumes are nonprinting modifiers.
- Initial automatic supports entered the camera/depth screw bores. Saved blockers and the camera's tree-support routing remove that intrusion. The final sweep check found no support paths in the checked six screw bores or four Pi tie tunnels. This checks generated paths, not real PETG sag or removal damage.
- The Pi ring starts above accessible support interfaces. Its 4 mm tie-tunnel roofs bridge across the opening without support inside the tunnels. The flipped stack adapter avoids a supported underside.
- Critical-layer plots show continuous boss walls, the narrow camera/depth end webs, battery braces and flow locating walls. These thin features still need physical inspection; digital continuity does not establish tie pull-through strength or flight vibration resistance.

[Machine-readable review](slice-review.json) contains material/time estimates, warnings and opening checks. Actual extrusion-layer previews: [Pi](pi-carrier-core-draft/critical-layers.png), [camera](camera-bracket/critical-layers.png), [depth](forward-depth-bracket/critical-layers.png), [battery](battery-end-stops/critical-layers.png), [stack](electronics-stack-adapter/critical-layers.png), [flow](electronics-flow-support/critical-layers.png). Orange is removable support, blue is walls, teal is fill and purple is bridging. These plots are generated from the G-code, not the CAD silhouette.

## First physical step

When PETG and printer access are available, the operator verifies the assumed machine/nozzle/plate, then prints **only the Pi carrier**. Let it cool and remove the brim and underside supports without gouging its bearing rails. Success: both rails sit flat, four tie tunnels pass the purchased ties, and standoff hardware seats without forcing or protruding into the frame. Keep the working Pi desk setup intact until the unpowered fit session. Inspect camera/depth boss walls carefully during their later support removal; do not force a screw through a blocked hole or enlarge the electronics' holes.

## Reproduction and provenance

Portable software: [official OrcaSlicer 2.4.2 release](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/v2.4.2), asset `OrcaSlicer_Windows_V2.4.2_x64_portable.zip`, SHA-256 `feba3009dfb9d268779cca5758a1a5bc3b7d0722bf8fa48d5c57340de975d6be`, verified against GitHub's release-asset digest. Runtime stays under the repository's `tmp/slicer-tools/orca`; it is not included in the handoff zip or installed system-wide.

The bundled BBL profiles and derived JSONs are provided under the OrcaSlicer project's [AGPL-3.0 license](https://github.com/OrcaSlicer/OrcaSlicer/blob/v2.4.2/LICENSE). Their corresponding source is the [versioned profile directory](https://github.com/OrcaSlicer/OrcaSlicer/tree/v2.4.2/resources/profiles/BBL); attribution and license are retained in this folder. Project mount geometry is original B.G.D CAD.

From the repository root, run `python docs/hardware/f450/print-prep/prepare_prints.py` and then `python docs/hardware/f450/print-prep/inspect_toolpaths.py`. A part stem may be supplied to slice only that part. The second script needs Pillow, already available here. Neither script sends a print job.
