# Adjustable battery retention — 22 September 2026

Two printed end stops are now modeled, compiled and rendered. They supplement two transverse straps and the ordered100 × 50 × 2 mm grip pad; there is no full tray. **The design now specifies two16 × 300 mm straps** for the full candidate envelope; the already ordered16 × 250 mm straps remain usable if the ordinary installation demonstrates sufficient engagement. This is a **fit prototype**, not flight-qualified hardware. Battery choice remains open and no purchase was made.

[Editable OpenSCAD](battery-end-stops.scad) · [pair STL](battery-end-stops.stl) · [render](battery-end-stops.png) · [mesh evidence](battery-mesh-check.json)

## Envelope and evidence

| Item | Design input or result |
| --- | --- |
| Candidate battery body range | 137–160 mm fore/aft, 44–51 mm wide, 31–53 mm high; geometry range only, subject to strap screen below |
| Source of range | Current BOM's HOOVO 139 × 47 × 48.5 mm ±2 mm; OVONIC softcase 154 × 48 × 34 mm ±3 mm; OVONIC hardcase 139.5 × 47.5 × 50 mm ±3 mm; canceled pack's160 mm upper bound retained for adjustment only |
| Each stop | 68 mm across × 27 mm fore/aft × 18 mm high, side feet project24 mm inward alongside pack |
| Side opening | 54 mm, leaving at least1.5 mm per side around widest51 mm pack; no tight cavity |
| Cable opening | 20 mm wide center notch, open below the18 mm fingers; notch's top2.5 mm is occupied by crossbar |
| Placement | Below lower plate, pack centered fore/aft. Feet against plate underside; fingers point down at pack ends. Stops independently positioned to lightly meet end faces without squeezing the pack |
| Service | Reserve30 mm behind pack for disconnected EC5/balance-lead access and restrained wiring; do not force a cable outlet against a finger |
| Print mass | Closed-mesh volume7083.09 mm³ for both; **9.21 g solid PETG at1.3 g/cm³**. Add actual ties/straps/pad mass separately. With revised Pi carrier11.35 g,20.56 g of40 g print allowance used before other brackets |

