# Propulsion, reductions and brakes

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**On this page:** [Drive alternatives](propulsion.md#drive-alternatives) ·
[Itemized costs](propulsion.md#detailed-module-costs) ·
[Requirements](propulsion.md#specification-and-inspection-requirements) ·
[Sourcing](propulsion.md#sourcing) · [Interfaces](propulsion.md#interfaces-with-other-scopes)

**BOM documents:** [BOM overview](../chassis-bom.md) ·
[Drive train totals](../cost-breakdown.md#drive-train)

**Related records:** [Cost ledger](../chassis-bom.csv) ·
[Build checklist](../chassis-build-requirements.md) ·
[Supplier register](sources.md#source-register)

Traction motor/controller packages, output support, transmission and mechanical braking.

## Drive alternatives

Both scenarios provision two independent pods. These are research and sizing
inputs, not accepted ratings or safe machine limits.

### HPM5000B sourced alternative — not added to baseline totals

**Candidate ID:** ALT-DRV-001, an alternative to **DRV-001**, not an additional
motor fitted alongside it. Its machine-readable cost record is in the
[propulsion alternatives CSV](propulsion-alternatives.csv). The main 129-line
ledger and its totals remain unchanged until a complete replacement drive
configuration is chosen and re-costed.

**Product and supplier:** Golden Motor **HPM5000B**, bare BLDC/PMSM motor;
**48 V air-cooled configuration requested**.
[Golden Motor Technology marketplace listing](https://goldenmotorcz.en.made-in-china.com/product/CwmnvfujhxVi/China-HPM5000B-48V-4000RPM-Brushless-DC-Motor-with-CE-Certificate.html)
([S23](sources.md#s23)). Checked 2026-10-26; displayed price is not a delivered quote.
The page offers air/liquid cooling and several windings, so obtain confirmation
that the exact requested configuration and bare-motor scope receive this price.

**Published price:** **US$446 each for 1–9 pieces**. Both the one-motor bench
purchase and the two-motor chassis requirement use this tier; do not apply the
10-piece or 50-piece discounts.

**EUR planning cost:** Under the existing BOM basis,
`446 / 1.1188 × 1.21 = €482.36 per motor`, including a provisional 21% VAT
addition. **Two motors: €964.72** using rounded unit costs. This excludes
freight, duty, brokerage and any VAT on those charges, as well as the controller,
brake, chain reduction and mounting hardware. It is a calculated public-price
reference (`C`), not a landed acquisition price or a confirmed sub-€500 delivery.

**Supplier-advertised specification:** Listing title says 48 V / 4,000 rpm;
tables claim 5 kW rated, 7.5 kW peak, 13 Nm rated and 45 Nm peak, with VEC300
named as the controller. Its description also gives 3,000–5,000 rpm.
The [manufacturer family page](https://www.goldenmotor.com/frame-bldcmotor.htm)
([S24](sources.md#s24)) instead describes configurable 2,000–6,000 rpm,
3–7.5 kW, 40 Nm peak, approximately 11 kg air-cooled, 206 mm diameter and
126 mm length. These are conflicting/family-level claims, not a coherent
accepted torque-speed/duty specification. Do not use peak torque for climbing.

**EU fallback:** [KellyControllers.eu 48 V air-cooled HPM5000B](https://www.kellycontrollers.eu/hpm5000b-5kw-48v-leghuteses)
([S25](sources.md#s25)) displays **€994.33**, but **out of stock, inquire**.
Its displayed €28.19 shipping fee is not confirmed for Romania; VAT treatment
also needs confirmation. This is a sourcing fallback, not the €482.36 basis.
The existing HPM5000A-72 reference is a different model, not an interchangeable B.

**Integration hold:** This is a larger advertised power class than the retained
approximately 2 kW-per-drive target; adding a candidate does not authorize
increasing machine power. Determine whether it can meet the intended duty with
reviewed current/thermal limits and a matched controller. S12's BD100
recommendation and S11's optional brake apply to the former planetary motor,
not to this HPM5000B. A VEC300 mention does not establish its price, exact
voltage/current settings, control interfaces or safe stopping behavior.

**Two-stage chain direction:** The owner prefers a bare motor and two guarded
chain stages over the expensive planetary package. This candidate fits that
layout concept but supplies **no gearbox**. Before substituting it into the
main 48 V column, price DRV-007–011 rather than leaving them N/A, reselect the
controller/brake and review machining, shaft radial loads, guards and cooling.
Recalculate ratios from the exact motor curve and actual drive pitch radius;
do not carry over either the former 16:1 example or the earlier hypothetical
2 kW / 3,000 rpm screen. A larger motor does not qualify traction or 40° travel.
At full advertised 5 kW output, the existing pack's listed 100 A maximum cannot
be presumed adequate: at 48 V even loss-free electrical input exceeds 104 A.
Review battery/BMS, wiring, fuses, contactors and full-SOC downhill braking
against the chosen limits; no safety provision is removed by the lower price.

### 48 V / approximately 2 kW per drive

**Motor reference:** BLDC-GEAR-P2000 / D110BLD2000-48A-30S; 2 kW, 3,000 rpm, 6.37 Nm
motor-shaft torque, listed 52.08 A; 16:1 planetary option.
[S11](https://www.bldc.com/2000w-planetary-gear-motor)

**Motor cost basis:** US$957.86 each including base planetary provision; `957.86 /
1.1188 × 1.21` = **€1,035.94**. Obtain the exact 16:1 configuration quote and gearbox
output ratings.

**Controller cost basis:** Supplier recommends BD100; controller page SKU C100,
US$473.06 → **€511.62** with the above assumptions. Listed 75 A, closed-loop speed;
torque loop is described as open-loop.
[S12](https://www.bldc.com/24v-60v-brushless-dc-motor-controller)

**Reduction screening:** At 16:1 and an **assumed** overall 85% mechanical efficiency:
approximately 86.6 Nm and 187.5 rpm at rated motor speed. Gearbox output torque, peak
load, radial load, and skid-steer duty must be documented.

**Holding/stopping:** Optional 24 V motor brake lists US$206.44 → **€223.27**.
Spring-applied state, holding torque, and stopping duty are unconfirmed.

**Two motors + two controllers + two packs only:** **€5,563.28** including the
conditional Elker tax reserve; excludes brakes and all other materials.

### 72 V / approximately 4 kW per drive

**Motor reference:** Volcano VOL-BL400C72; 4 kW, 2,580 rpm, 14.81 Nm, S1 claimed. Its
page conflicts between 58.82 A and 71.17 A.
[S13](https://www.volcanomotors.com/product/251mm-72v-4kw-hall-sensor-bldc-motor-with-controller/)

**Motor cost basis:** **€650 each allowance**; no Volcano public quote. A different 5 kW
72 V HPM5000A-72 lists €630.48 including German 19% VAT
[S15](https://www.dold-mechatronik.de/BLDC-Motor-Brushless-DC-Motor-5kW-72V-Luftgeguehlt-HPM5000A-72).
This is a price-class proxy, not a substitute motor or compatibility claim.

**Controller cost basis:** **€500 each allowance** for a matched controller. EZ-A72500
lists €451.98 including German 19% VAT
[S14](https://www.dold-mechatronik.de/EZ-Controller-fuer-5kW-72V-Motor-EZ-A72500), but
is **not confirmed matched to Volcano**.

**Reduction screening:** At an illustrative 10:1 and the same **assumed** 85%:
approximately 125.9 Nm and 258 rpm. Two-stage chain components are separately allowed in
DRV-007–011; not a released ratio or chain design.

**Holding/stopping:** **€250 per brake allowance**; no selected SKU or validated
stopping/holding performance.

**Two motors + two controllers + two packs only:** **€7,198.48**, predominantly
allowances; excludes reductions, brakes, and all other materials.

## Compatibility and duty limitations

The 48 V controller page conflicts between a 24–60 V supply description and a
24–72 V input table. A 51.2 V LiFePO₄ pack can charge to 58.4 V per the battery
listing; this does **not** prove adequate controller transient/regeneration
headroom. Confirm battery bus-current versus phase-current limits, Hall/encoder
interfaces, reverse, low-speed behavior, full-SOC downhill braking, BMS opening,
and environmental packaging. Do not treat matching nominal voltage as qualification.

The plan's torque and speed targets cannot all be demanded simultaneously from
a 2 kW motor: **80 Nm at 280 rpm is approximately 2.35 kW at the track**, before
reduction losses. Track-ground speed also depends on actual sprocket pitch
geometry/tooth count; neither example above proves 4 km/h or slope capability.
Regeneration and opening contactors are not substitutes for a qualified
stopping/holding solution. Loss of electrical energy must not permit free roll.

The owner accepts slower travel on slopes, including the aspirational 40°
uphill/downhill and cross-slope site cases. At the illustrative 0.10 m drive
radius, the [gravity-only requirements](../width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates)
are 94.6 Nm per track at 300 kg and 141.9 Nm at 450 kg. The example 48 V
16:1 reduction is below both; the example 72 V 10:1 is below the loaded case,
even before resistance or reserve. These ratios remain costing/screening
examples, not viable selections established for that duty. A higher reduction
may help torque at lower speed only within documented gearbox, shaft, track,
motor/controller, and thermal ratings; quote and re-cost the reviewed solution.

The battery cost difference reflects **different suppliers and qualification
levels**, not proof that 72 V itself doubles battery cost. These are complete
cost-model alternatives, **not two complete supplier-qualified packages**.

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: motors

**Traction motors and included planetary where applicable**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-001 - Traction motor with scenario-specific gearbox basis (2 each) | €2,071.88 / C | €1,300.00 / A |
| **Module subtotal** | €2,071.88 | €1,300.00 |

### Cost: motor-controllers

**Traction motor controllers**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-002 - Matched motor controller (2 each) | €1,023.24 / C | €1,000.00 / A |
| **Module subtotal** | €1,023.24 | €1,000.00 |

### Cost: brakes

**Mechanical holding brakes**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-003 - Mechanical holding brake provision (2 each) | €446.54 / C | €500.00 / A |
| **Module subtotal** | €446.54 | €500.00 |

### Cost: output-support

**Output hubs shafts and bearings**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-004 - Output shaft couplings or mounting hubs (2 each) | €60.00 / A | €60.00 / A |
| DRV-005 - External output shaft stock (2 each) | €70.00 / A | €70.00 / A |
| DRV-006 - Output shaft bearing blocks (4 each) | €80.00 / A | €80.00 / A |
| **Module subtotal** | €210.00 | €210.00 |

### Cost: chain-reduction

**External chain reduction and keys**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-007 - Reduction sprockets for two-stage 72 V drive (8 each) | N/A / I | €160.00 / A |
| DRV-008 - Reduction chain (6 m) | N/A / I | €120.00 / A |
| DRV-009 - Intermediate reduction shafts (2 each) | N/A / I | €70.00 / A |
| DRV-010 - Intermediate reduction bearings (4 each) | N/A / I | €80.00 / A |
| DRV-011 - Reduction chain tensioners (2 each) | N/A / I | €50.00 / A |
| DRV-012 - Keys bushes and reduction fasteners (2 pod set) | €30.00 / A | €30.00 / A |
| **Module subtotal** | €30.00 | €510.00 |

| Scope total | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **All items owned by this scope** | €3,781.66 | €3,520.00 |
<!-- END GENERATED: details -->

## Sourcing

[S03](sources.md#s03) · [S04](sources.md#s04) · [S05](sources.md#s05) · [S07](sources.md#s07) · [S11](sources.md#s11) · [S12](sources.md#s12) · [S13](sources.md#s13) · [S14](sources.md#s14) · [S15](sources.md#s15) · [S23](sources.md#s23) · [S24](sources.md#s24) · [S25](sources.md#s25).

Catalog links and price proxies are not approved suppliers or delivered quotes.

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS14: Traction motor and controller

**Cost-ledger coverage:** DRV-001:DRV-002

**Required purchasing/manufacturing definition:** Exact motor/controller/gearhead
options; continuous torque-speed curve and low-speed cooling, peak duration, bus/phase
currents, control interfaces and software version; gearbox output/radial loads and duty;
full-charge/transient/regen voltage margin

**Receiving or first-article evidence:** Supplier compatibility statement and complete
package quote; model/nameplate match and configuration backup; instrumented
duty/thermal/fault evidence; current example ratios do not qualify 40-degree operation

### PS15: Mechanical brakes

**Cost-ledger coverage:** DRV-003:DRV-003

**Required purchasing/manufacturing definition:** Brake type and default state, mounting
location, static holding torque versus temperature/wear, dynamic stop energy/duty if
applicable, coil voltage, release monitoring and manual service release; assess
drivetrain failure between brake and track

**Receiving or first-article evidence:** Documented holding/stopping design at actual
ratio/radius/load, full-SOC and power-loss cases; no regenerative-only parking hold;
label restrictions if holding-only brake

### PS16: Output shafts and bearings

**Cost-ledger coverage:** DRV-004:DRV-006

**Required purchasing/manufacturing definition:** Supported sprocket shaft drawing,
material, fits, key/hub/coupling, bearing loads/life and retention; avoid track side
load on an unqualified gearhead

**Receiving or first-article evidence:** Material/fit/runout/alignment records, bearing
identity and fastening evidence; loaded performance per reviewed test plan

### PS17: Reduction and transmission hardware

**Cost-ledger coverage:** DRV-007:DRV-012

**Required purchasing/manufacturing definition:** Released ratio/tooth counts, chain
standard/size/length, lubrication and service factor, shaft/key/bearing drawings,
tensioner range and guard interfaces; 48 V included components identified separately
from 72 V external reduction

**Receiving or first-article evidence:** Parts and centre-distance/chain-alignment
match; recorded tension; torque/speed/thermal confirmation; kit contents reconcile
N/A separate-purchase rows; external reduction quantities apply only to 72 V

## Interfaces with other scopes

- [Tracks and running gear](running-gear.md)
- [Batteries, enclosures and charging](batteries.md)
- [Electronics, power distribution and safety](electronics.md)
