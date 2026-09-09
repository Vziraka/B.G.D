# Source One V6 7-inch DC revision audit

Research date: 2026-09-05 America/New_York; retrieval extends into 2026-09-06 UTC. Status: **documentation conflict unresolved; fabrication release blocked**. Scope: first-party frame identity, dimensions and assembly evidence for Issue 11. No frame substitution, procurement, manufacturer contact or Fusion mutation was performed by this research subtask.

Provenance: researched in the shared main checkout at `C:/Users/zvent/Downloads/B.G.D`, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This new report and the existing CAD checkpoint are uncommitted working-tree evidence; the base commit does not contain them. Parent task owns tracker/index updates, raw DXF annotation extraction and CAD checking. Existing unrelated dirty files and worktrees were preserved.

## Exact selection and source identity

The controlling retail selection remains **TBS Source One V6 7-inch DC**, identified by the manufacturer's current product route `prod:source1v6`. This is an exact product/configuration identity, **not an identified production lot or a manufacturer-confirmed drawing revision for the supplied kit**. The current product description does not provide a lot number, effective revision date or a statement that its shipped panels match a particular Git commit. [TBS selected product](https://www.team-blacksheep.com/products/prod:source1v6)

The selected reference is `So1-V6-7inDC-2025-JUL-07.dxf` at commit `232ccff173c556d23cc857f0c07a6eaa66ddbc41`, tag `v6`. Its published Git blob is `4722157f17719f98f91fd8f8c8c960c33fb45bee`, size 72,083,544 bytes. The existing local pin records SHA-256 `398556cd5f8720ac1a39b79bd1a0d1c083c6c57def55920bc17b212061b6d099`. The local source manifest provides the independent content-hash identity; GitHub's tree supplies the published blob/size. [Pinned tree API](https://api.github.com/repos/tbs-trappy/source_one/git/trees/232ccff173c556d23cc857f0c07a6eaa66ddbc41?recursive=1), [local source manifest](../../cad/reference/source-one-v6-7in/source.json)