The [live BOM](../../increment-1-2-bom.md) preserves exact variants and listing tolerances. [OVONIC's6000 mAh product page](https://us.ovonicshop.com/products/ovonic-4s-lipo-battery-120c-6000mah-14-8v-with-ec5-plug-2pcs) and the [RDQ strap page](https://www.racedayquads.com/products/rdq-new-logo-kevlar-lipo-strap-w-woven-rubber-grip-and-metal-buckle-3pk) were revisited September22. No nominal battery dimensions are treated as a received-pack measurement. Width68 mm applies locally at the ends and supersedes the preliminary60 mm retention-zone width there; main body remains ≤51 mm. Parent layout must keep downward sensor and legs outside this end-stop region.

## Strap and stop routing

Place the existing grip pad centrally between lower plate and battery, uncut. Run two transverse straps through existing plate slots immediately beside the pack, separated fore/aft on the100 mm pad zone. They hold weight and provide lateral restraint. Do not wrap the entire96 mm plate. Keep buckles beside the pack, with fastener heads and excess tails secured clear of solder joints and sensors. The stops provide fore/aft contact; they do not replace the two primary straps.

Each stop has two slotted feet beside the battery; each foot has two separate closed slots. Lash each foot using **two opposed diagonal3 mm ties** to existing frame slot/web anchors, one resisting inward motion and the other outward motion: eight ties total. A loose loop through one elongated slot does not locate a stop. Select anchors on opposite fore/aft sides of the foot so tension resists sliding in both directions; keep tie heads outside battery contact. Existing-frame slot positions are photo-derived, not dimensionally verified. If those opposed routes cannot be achieved without crossing an electrical joint, do not accept the mount—change the stop's feet/anchor layout. No drilling or substitution for arm/landing-leg screws is proposed.

This routing is still an assembly hypothesis. Printed feet need solid plate contact rather than hanging over a slot, and frame webs must not cut ties. Smooth printed contact edges; no burr or point may bear on battery wrapper. Strap pressure is only enough to hold the pack, never enough to dent a soft case. Use a rigid weighted dummy for retention proof before putting a LiPo under test loads.

## Calculated limits, not physical certification

For a conservative strap screen, let S be the slot-to-slot lateral span in mm and H the battery height. Allow2 mm pad,2 mm assumed plate thickness,10 mm aggregate bends/buckle allowance, and30 mm engaged hook-and-loop overlap. Required length ≈ **2(S + H + 4) +10 +30**, therefore the ordered250 mm strap screens in only when **S + H ≤101 mm**. This estimate uses a rectangular path and is intentionally conservative; actual usable fastener length and buckle geometry remain unknown. Thirty millimetres overlap is a prototype acceptance target, not a manufacturer-rated strength guarantee.

- OVONIC softcase worst-case51 ×37 mm cross-section, S55 mm:232 mm total;18 mm screening margin.
- HOOVO worst-case49 ×50.5 mm, S53 mm:255 mm; **does not clear this conservative screen** with ordered straps.
- Largest51 ×53 mm, S55 mm:264 mm; the ordered250 mm length **does not clear the screen**. This is a conservative screening shortfall, not proof that the actual supplied straps fail.

### Resolved strap size

Specify **two16 × 300 mm straps**, keeping the ordered width rather than assuming wider straps fit the existing frame slots. At the largest pack and55 mm route span,300 mm provides36 mm screening reserve beyond the264 mm requirement; even60 mm slot span leaves26 mm reserve. No CAD redesign or further owner measurement is needed to choose this size. Existing250 mm straps need not be discarded or replaced if their normal installed route actually produces at least30 mm engaged hook-and-loop overlap.

A concrete manufacturer example is [Lumenier16 × 300 mm, three-pack, SKU14688](https://www.lumenier.com/products/lumenier-indestructible-kevlar-lipo-strap-16x300mm-3pcs), listed at6.30 g each and$9.49 per pack before shipping/tax on September22. Two installed straps therefore add12.60 g before any retained excess-tail hardware; do not add the unused third strap to aircraft mass. This is a design provision, **not a purchase or checkout authorization**.

Source identity was checked by direct HTML retrieval because the page's metadata title incorrectly says16 × 220 mm: the actual H1, specification list, embedded product title and product variant all identify16 × 300 mm, SKU14688, barcode751313219206. The [RDQ listing for the same SKU](https://www.racedayquads.com/products/lumenier-indestructible-kevlar-lipo-strap-16x300mm-3pcs) corroborates those dimensions and mass. The product is not identified from its URL alone.

Nominal catalog length is not synonymous with usable fastening length: stitched ends, buckle path and the lengths of the hook/loop sections determine actual engagement. The manufacturer does not publish those individual lengths. The extra36 mm is a screening reserve, not a promise of66 mm engagement or a certified load capacity. Confirm the specified minimum engagement and secure tail routing during ordinary assembly; this need not hold up the CAD work.

At max53 mm body height,2 mm pad and3 mm conservative lower strap/buckle projection, static ground gap is **G −58 mm**, where G is loaded bottom-plate underside height. The project's30 mm clearance criterion requires **G ≥88 mm**. Seller's150 mm gear drawing would imply92 mm gap but is not a loaded-height measurement. End-stop fingers18 mm deep do not become the lowest point. Installed reference for parent CAD: lower plate topz0, assumed undersidez−2, battery topz−4; max body bottomz−57, lower retention allowance toz−60.

An optional longitudinal third strap is deliberately omitted: it would compete with the cable outlet, cost length, and still need verified anchor geometry. Positive end stops plus two weight-bearing straps are the current prototype approach. Mathematical geometry cannot certify layer adhesion, tie creep, softcase pressure or landing-gear deflection.

## Print and eventual decisive check

Print both as supplied, flat feet on bed, PETG; initial0.2 mm layers, at least4 perimeters, solid thin sections. Slicer settings are provisional; inspect that all walls, gussets and slots print intact. This orientation needs no support. Printed edges contacting a battery must be smooth. Installed model is inverted relative to print orientation; the SCAD `view="assembly"` preview includes a non-exported nominal pack.

OpenSCAD2021.01 CGAL reports `Simple: yes`. An independent ASCII-STL topology/volume check found1272 triangles, two components (the intended pair), every edge shared by two triangles, print arrangement68 ×63 ×18 mm and the mass above. These checks establish printable closed geometry only.

No owner measurement is needed to continue CAD. At the ordinary disconnected installation, the decisive remaining check is: both primary straps have the stated overlap and cannot walk sideways; opposed stop ties cannot slide; the battery/dummy cannot translate fore/aft or laterally under firm hand load; no wrapper deformation, cable pinch or sharp contact; completed aircraft on its legs has ≥30 mm static ground clearance with additional allowance for leg flex. Recheck after thermal/vibration exposure before flight qualification. Actual useful load and retention strength have not been demonstrated; final pack choice and first fit remain dependencies.
