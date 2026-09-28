# 0002: Camera above the frame, lidar plane below the body

Date: 2026-09-11

Status: **superseded for live work** (14 Sep 2026). Kept only as C1 history. Current path is increment 1+2 in [CURRENT.md](../CURRENT.md) (no lidar on the first aircraft).

## Context

Candidate C1B carried the Pixel 6a camera in a belly pocket (lens 73 mm below the body origin) and the LD19 on top of the avionics tower (laser plane 66 mm above the origin). With the camera at the 1.3 m search height, the laser plane sat at 1.44 m and missed ordinary 1.2–1.5 m entrants. The bounded repair of an inverted LD19 under the belly at −180 mm on slender rods left a 6.9 mm vertical margin against a 1.2 m person and failed under a sustained 1–2° roll, 20 mm of altitude error, or the admitted 1.2° scan gap on a 4.76 mm rod ([decision](../hardware/candidate-c1-2026-09-11/side-entry-feasibility-decision.md)). Lowering the whole aircraft is excluded: the retained search planner needs at least 1.30 m of camera height for the 600 s ground-object search (73 views at 1.30 m and above, 77–140 views and 620–1240 s below).

The quantity that matters is the vertical offset between camera and laser plane, not the flight height. The search evidence fixes the camera at 1.3 m; the entrant cases need the plane at or below about 0.92 m; the ground-return geometry needs it at or above about 0.84 m so that a 7.3° acceleration pitch on a 2° uphill slope does not put ground inside the 5.12 m guard.

## Decision

1. Move the phone to a printed cage on the existing four-standoff tower above the top plate, camera facing forward, 1° down mount retained, lens about 0.20 m above the body origin (in-memory CAD frustum check clears the rotor discs from lens z ≥ 0.175–0.20 m depending on x; below that the front discs intrude).
2. Invert the LD19 under the belly on a printed hanger from the belly carrier rails, laser plane about 0.184 m below the origin, mounting face up, cable to the FC UART. Firmware orientation set for an inverted scanner.
3. Replace the 150 mm skid set with four 3/16 in 6061-T6 rods about 0.20 m long, attached under the arm-tip stubs and splayed outward so each rod crosses the laser plane at a radius of at least 0.27 m (angular half-width under 0.6°, so a 1.2° raw gap masks at most one ray per rod). Foot plane about 0.25 m below the origin; 60 mm housing ground clearance.
4. Control envelope: horizontal acceleration limited to 1.25 m/s² (search schedule 595 s, still under 600 s), braking authority at least 1.5 m/s² with a 5 m/s³ ramp modelled, and an attitude-aware ground filter that discards returns computed within 0.2 m of the ground (ArduPilot `PRX1_IGN_GND` with `PRX1_ALT_MIN` set for the sensor offset, or an equivalent patch). The entrant cases pass with or without the filter.
5. Lamp, power branch and USB routing move with this revision: the old LED bar, buck and MOSFET leave the CAD; the Cree CMA1303 on the Ohmite R2A-CT4-38E sink with the BJB holder, LDD-500LW driver and two-NPN lug are integrated on the belly front with an isolated hot mount.

With the camera at 1.3 m the laser plane is at 0.916 m, 0.284 m below a 1.2 m entrant's head. Replays with sustained ±2° roll, 1.2° gap at its worst phase, ramped braking and ±0.10 m altitude error give 2.14–2.20 m centre separation on the leg-shadow approach and 3.5 m on the side approach, all without contact.

## Consequences

- Search geometry is unchanged (camera height, mount angle, tile schedule); only the camera XY offset changes, which shifts the retained 70-view schedule by under 2 s.
- The centre of mass rises about 30 mm and the aircraft is about 0.2 m taller; backpack portability is preserved but the phone cage is the tallest part.
- The phone sits in rotor inflow: better convective cooling, new vibration exposure, and the lower field edge is within 3° of the front disc tips. Image quality at that edge is a physical check.
- A 1.0 m entrant is still below the plane margin (0.084 m) and fails; that height is outside the required 1.2/1.5 m cases and is recorded, not hidden.
- The belly pocket, lidar deck, USB tower-clearance geometry, power route, mesh/depth admission evidence, drawings, print studies, mass, energy and cost all need regeneration against the new geometry. Prior C1B revisions remain preserved.
- Real LD19 gap and jitter, altitude-hold accuracy, steady roll in wind, beam divergence on a 0.3 m person, strut silhouette and landing loads remain physical checks; none of them changes the geometric margin argument above.