Live history returns one commit for that exact 7-inch filename: September 17, 2025 at 04:35:06 UTC, commit message `v6`. The live default branch still resolves to the same commit. The July 7 date embedded in the filename is therefore a drawing identifier, not its Git publication date. The v6 release was published September 17, 2025 at 04:37:55 UTC; its entire description is `O4`, and the API reports no uploaded release assets. No published later change to this 7-inch file was found. This does **not** prove that manufactured stock has never changed. [File history API](https://api.github.com/repos/tbs-trappy/source_one/commits?path=So1-V6-7inDC-2025-JUL-07.dxf&per_page=100), [current history API](https://api.github.com/repos/tbs-trappy/source_one/commits?per_page=8), [v6 release API](https://api.github.com/repos/tbs-trappy/source_one/releases/tags/v6)

The same commit also contains `So1-V6-2025-AUG-19.dxf` and its DWG, alongside the explicitly named July 7-inch DC pair. An August filename alone does not establish a newer revision of the July 7-inch geometry. Do not replace the selected reference with it without matching its configuration. The tree contains eleven files: the two DXF/DWG pairs and seven accessory STLs; no separate manual, dimensioned assembly, STEP or F3D is published in that tree. This inventory statement does not assert that every embedded DWG/DXF object has been decoded. [Pinned tree API](https://api.github.com/repos/tbs-trappy/source_one/git/trees/232ccff173c556d23cc857f0c07a6eaa66ddbc41?recursive=1)

## Manufacturer dimensions versus unresolved assembly

The following are **manufacturer-verified nominal product-page specifications**, not measured received-part values. No manufacturing tolerances accompany them. All numeric values in this table come from the selected 7-inch product page, not the 5-inch model. [TBS specification and hardware list](https://www.team-blacksheep.com/products/prod:source1v6)

| Parameter | Manufacturer nominal |
|---|---:|
| Wheelbase designation | 313 mm |
| Upper panel thickness | 2 mm |
| Intermediate panel thickness | 2 mm |
| Lower panel thickness | 2.5 mm |
| Arm and arm-spacer thickness | 6 mm each |
| Camera side-panel thickness | 2 mm |
| Electronics mounting pitches | 30.5 × 30.5 and 20 × 20 mm |
| Spacer inventory | Four 30 mm, four 22 mm, two 20 mm |
| Spacer diameter/thread | OD 5 mm; M3 |
| Screw inventory | Sixteen M3×10, four M3×12, four M3×14 |
| Press-in nut inventory | Eight M3 |
| Advertised frame mass | 173 g |

The page's abbreviated height specification mentions 30 and 22 mm, while its detailed hardware list additionally names two 20 mm spacers. Keep all three lengths in the inventory. The online manual is marked unfinished. Neither text section assigns every spacer length to named panel holes or states assembled panel-to-panel heights. [TBS assembly information](https://www.team-blacksheep.com/products/prod:source1v6)

The following remain unavailable from the reviewed authoritative online text: brace thickness; panel/profile name cross-reference; orientation and bearing-face order of the arm sandwich; each spacer's exact attachment points; usable electronics-bay height; total assembled height; press-nut projection and orientation; screw assignments and permitted engagement. These are engineering evidence holds. Actual part tolerances, flatness and fit remain separate received-part validation requirements even after nominal drawings are reconciled.

Motor-mount hole geometry and exact central-hole coordinates must be reported as **derived from the pinned drawing**, using the parent task's extraction. The product page supplies the nominal central pitches but no exact motor-hole/slot dimensions. Neither these derivations nor a 1:1 import proves that current retail parts use the identical drilling pattern.

## Discrepancy classification

**Outcome: documentation conflict remains unresolved.** The existing CAD checkpoint reports 2 mm drawing labels versus the current 2.5 mm lower-panel listing. The parent's current raw-file inspection further distinguishes actual `TEXT` annotations from the header's `$THICKNESS` value of 0.0; its source-label evidence should control the final annotation-to-profile mapping. Thus there is no basis to dismiss the observed 2 mm as a harmless automatic 2D-extrusion default. [Existing CAD checkpoint](../../cad/engineering-progress-2026-09-05.md)

| Candidate explanation | Evidence assessment |
|---|---|
| DXF is a different frame revision | Possible; no first-party revision-to-stock mapping establishes this. |
| In-plane geometry correct, thickness default non-authoritative | Geometry is valid for the published drawing; current stock identity is unconfirmed. Actual annotations prevent treating the conflict as merely a default field. |
| Product page reflects a newer revision | Possible; no dated first-party engineering change notice or later 7-inch commit establishes it. |
| Documentation conflict remains unresolved | Supported and selected; do not fabricate dependent parts using an asserted reconciliation. |

A consistent-looking assembly or arithmetic such as 30−22=8 mm cannot establish which panels bound those lengths. Do not convert a successful collision screen into a manufacturer-verified stack. Until an authoritative assembly cross-reference exists, Z-stack alternatives may only be explicitly provisional sensitivity models, never the released reference.

## Other evidence checked and excluded

The repository owner confirmed that v6 files had been uploaded, but did not supply thickness or stack clarifications in the inspected discussion. An independently submitted F3D/STEP ZIP appears later in issue 47; its author is not identified as the manufacturer and the comment does not establish 7-inch revision/stock correspondence. It cannot settle this gate. Dealer comments in issue 44 discuss dimensions without establishing that they apply to this selected 7-inch revision. No community assembly was promoted to authoritative geometry. [Owner confirmation](https://github.com/tbs-trappy/source_one/issues/44#issuecomment-3305452167), [issue 44 comments API](https://api.github.com/repos/tbs-trappy/source_one/issues/44/comments), [unverified assembly attachment notice](https://github.com/tbs-trappy/source_one/issues/47#issuecomment-4390785103)

The separate official V6 5-inch product and the 5-inch RTF configuration were inspected as identity checks, not dimensional sources for this frame. V5/HD kits and older V3 assembly notes likewise cannot establish V6 7-inch compatibility. The test-shop mirror did not yield an additional accessible authoritative drawing. [Separate 5-inch product](https://www.team-blacksheep.com/products/product:8547), [5-inch RTF specification](https://www.team-blacksheep.com/products/prod:source_1_rtf)

## Recommended inquiry and release rule

Retain the prepared manufacturer inquiry and tighten it to these three deliverables before seeking approval to send:

1. Confirm which current production revision/lot of `prod:source1v6` matches `So1-V6-7inDC-2025-JUL-07.dxf` at the pinned commit, or provide the superseding 7-inch source. Explain the drawing's 2 mm labels versus the product's 2.5 mm lower-panel specification.
2. Supply an annotated side section or exploded assembly mapping the top/middle/bottom/brace/arm spacer to drawing profiles, with every thickness and the locations of the 30/22/20 mm spacers. Include panel bearing-face heights and screw/press-nut orientation.
3. Confirm unchanged motor and electronics hole patterns, applicable tolerances, screw engagement limits, and any mounting-relevant revision changes.

No inquiry has been sent. The reference is **not fabrication-safe**. Receipt of an authoritative answer can unblock nominal Z construction and digital checks; incoming-part dimensional inspection still precedes dependent fabrication release. The 48 mm AIO adapter must remain unreleased and its previous nominal standoff result cannot be upgraded by this research alone.
