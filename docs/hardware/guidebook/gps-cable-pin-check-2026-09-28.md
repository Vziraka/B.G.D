# M10-182Q GPS cable — unpowered pin check, revision 1 (September 28, 2026)

**Scope:** identify the received SEQURE M10-182Q GPS/compass, the original MicoAir743 flight controller's GPS socket, and the six-conductor cable **before either end is plugged into a board**. If the received connectors and meter results are unambiguous, this card defines the needed one-end re-pin and its post-check. It does **not** release plugging the cable into either board, USB or battery power, or configuring the GPS. Keep the aircraft battery disconnected, charger unplugged, soldering station off and propellers off. See [runbook C1](beginner-build-runbook.md).

## Why the supplied cable cannot be assumed ready

The [SEQURE M10 family product page](https://sequremall.com/products/sequre-gps-small-size-fast-positioning-racing-drone-fpv-return-qmc5883-compass) selects `M10-182Q` as the 18 × 18 mm model with a QMC5883L compass, a 3.3–5 V supply and a six-position SH1.0 connector. Its [M10-182Q board image](https://cdn.shopify.com/s/files/1/0091/9515/9588/files/9_M10-182Q.jpg) shows the **electronics/connector side**, with the printed text upright and the connector at the bottom: `GND  TX  RX  5V  SCL  SDA`, left to right. The [original MicoAir743 manual](https://micoair.cn/en/docs/flight-controller/micoair743/micoair743-flight-controller-manual) and its [manufacturer connector diagram](https://micoair.cn/api/media/file/docs/2026/07/667c0fbaa3976-8a38aec13b-20c3f71554.webp) show the **FC component side**, arrow toward the top and GPS socket at the lower-left: `GND  5V  TX3  RX3  SCL  SDA`, left to right. Those left-to-right sequences describe **boards in the pictured orientation**, not an unplugged cable seen from its wire side. A plug may appear reversed when turned over or held at the other end.

The required six electrical paths are:

| FC GPS-socket label | M10-182Q label | Why |
| --- | --- | --- |
| `GND` | `GND` | Common reference |
| `5V` | `5V` | Correct module supply |
| `TX3` | `RX` | Controller sends to GPS |
| `RX3` | `TX` | GPS sends to controller |
| `SCL` | `SCL` | Compass clock |
| `SDA` | `SDA` | Compass data |

If a cable really joined like-numbered **board positions**, FC `5V` would reach GPS `TX`, and FC `RX3` would reach GPS `5V`. That can damage hardware. This is a warning about an unverified cable, **not** a claim that the supplied cable is straight-through; only the received cable's continuity map can decide. The FC's `9V` video connector is a different six-position socket and must not be mistaken for the GPS socket.

## Step 1 — identify boards and the cable without inserting anything

1. Read the actual markings: the FC must be original `MicoAir743` (not `Lite`, `v2` or `AIO`), and the GPS must say `M10-182Q` or have the exact selected product label. If either differs, stop and report its literal text.
2. Locate the FC socket marked `GPS` on the **same face and edge** as the manufacturer diagram: with the arrow at the top, it is the leftmost of the three small sockets along the lower edge. That diagram assigns the six FC functions, which need not all be printed on the physical FC. On the M10-182Q, read the six printed function labels beside its connector. If the FC's `GPS` marking or any GPS function label is absent, obscured or differs from the linked images, stop and report **only that uncertain label/side**; a close-up of that specific label is useful if text cannot resolve it. Do not use a v2/Lite drawing for an original board.
3. Choose one loose six-wire cable whose ends appear to match the keyed six-position sockets without force. The [ordered MicoAir stack package image](https://cdn.shopify.com/s/files/1/2778/6650/files/4_fd5a756c-be9d-4c25-b67a-d1a78e91e1cb.webp?v=1730401001) includes a 20 cm six-pin GPS cable. SEQURE's own listing also describes one cable with its module; the Pyrodrone GPS listing promises only the module, so **actual received contents decide**. Put a removable `FC` tape flag near the end chosen for the FC and `GPS` near the other. Do not press either plug into a board yet.
4. Hold each plug **just outside** its intended board socket in the only keyed mating orientation, without inserting it. Map its six cavities to the function positions shown in the manufacturer drawings and the GPS's printed labels. Record which physical end/cavity aligns with `GND` at each board. If the housing can be presented in more than one apparent orientation or the tiny cavities cannot be matched confidently, stop here; the missing observation is **which outermost cable cavity aligns with the GPS's printed `GND` and the FC diagram's `GND` position when each plug is held in its keyed mating orientation**. Do not infer this from red/black wire colors or from one retailer photo.

## Step 2 — map the isolated cable with the meter

Do this only after both cavity orientations in Step 1 are certain. Keep the cable disconnected from **all** boards and supplies. Set the multimeter to continuity/low resistance and confirm its probes indicate connected when touched together and open when apart. For each of the six `FC`-end cavities, touch **accessible terminal metal only**, and find exactly one matching `GPS`-end cavity with the other probe. Use fine probe tips if available; **do not push a thick meter tip into a 1 mm housing, spread a crimp contact, scrape insulation or bridge neighboring terminals**. If metal cannot be contacted gently, stop; wire color alone is not a meter check.

Record this table using the **board-function names established in Step 1**, not cable colors:

| From FC-labeled cavity | Meter finds GPS-labeled cavity | Required result |
| --- | --- | --- |
| `GND` | ___ | `GND` |
| `5V` | ___ | `5V` |
| `TX3` | ___ | `RX` |
| `RX3` | ___ | `TX` |
| `SCL` | ___ | `SCL` |
| `SDA` | ___ | `SDA` |

Each FC position must find **one** GPS position. Recheck an unexpected result with the probes separated and without bending the terminal. Multiple beeps, changing readings, or an inaccessible terminal fail this check. A shared wire color or a plug that physically fits does not make a connection safe.

## Step 3 — re-pin only if the map is complete and wrong

If all six measured paths already match the required column, **do not re-pin**. If any path differs, make a written move plan before touching a terminal: for each current `GPS`-end cavity, name the FC function actually arriving there and its required M10-182Q destination. Keep the `FC` end unchanged. The resulting GPS-end mapping must be `GND←FC GND`, `TX←FC RX3`, `RX←FC TX3`, `5V←FC 5V`, `SCL←FC SCL`, `SDA←FC SDA`. This function mapping is authoritative; do not move terminals according to color or a presumed left-to-right plug view.

**Re-pin gate:** the two socket orientations, all six continuity paths, and the actual GPS-end housing's tiny retaining tabs must be visible and understood. [JST's SH-series reference](https://www.jst-mfg.com/product/index.php?lang=2&series=231) describes a 1 mm-pitch housing lance, but the received cable's precise housing and tab location still need inspection. If the tabs are not clear, or an appropriately fine extraction tool is unavailable, **stop without pulling a wire** and use a correctly pinned replacement cable or hands-on electronics help. A torn crimp or damaged housing is not repairable by pushing it back in. Once the agent has reviewed the recorded map and housing type, note which way one terminal's metal contact faces, then release it by lifting **its housing retention tab only just enough** with a suitable fine tool while gently withdrawing by the insulated crimp lead. Never pull against a locked tab, pull by exposed conductor, pry a board socket, or use heat. Insert the terminal in the planned GPS-end cavity with the metal contact facing the original way; it must seat and resist a **gentle** backward tug. Move one terminal at a time, with the other loose terminals kept apart. If a terminal bends, the tab no longer retains it, or the new path is unclear, stop.

Repeat **all six** isolated-cable continuity measurements after any move, not just the moved paths. Also confirm adjacent cavities are not shorted when the probes are placed on different paths. Write the final six-row table and verify it exactly matches the required column. **Even a complete meter pass does not release plugging or power**: the agent must review the actual-board identity, cavity orientation and final table before issuing the later connection/first-power step.

## Report back in text

Report (1) literal FC and GPS model markings; (2) whether the FC `GPS` socket placement and the GPS's six printed labels match the linked manufacturer images; (3) which cable end/cavity aligns with `GND` on each keyed socket; and (4) the six measured paths, or the one reason mapping stopped. A routine whole-kit photo is unnecessary. A targeted close-up is only useful if a specific board label, keyed orientation or retaining tab cannot be described. Preserve the unplugged cable and mark it **unverified** until the full table passes review.
