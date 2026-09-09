# Lower-cost seven-inch propulsion and endurance redesign

Date: 2026-08-31. Status: engineering candidate for review, not an approved shopping list, validated aircraft, battery-building guide or flight procedure. No purchase, supplier contact, installation or powered test was performed. This subtask changes only this report.

## Finding

**A constructive replacement exists for the previous high-current motor/XT60 combination:** four **iFlight XING-E2809 800KV** motors, two **APC7x4E** and two **APC7x4EP** two-blade propellers, and a **factory Nexus6S2P MolicelP50B pack ordered with its QS8-female/8AWG option**. Use the coordinated whole-pack measurement and aircraft power path described in the companion power report. The motor/prop combination reduces modeled simultaneous full-output demand to approximately **61A centrally**, with a deliberately unfavorable parameter corner of **81.92A propulsion +4A auxiliary allowance =85.92A**. This fits an **88A engineering design budget below the connector manufacturer's lower published110A rating**. It does not depend on a delayed flight-controller current limiter.

The final fully equipped reference mass is **1,897.25g** after replacing the broad case/cooling and pan/tilt allocations with named lighter assemblies, without removing functions or existing contingency. The joint battery-sag/propulsion model predicts **20.98 useful minutes centrally**, using148Wh to a defined battery-curve state while retaining the approved independent reserve. At that same state, a conservative coincident full-command/4A-auxiliary calculation gives **1.375 thrust/weight**, above the provisional1.35 engineering screening target. A moderate loss case still predicts **18.20minutes**. This is a defensible design experiment with a measurable acceptance budget, **not proven endurance or a robust guarantee across the uncertainty range**.

The hardware is also **not within the unchanged$900 complete-project ceiling**: the coordinated complete-project ledger is approximately **$1,862.64**, including explicit allowances. This bounded search identifies the least-cost sufficiently documented propulsion direction found here, not a global minimum or proof that a cheaper solution cannot exist. All Q1–Q74 remain, including recipient verification, the250g cargo target, independent radio, fully installed sensing/compute/video and the seven-inch self-build. [Complete cost](least-cost-bom-2026-08-31.md), [authoritative decisions](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments)

## Exact proposed propulsion and source facts

| Item | Exact fact used | Cost and stock snapshot |
|---|---|---|
| iFlight **XING-E2809 800KV**, four | **61g including260mm18AWG leads**,129.3mΩ interphase resistance,5mm shaft,15.5mm protrusion,19×19mmM3 mount,33.2mm diameter,39.3mm overall height. Manufacturer states24V input; its own800KV Chimera9 configuration is6S. Do not substitute the1250KV winding or XING2 model. | Manufacturer storefront shows800KV selected, **$31.99 each**, In Stock; four **$127.96**. |
| APC **LP07040E**, two installed | Seven-inch diameter,4-inch pitch, two blades, Thin Electric. Hub12.7mm diameter,8.382mm thick,6.35mm bore; supplied adapter-ring sets. **0.28oz ≈7.938g** each. | **$2.71** each; direct Add to cart. |
| APC **LP07040EP**, two installed | Reverse-rotation matching Thin Electric Pusher; same published dimensions/mass. The opposite direction is required, not four identical E props. | **$2.71** each; direct Add to cart. |
| Propeller inventory | Four aboard **31.751g**, one full set$10.84. One installed plus one complete initial spare set means fourE and fourEP; only one set contributes flight mass. | Eight props **$21.68**. Another complete set is an optional later$10.84, not counted as owned. |

Sources: [iFlight exact winding and offer](https://shop.iflight.com/XING-E-2809-Cinelifter-Motor-Pro2064), [manufacturer China800KV specification](https://www.iflight.cn/XING-E-2809-Pro2022?tag=XING-E), [APC7x4E](https://www.apcprop.com/product/7x4e/), [APC7x4EP](https://www.apcprop.com/product/7x4ep/).

The HawkSpeed link currently redirects to HPXGRC and displays1PCS/4PCS,800KV/1250KV, In stock and$25.99. Four single motors could therefore save$24, but exact variant inventory/quantity pricing was not independently recoverable from its public product JSON because it returned403. Keep **$127.96 manufacturer-direct** as the firm comparison basis; the **$103.96 retailer route is a conditional offer to recheck**, not an assumed four-pack sale or an authenticity assurance. [Retailer's own offer](https://www.hpxgrc.com/products/iflight-xing-e-2809-1250kv-800kv-4-6s-fpv-cinelifter-motor)

### RPM and attachment compatibility

APC's **Thin Electric** limit is150,000 divided by diameter in inches, hence **21,428.6RPM** for these exact props. The higher190,000 rule for other prop families and the lower MR/Slow Flyer rules must not be substituted. At the actual6S maximum25.2V, nominal800KV no-load speed is **20,160RPM**; with a proposed+5% motor-KV tolerance screen it is **21,168RPM**, below the prop limit by260.6RPM. The +5% bound is an engineering assumption, **not a published iFlight production tolerance**. It needs confirmation by appropriate motor/RPM evidence before release; a higher actualKV or bus voltage invalidates this screen. Full-load modeled speed is lower, but prop unloading is why the no-load calculation is retained. [APC RPM limits](https://www.apcprop.com/technical-information/rpm-limits/)

The motor's M5/5mm shaft needs a concentric5mm adapter ring for the prop's6.35mm bore. APC lists the includedLPAR18SF/LPARM12SF sets; receiving inspection must establish the exact correct ring, hub seating and nut engagement. The dimensional subtraction15.5−8.382 leaves approximately7.12mm of protrusion before any additional washer/ring effects. That is a plausible mounting arrangement, not proof of the supplied nut's engagement. Motor screws also need correct engagement without touching windings; includedM3×11 screws are not automatically the correct length for this frame.

The parent layout analysis supplies the frame's motor centers and preliminary equipment placement. Seven-inch diameter alone does not prove clearance to a tall pack cradle, landing structure, gimbal, cables or cargo. The fixed mass budget below includes mounts; if a safe layout needs more mass, recompute it explicitly. Fore/aft center of gravity must be close enough to the rotor centroid for the equal-load model; a badly balanced aircraft cannot claim these four-equal-motor results.

## Complete airborne mass, without dropping later features

| Row | Mass(g) | Basis |
|---|---:|---|
| Retained nonpropulsion equipment |621.500| Coordinated budget ledger: MicoAir AIO10 +adapter10; D50045; TFmini-S5; Pi/fan/guard/itsSD70; camera4+ribbon5; pan/tilt40; GPS/radio/FCSD/backup equipment; lighting; regulators including the8g DFR1015 IR sub-regulator; structural/harness allowances. This aggregate is not a measured assembly. |
| Four800KV motors |244.000|4×61, including their supplied leads. |
| Four APC props |31.751|4×0.28oz. |
| Configured factoryP50B pack |930.000| Maker approximate900g plus30g configuration/mass uncertainty allowance. This is not an assertion that the option weighs exactly930g. |
| Dedicated main power path |70.000| Aircraft QS8 mate,8AWG conductors, whole-pack INA monitor,1000µF35V capacitor and mounting/insulation allowance; distinct from the retained structural/thin-wire allowance. |
| **Reference, no cargo or removable holder** |**1,897.251**| Full mission equipment installed. |
| Secure removable holder |170.000| Existing provisional allowance including latch/actuation; not yet a measured safe design. |
| Approved cargo incl packaging |250.000|Q71 target. |
| **Loaded design case** |**2,317.251**| No twenty-minute loaded-flight promise. |

The621.5g aggregate derives from the earlier682g nonpropulsion ledger, plus8.5g for the peripheral regulator, plus8g for the IR regulator, minus35g for compute housing/cooling and minus42g for pan/tilt. A21g Hobbywing peripheral BEC replaces one12.5g share of the earlier25g dual-Matek allowance. It retains **100g as an explicit target for structural mounts, cradle, mast, landing clearance, straps, permanent delivery interfaces and thin wiring**, and **50g additional unallocated integration contingency**. The new70g main path is separate. The100g is a design allocation to meet, not free mass that may be spent twice. The10g AIO adapter is also a target; if the actual adapter is heavier, record the difference. TheDFR1015 provides the distinct3.3V IR supply from the MicoAir12V rail; its8g is counted even for daylight. Nighttime lighting duty cannot inherit theQ74 daylight power prediction.

The **70g compute assembly** retains the same Pi4/2GB and unmodified ports:48g Pi allowance (published46g plus2g revision allowance), Adafruit3368 fan6.2g, Adafruit3082 heatsink3.6g, SD1g and11.2g insulating guard/base/local fasteners and short wiring. The guard's geometry/fabrication allowance is documented in the integration report; it is not an already manufactured enclosure. The **40g camera mount** is Adafruit1967's published37g assembled two-servo mount plus3g camera adapter, replacing the82g Waveshare package allocation. It uses the documented free FC PWM5/6 timer group instead of another HAT/driver. Camera and ribbon stay separately counted. Neither the30g configured-pack allowance nor50g contingency was reduced. [Compute source and guard design](least-cost-integration-2026-08-31.md), [Pi publication](https://magazine.raspberrypi.com/articles/raspberry-pi-4-specs-benchmarks), [fan](https://www.adafruit.com/product/3368), [heatsink](https://www.adafruit.com/product/3082), [Adafruit mount](https://www.adafruit.com/product/1967), [mount availability/interface review](least-cost-pan-tilt-supplement-2026-08-31.md)

The sensitivity case adds a further100g above this already contingency-bearing reference; it is deliberately pessimistic, not a hidden second purchased component. Using one rather than two purchased packs does not reduce airborne mass: precisely one pack is installed in every case.

## Model and its limitations

### Source data are computed aerodynamics, not matched bench evidence

APC explicitly describes its performance files as its own analysis from prop geometry using a vortex-based computational method. The downloaded **PER3_7x4E.dat**, versionv2022-0915, simulation date2022-09-22, supplies static thrust and shaft-power rows acrossRPM. These are **manufacturer-computed propeller data**, not a test of this motor/ESC/battery/airframe. Mirroring the E results to the equivalent EP geometry is a model assumption. [APC method](https://www.apcprop.com/technical-information/performance-data/), [exact data](https://www.apcprop.com/files/PER3_7x4E.dat)

Selected static rows, sufficient to identify the numerical basis:

| RPM | Shaft powerW per prop | Thrustg per prop |
|---:|---:|---:|
|10,000|52.007|433.685|
|11,000|68.885|525.868|
|12,000|89.105|627.227|
|14,000|140.886|857.887|
|16,000|210.106|1,126.888|
|18,000|299.748|1,435.556|
|19,000|353.239|1,605.237|
|20,000|413.096|1,785.523|

These thrust conversions use9.80665m/s²; the underlying source providesnewtons. Linear interpolation is used between sourceRPM rows, retaining unrounded source values for calculation. Shaft torque is derived from power/RPM rather than the source's rounded torque column.

### Equivalent motor calculation

For a motor running at speed`n` inRPM:

```text
omega = 2*pi*n/60
Kt = 60/(2*pi*Kv)
Q = Pshaft(n)/omega
Im = Q/Kt + I0
Vm = n/Kv + Im*R
Pmotor = Vm*Im
```

Central inputs are`Kv=800RPM/V`, `R=0.1293ohm`, and **assumedI0=1A**. The interphase resistance is published; using it in this simple DC-equivalent circuit approximates brushless commutation and winding conventions. No-load current for this exact winding was not established by the accessed public source. It is deliberately exposed as an assumed loss parameter and varied below. This model does not reproduce phase waveforms, iron losses versusRPM, switching timing or thermal evolution; its precision is computational, not experimental accuracy.

At full command, solve`Vm(n)=Vpack`. For hovering, solve the APC thrust curve for one-quarter of the aircraft weight. **`Im` at partial PWM is motor-equivalent current, not average battery current.** Battery current is derived from electrical power divided by actual pack voltage, with conversion/mission corrections; do not multiply a partial-PWM phase-current estimate by four and call that battery demand.

Central mission power is`Pmission = 4*Pmotor*1.10 +18W`. The1.10 factor provisionally combines ESC/conversion and installation/approved walking-follow, stops and gentle-transition effects. It is not a measured airframe efficiency or an assumed forward-flight benefit. The18W auxiliary average is an engineering allowance for active computer/camera, sensing, video/radio, gimbal and lighting; the model also evaluates25W and30W cases. The separate **4A electrical peak auxiliary allowance** is not the18W average. Actual processor/lighting duty or servo peaks may consume more and must be measured across the complete pack path.

All thrusts assume comparable density/prop condition and roughly equal rotor loading. Gust rejection, tilted flight, asymmetric center of gravity, obstructed inflow and packaging can consume the modeled control margin. The separately stated uncertainty factors are sensitivity assumptions, not statistically validated confidence intervals.

## Full-charge current and endpoint control margin

| Screen | RPM | Four-motor currentA | Four-prop thrustg |
|---|---:|---:|---:|
|25.2V, central motor/prop inputs|18,582.9|60.986|6,137.9|
|21.0V, central|15,653.6|44.333|4,314.5|
|19.8V, central|14,804.1|40.059|3,848.7|
|19.2V, central|14,375.8|38.059|3,626.5|
|25.2V, high-current corner:Kv840, R×0.75, I0=1.5A, shaft power×1.15|19,499.7|81.923|6,781.3|
|21.0V, weak-thrust corner:Kv760,R×1.30,I0=1.5A,shaft power×1.15,thrust×0.90|14,551.0|44.118|3,345.7|
|19.8V, same weak-thrust corner|13,766.6|40.124|2,987.5|
|19.2V, same weak-thrust corner|13,370.5|38.246|2,816.4|

The current corner reaches **20.48A per motor** before auxiliary loads, below the45A per-channel MicoAir rating and the motor's published25.63A peak figure. The motor's peak figure is not a promise of indefinite operation, and neither model nor connector rating authorizes sustained maximum flight. These are constructed simultaneous steady-state points, not measured flight peaks. Motor acceleration, commutation, bus ringing and short-circuit faults are not bounded by the equivalent circuit.

The [companion power research](least-cost-power-path-2026-08-31.md) establishes the proposed **factory pack120A claim, Molicel60A/cell conditional thermal rating, QS8 lower published110A rating, INA monitor150A rating, appropriately specified wiring and full-charge voltage/suppression requirements**. The current result therefore corrects the old **known35A connector versus>113A demand mismatch** through both propulsion selection and a different complete path. **85.923A <88A <110A** leaves24.08A, about21.9%, below that110A published connector number. This is engineering headroom, not a guarantee of a safe installed connector temperature or a protective fuse setpoint. Every path element and its actual installation still has to conform.

### Coupling the battery state and maneuver demand

**The voltage rows above are stiff-source motor calculations, not independent battery-state evidence.** It is incorrect to combine a10A/cell discharge-curve voltage with full-command thrust at that same unchanged voltage: the extra current causes additional sag. This audit rejected the earlier1974.25g/19.2V draft on exactly that basis. A reserved quantity ofWh does not remove a voltage/control conflict.

Molicel gives typical cell DC impedance12.8mΩ at50% state of charge. Six series/two parallel cells give a38.4mΩ aggregate cell-only value. Use a deliberately conservative **57.6mΩ incremental pack-step resistance** for the joint screen,1.5times that typical value, intended to cover cell-state variation and the short power path provisionally. This is an engineering uncertainty assumption, **not a manufacturer-guaranteed upper bound at end of discharge**. The proper installed resistance/polarization and temperature envelope must be established later. [Molicel DC impedance](https://www.molicel.com/wp-content/uploads/Product-Data-Sheet-of-INR-21700-P50B-80122.pdf)

At a fixed discharged-capacity point, linearize around the primary graph's current and solve the motor equation simultaneously with:

```text
Vbus = Vcurve(Ah) -(4*Im +Iaux -Icurve_pack)*Rstep
Rstep =0.0576 ohm
Iaux =4A                       # full coincident auxiliary allowance
Icurve_pack =20A unloaded       # graph10A per cell, two parallel cells
Icurve_pack =24A loaded         # interpolated12A per cell
```

This is a local incremental step model anchored to a loaded curve, not a claim that`Vcurve +Icurve*Rstep` is the true open-circuit voltage. It combines the weak motor/prop corner already defined above with **all4A auxiliaries**, not just the18W average. It does not make battery resistance a protective peak-current limiter: the full-charge85.923A electrical screen deliberately takes no sag credit.

| Joint screen | Reference curve voltage/state | Full-command busV | Four-motorA | Thrustg | Thrust/weight |
|---|---:|---:|---:|---:|---:|
|Rejected1974.25g draft|19.2V at10A/cell|18.111|34.912|2,516.55|1.275, below1.35|
|**Revised1897.25g reference**|**19.6V at10A/cell**|**18.454**|**35.888**|**2,608.21**|**1.375**|
|Same endpoint,+100g|19.6V at10A/cell|18.454|35.888|2,608.21|1.306, fails|
|Same endpoint,+150g|19.6V at10A/cell|18.454|35.888|2,608.21|1.274, fails|
|**Loaded2317.25g**|**21.7V at12A/cell**|**20.424**|**42.147**|**3,170.79**|**1.368**|

Retain the **1.35 provisional engineering screening target** for both reference and loaded endpoint control; do not silently weaken it. It is not an approved product requirement or a universal safe recovery ratio. The19.6V curve-state calculation permits at most1932.01g at that ratio, leaving34.76g above the1897.25g reference. This is separate from the existing50g mass contingency already counted. If actual recovery needs more thrust authority, the aircraft needs an earlier state threshold or design revision, and its usable energy must be recalculated.

The endpoint is the accounting state **after all protected recovery energy could be expended**, not the state at which to start returning. A10A/cell curve voltage of19.6V can coexist with an18.454V transient at a different load; it is therefore not an instruction to set one raw battery-voltage parameter to19.6V. Protection must reconcile calibrated energy, load-dependent sag, cell imbalance and recovery authority. A vehicle that passes energy accounting but fails this coupled control screen still fails. No reserve, cargo target or required capability is reduced.

## Twenty useful minutes plus protected reserve

### Usable energy must stop at the same endpoint as the thrust calculation

Molicel specifies17.5Wh minimum nominal cell energy, hence **210Wh for twelve cells**;216Wh is the typical nominal value. Neither is energy deliverable to an arbitrary early landing endpoint. The manufacturer's discharge plot extends toward2.5V/cell, which this aircraft must not assume it can use. [Molicel P50B data sheetv1.1](https://www.molicel.com/wp-content/uploads/Product-Data-Sheet-of-INR-21700-P50B-80122.pdf), [factory Nexus6S2P P50B](https://nexusbatterysystems.com/products/6s2p-p50b)

The raster discharge-rate graph was extracted from the primary PDF and approximately digitized by its10A/cell curve color. Axis calibration used0–5000mAh and2.4–4.2V; voltage was integrated over dischargedAh with trapezoidal integration, then multiplied by12cells. Pixel/line-selection sensitivity gives roughly **151–153Wh to3.3V/cell(19.8V pack)**, **162–164Wh to3.2V/cell(19.2V pack)**, and **115–117Wh to3.5V/cell(21V pack)**. Treat these as graphical estimates, not precision cell measurements. The plot's temperature/test history does not guarantee every production cell or the complete factory pack.

Reproducibility: the extracted graph is665×372pixels. Pixel coordinates use a top-left origin; capacityAh=`(x−75)/100`, voltageV=`4.2−(y−23)*1.8/278`. The10A teal curve and20A olive curve were isolated by color, excluding the legend. Pixel-line selection changes integrated values by roughly1–2Wh across twelve cells. **The final calculation uses the monotonic0.25Ah control points below**, rather than treating isolated antialiasing-color outliers as physical voltage reversals. The small interval before the first observed point uses a constant initial voltage, not claimed energy from an unobserved transient.

| DischargedAh/cell |10A curveV |20A curveV |
|---:|---:|---:|
|0.00|4.012|3.896|
|0.25|3.941|3.818|
|0.50|3.902|3.779|
|0.75|3.863|3.747|
|1.00|3.812|3.701|
|1.25|3.760|3.656|
|1.50|3.714|3.611|
|1.75|3.669|3.572|
|2.00|3.624|3.527|
|2.25|3.572|3.481|
|2.50|3.520|3.429|
|2.75|3.468|3.384|
|3.00|3.417|3.339|
|3.25|3.358|3.287|
|3.50|3.287|3.222|
|3.744|3.200|3.138|

Use`12*sum((V_i+V_(i+1))/2*(Ah_(i+1)−Ah_i))` through the selected endpoint, interpolating the final partial interval. The selected10A endpoint is19.6/6=3.266667V/cell, reached at approximately3.55703Ah and **156.0509Wh** across twelve cells. Multiplying by.95 gives148.2484Wh; round down to **148Wh**. For the loaded12A estimate, interpolate voltage as`.8*V10A+.2*V20A` at equal dischargedAh, then stop at21.7/6=3.616667V/cell. This is approximate graph interpolation, not a substitute for a constant-power pack test or temperature model.

The central354.54W case is approximately9.04A/cell at19.6V under ideal current sharing, so the10A curve is a reasonable conservative **average-load screening curve** for this case. It does not bound acceleration pulses; the separate coupled step model handles that screen. The approximately5% energy allowance remains a hypothesis requiring discharge-profile validation, not a guaranteed worst case across15–30°C, aging or manufacturing variation. Higher-power sensitivity cases use lower energy allowances. The nominal cell-energy basis is not substituted for these endpoint-consistent figures.

This explicitly corrects the tempting `210Wh × .80/.85` shortcut: **168/178.5Wh cannot simply be declared usable to19.8V**. Energy below the qualified endpoint is excluded. The20-minute checkpoint must still have the full protected reserve available before that endpoint is reached.

### Reserve equation and predictions

Keep Q74 unchanged, with an initial4Wh ground/takeoff/pre-reference allowance:

```text
Erecovery_model = Pmission * 120/3600 Wh
Ereserve = max(20 Wh, 1.5*Erecovery_model)
         = max(20 Wh, 0.05*Pmission)
useful_minutes =60*(Eusable_to_qualified_endpoint -4 Wh -Ereserve)/Pmission
```

Using mission power as the120-second recovery power is a first-pass estimate, not proof that a maximum-range return/climb/descent has that average. Measured worst-case recovery plus uncertainty must validate or increase protection; it must never be reduced to force a pass.

| Case | Massg | Motor/prop/mission assumptions | UsableWh | MissionW | ReserveWh | Useful minutes |
|---|---:|---|---:|---:|---:|---:|
|Favorable sensitivity|1,897.25|I0=.5A;otherwise nominal;k1.05;aux15W|148|305.95|20.00|24.32|
|**Central**|**1,897.25**|I0=1A;nominalR/prop;k1.10;aux18W|**148**|**354.54**|**20.00**|**20.98**|
|Moderate loss case|1,897.25|I0=1.25A;R×1.15;shaftpower×1.05;k1.12;aux25W|146|401.96|20.10|18.20|
|Stacked unfavorable case|1,997.25|I0=1.5A;R×1.25;shaftpower×1.10;thrust×.95;k1.15;aux25W|144|504.67|25.23|13.64|
|Adverse stress case|2,047.25|I0=2A;R×1.40;shaftpower×1.15;thrust×.90;k1.20;aux30W|140|653.40|32.67|9.49|

The latter usable-energy figures are deliberately reduced engineering sensitivities, informed by interpolation toward the20A/cell curve as average load rises; they are not measured pack capacities. Both heavier cases also fail the provisional1.35 coupled endpoint thrust-ratio screen. Their durations are arithmetic stress results, not acceptable operating cases.

This predicts **about21 useful minutes centrally, with a meaningful downside below20**. The candidate is plausible but has little robust endurance margin. A moderate loss miss is an unresolved performance risk to address through exact matched measurements and, if needed, design improvement; do not call endurance closed or merely rename the miss “validation.” The approved requirement remains twenty.

### Concrete pass budget

With148Wh usable to the qualified endpoint state,4Wh pre-reference and the approved reserve equation:

```text
P/3 +max(20,0.05*P) <=144 Wh
P <=372 W
```

The active branch at372W has the20Wh reserve floor. The central354.540W estimate has **17.46W, about4.9%, headroom** to this practical budget. If the actual protected recovery reserve must be25Wh, the148Wh budget permits357W, leaving only2.46W above the central estimate. This is why reserve validation is independent of simply reaching twenty minutes.

Chronological check at the required20-minute mark:4Wh pre-reference plus118.18Wh useful flight leaves **25.82Wh** out of the148Wh allowance, exceeding the protected20Wh. The modeled120-second recovery consumes11.82Wh; its1.5multiple is17.73Wh, so the20Wh floor applies. The coupled endpoint screen is still checked at the state after the entire protected energy allowance could be used, rather than claiming that a comfortable earlier voltage makes a later sag problem irrelevant.

For comparison only, the abstract210Wh-nameplate80%-usable case gives427.826W as a mathematical ceiling; **that is not the chosen endpoint-consistent energy budget**. Both usable energy and the terminal control margin must support any alternative. ActualQ74 acceptance remains the approved complete mission with reserve, not compliance with a guessed average alone.

If installed power is402W with only146Wh usable, the reference failsQ74. Credible corrective work would target measured excess mount mass, prop/motor losses, inflow obstruction or auxiliary demand while retaining all features, or re-model a different factory energy pack including its mass, power-path and cost consequences. No unpriced larger-pack fallback, equipment deletion or deeper discharge is counted as solved.

## Loaded250g delivery model

The **250g cargo plus170g holder** case is2317.25g. Central modeled power is **455.59W**, reserve22.78Wh. It uses the distinct earlier **21.7V state on the interpolated12A/cell curve**, with full-command/4A auxiliary sag solved simultaneously as above. At the average mission load,455.59W/(2×21.7V) is approximately10.50A/cell, below that12A screening profile. The graph integration gives approximately **88.00Wh before additional allowance**; after5% and rounding down use **83Wh**. This produces approximately **7.40 useful minutes** plus protected recovery, not nineteen or twenty minutes.

Those minutes are a model result, **not an approved delivery duration/range or safe cargo rating**. Loaded20-minute endurance was never the requirement. A materially different actual reserve, sag, temperature, mass or holder airflow can shorten the mission further; use the same explicit energy equation and qualified loaded endpoint. The loaded case must not silently use the unloaded19.6V curve-state energy pool.

The design now has a numerical cargo mass, holder allowance, peak-path screen and endpoint-thrust target. Physical evidence must still demonstrate holder retention, balance/control and the approved recipient face-verification workflow; ordinary manual removal must remain blocked before release, and handoff occurs landed with motors stopped. The person may carry the aircraft back disarmed. Cargo/holder removal between flights must not remove permanent interfaces required in the full reference equipment budget.

## Why lower sticker-price alternatives were not silently selected

| Candidate | Finding |
|---|---|
|PreviousF1001100 +GF7040-3 +FullsendXT60H|Existing matched table yields113.88A before auxiliaries; exact factory XT60H manufacturer rating35A. Its good endurance model did not qualify that path. Historical comparison retained, not preferred.|
|XING800 +APC7x5E/EP|Same listed$2.71 and0.28oz per prop; improves low-voltage thrust, but the same high-current parameter corner predicts96.449A propulsion+4A=100.449A. Retaining the original1.25 electrical sizing factor requires125.561A: above both110A connector and120A pack figures. Do not quietly reduce the sizing margin to select it.|
|XING800 +APC7x6E/EP|The corresponding corner predicts107.918A propulsion+4A=111.918A, already above110A before the sizing factor. Not selected.|
|EMAXPro2810/950 +APC7x4E/EP|Official available950KV option$27.99, but equivalent-circuit screen at25.2V gives about22,191RPM and102A for four motors. That exceeds the exactAPC limit and lacks useful110A-path headroom before uncertainty/auxiliaries. A throttle cap was not smuggled in to make it pass.|
|BrotherHobbyAvenger2810/900 +APC7x4|Nominal full-load estimate approximately21,274RPM and88A before auxiliaries. Nominal no-load22,680RPM exceeds theAPC limit; not preferred without a materially different and explicitly qualified design.|
|BrotherHobbySE2816/810 +APC7x4|Manufacturer sheet:98.45g with leads,74.6mΩ,I0=1.36A at10V,6S. Four add149.8g versusXING800. The$22.50 listing saves$37.96, but+5%KV no-load21,432.6RPM already slightly exceeds theAPC limit, and its extra mass worsens endurance. Not selected as an equivalent drop-in.|
|EMAXMT2808/850 bargain|The low-price offer encountered was unavailable and its documented voltage context did not establish this6S design; not a current supported substitution.|
|NexusSamsung50S factory path|Cheaper pack does not inheritP50B's documented cell current capability. The conservative50A aggregate screen considered by the power agent is below the~61A nominal propulsion demand plus auxiliaries. Do not assume a temperature-conditional headline fixes it.|

Sources: [F100 matched table](https://www.ligpower.com/product/f100-fpv-motor.html), [EMAXPro2810 direct](https://shop.emax-usa.com/products/pro-series-2810-brushless-motor), [BrotherHobbyAvenger2810](https://www.brotherhobbystore.com/products/avenger-2810-motor), [SE2816 official](https://www.brotherhobby.com/se-2816-810kv-motorcw-p00219p1.html), [SE2816 manufacturer drawing/test sheet](https://ueeshop.ly200-cdn.com/u_file/UPAI/UPAI594/2406/photo/ca9fed43a5.jpg), [SE store listing](https://www.brotherhobbystore.com/collections/vs-series). These comparisons are model-based screening; a9- or10-inch manufacturer test does not become measured7-inch evidence.

The bounded higher-pitch check used [APC7x5E](https://www.apcprop.com/product/7x5e/), [7x5EP](https://www.apcprop.com/product/7x5ep/), [7x5 computed data](https://www.apcprop.com/files/PER3_7x5E.dat), [APC7x6E](https://www.apcprop.com/product/7x6e/), [7x6EP](https://www.apcprop.com/product/7x6ep/) and [7x6 computed data](https://www.apcprop.com/files/PER3_7x6E.dat). The final lighter7x4 design restores the joint model intersection while retaining the original current criterion:85.923×1.25=107.404A, below110A. The unpriced “Other connector” factory option is not counted as a resolved upgrade.

## What is settled by this design, and what still requires evidence

**Answerable now and supplied:** exact low-KV motor/prop identities; correct full-chargeRPM family limit; transparent installed mass; a factory high-current pack/path direction; approximate peak/endpoint/energy calculations; numericalQ74 pass budget; explicit loaded mass and control-margin screening; retained full feature scope. The previous generic “pack current needs checking” is replaced by a concrete matched redesign and named margin.

**Before purchase-ready status:** reconcile the companion cost/power/layout reports into one chosen revision; actual product options, stock and delivered prices; available ring/nut/mount interfaces; connector/lead and capacitor/monitor topology; source-supported regulator voltages; all necessary safety/operating constraints. The complete cost is still over the current cap. No approval of a motor candidate alone removes that conflict.

**Later physical qualification, not a demand for flight proof before planning:**

- Weigh the complete installed reference and loaded configurations, including cable lengths and the final cradle/legs; verify clearance, retention and center of gravity.
- Establish matched prop/motor thrust, power andRPM versus voltage, including the assumedKV/no-load-loss bounds. Use controlled engineering fixtures and competent safety practices; this report does not instruct a novice full-power test.
- Verify total-pack current calibration, full-charge voltage excursions, current peaks, regulator stability and component temperatures in the actual installation. Startup transients and a hot poorly cooled connector are not certified by the static model. Failure to remain within the documented path envelope blocks release and requires redesign, not merely raising the88A model budget.
- Establish usable energy and endpoint recovery authority, including battery sag/imbalance and the correct loaded/unloaded thresholds. Validate or increase theQ74 reserve from worst-case recovery evidence.
- Complete approvedQ73 commissioning/basic-flight gates before laterQ74 evaluations. ForQ74 preserve twelve walking-follow minutes, six hover/stopped minutes and two gentle-transition minutes, full active equipment, approved dry/daylight/temperature/wind/height/radius limits and every-attempt records. Require at least three successful complete evaluations over at least two days, with qualifying evidence for each released pack. A failed endurance result is not repaired by counting a shorter flight as success.
- Validate delivery separately at the approved250g target: holder, balance, landing, face-verification-controlled release and stopped-motor handoff. Do not generalize this target into a safe maximum beyond tested configurations.

## Provenance

Research base commit: `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This report and coordinated reports are uncommitted working artifacts; that commit does not contain their findings. Inputs were read from the shared checkout. Later authoritative decisions supersede any input snapshot.

| Input snapshot | SHA-256 |
|---|---|
|`CLAUDE.md`|`0FEC96250C4D0D5CB4CC62B534FDB25ABBFE2A97AB13FAAC412EC3BD89DEAE3B`|
|`docs/agents/workflow.md`|`47CC6A80D36F95BB0CE298652682D5C7C29B6C7E9804E49332900944E049B094`|
|`.scratch/biometric-guard-drone/map.md` at read|`F1C7E015B2B137456C7640DEB35FFB49DF12AC78B884F637C56C15A34650AA67`|
|`issues/10-milestone-ladder.md` at read|`0C3678EF029051EB29A86302680CB6F9324024A95503AD5BC076B245739B5176`|
|Downloaded APC `PER3_7x4E.dat`|`DA962147F34CDDEC145E8159B33C51080C6754F3443CCC4CAD281DABBF01C53C`|
|Downloaded officialSE2816 drawing/test image|`B7170D7578CF2D9048EDEA871A4B1ED9F2B6DE6A6AEA483C18880FCA7A98EFD2`|
|Downloaded Molicel P50B PDFv1.1|`867A4873B71A7C5B758BE83F8371DAF5CA5CB624675AC85B405DC227504DF20C`|

Numerical work used the unrounded APC file, linear interpolation and the displayed equations, with calculations run locally in a temporary scratch script. No production code or flight-controller parameters were written. Prices/availability are dated public-page observations, not delivered quotes. Failed/blocked source fetches were not treated as permission to bypass access controls or as evidence of product unavailability.
