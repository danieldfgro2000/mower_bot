# Propulsion, reductions and brakes

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Compares the
[48 V / approximately 2 kW planetary motor (S11)](../../bom/sources.md#s11), the
[72 V / approximately 4 kW VOL-BL400C72 motor (S13)](../../bom/sources.md#s13), and the
[non-additive HPM5000B sourcing alternative](propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals).
These are candidates and screening calculations, not approved motors, ratios,
brakes, or operating limits. Exact listings are in the
[supplier register](../../bom/sources.md#source-id-lookup).
The current owner direction is controller-supported motor braking for dynamic
deceleration and a default-applied mechanical brake for stationary holding;
neither function is qualified by this comparison.

**Navigate:** [Alternatives](propulsion.md#drive-alternatives) ·
[Compatibility and duty](propulsion.md#compatibility-and-duty-limitations) ·
[Requirements](propulsion.md#specification-and-inspection-requirements) ·
[Sourcing](propulsion.md#sourcing) ·
[Interfaces](propulsion.md#interfaces-with-other-scopes) ·
[Itemized costs](propulsion.md#detailed-module-costs) |
[Chassis BOM](../../bom/chassis-bom.md#scope-and-decisions) ·
[Drive-train cost totals](../../cost-breakdown.md#02--drive-train) ·
[Ledger](../../bom/chassis-bom.csv) · [Release checklist](../../chassis-build-requirements.md) ·
[Supplier register](../../bom/sources.md#source-id-lookup) ·
[Module 02 overview](README.md)

## Drive alternatives

Both scenarios provision two independent pods. These are research and sizing
inputs, not accepted ratings or safe machine limits.

### Owner braking direction (2026-10-27)

Use the motor/controller as the dynamic service brake through regeneration or
another manufacturer-documented reverse-current braking mode. A direction
reversal command alone is not evidence of controlled braking. Use a mechanical
brake on each pod for stationary holding, applied by default when its release
power is absent. Field evidence is intended to determine whether a separate
mechanical dynamic brake is needed; a holding-only brake is not credited with
stopping a moving bot unless its rating includes that duty.

Select the motor, controller and reduction together for braking torque and
speed at the track, downhill back-driven motor speed, electrical energy
handling at high state of charge or BMS cutoff, and current/thermal limits.
Compare any integrated mechanical holding-brake option with a separate brake
assembly; if the integrated option materially raises the motor/gearbox price,
use a separate brake. No numeric price threshold has been set. The existing
DRV-003 line remains a provisional stationary-hold allowance, not a selected
brake or dynamic-stop provision.

### HPM5000B sourced alternative — not added to baseline totals

**Candidate ID:** ALT-DRV-001, an alternative to **DRV-001**, not an additional
motor fitted alongside it. Its machine-readable cost record is in the
[propulsion alternatives CSV](../../bom/propulsion-alternatives.csv). The main 129-line
ledger and its totals remain unchanged until a complete replacement drive
configuration is chosen and re-costed.

**Product and supplier:** Golden Motor **HPM5000B**, bare BLDC/PMSM motor;
**48 V air-cooled configuration requested**.
[Golden Motor Technology marketplace listing](https://goldenmotorcz.en.made-in-china.com/product/CwmnvfujhxVi/China-HPM5000B-48V-4000RPM-Brushless-DC-Motor-with-CE-Certificate.html)
([S23](../../bom/sources.md#s23)). Checked 2026-10-26; displayed price is not a delivered quote.
The page offers air/liquid cooling and several windings, so obtain confirmation
that the exact requested configuration and bare-motor scope receive this price.

**Published price:** **US$446 each for 1–9 pieces**. Both the one-motor bench
purchase and the two-motor chassis requirement use this tier; do not apply the
10-piece or 50-piece discounts.

**EUR planning cost:** Under the existing BOM basis,
`446 / 1.1188 × 1.21 = €482.36 per motor`, including a provisional 21% VAT
addition. **Two motors: €964.72** using rounded unit costs. This excludes
freight, duty, brokerage and any VAT on those charges, as well as the controller,
brake, custom planetary gearbox and mounting hardware. The planetary gearbox is
unpriced. It is a calculated public-price reference (`C`), not a landed
acquisition price or a confirmed sub-€500 delivery.

**Supplier-advertised specification:** Listing title says 48 V / 4,000 rpm;
tables claim 5 kW rated, 7.5 kW peak, 13 Nm rated and 45 Nm peak, with VEC300
named as the controller. Its description also gives 3,000–5,000 rpm.
The [manufacturer family page](https://www.goldenmotor.com/frame-bldcmotor.htm)
([S24](../../bom/sources.md#s24)) instead describes configurable 2,000–6,000 rpm,
3–7.5 kW, 40 Nm peak, approximately 11 kg air-cooled, 206 mm diameter and
126 mm length. These are conflicting/family-level claims, not a coherent
accepted torque-speed/duty specification. Do not use peak torque for climbing.

**EU fallback:** [KellyControllers.eu 48 V air-cooled HPM5000B](https://www.kellycontrollers.eu/hpm5000b-5kw-48v-leghuteses)
([S25](../../bom/sources.md#s25)) displays **€994.33**, but **out of stock, inquire**.
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
The owner's braking direction does not establish HPM5000B/controller braking
compatibility or select its separate holding brake.

### HPM5000B planetary-in-drum study

**Owner-selected study direction (2026-10-27):** Use the HPM5000B as the
provisional motor envelope, coaxial with the 350 mm outside-diameter drive drum
and extending into it as far as packaging allows. Place the motor/drive drum at
the rear of the bot, behind the front-mounted implement zone. House three
planetary stages inside the drum; hold each ring gear stationary to the pod and
connect the final carrier to the rotating drum. This fore-aft location is a
layout decision, not proof that the motor counterbalances implement loads. The
[editable CAD study](../../cad/module-01-track-pod-fit.scad) remains
orientation-neutral and shows motor/gear envelopes on that axis only. This is
not a baseline motor replacement, gearbox quote or release for manufacture.

**Motor envelope:** The manufacturer family page lists **206 mm diameter ×
126 mm length** and **11 kg air-cooled** for HPM5000B ([S24](../../bom/sources.md#s24)).
These published envelope dimensions are modeled; shaft projection, mounting
face, cooling clearances and any gearbox dimensions are not supplied. S23's
listing labels a 48 V / 4,000 rpm, 5 kW version and claims 13 Nm rated /
45 Nm peak, while S24 describes a configurable 2,000–6,000 rpm family and
40 Nm peak. There is no verified torque-speed curve for the exact 5 kW variant.

**Speed-driven ratio screen:** Temporarily treating the user-selected 350 mm
physical drum outside diameter as the effective rolling diameter, 4 km/h
requires about **60.6 rpm** at the drum. At the listing's 4,000 rpm motor
speed, that implies **65.97:1**, rounded to a 66:1 study ratio. The physical
track pitch-line diameter is unknown, so this is not a verified ground speed.
The sketch divides it into 4:1 × 4:1 × 4.125:1 fixed-ring stages:
24-tooth sun / 72-tooth ring / 24-tooth planets in each 4:1 stage, and
16-tooth sun / 50-tooth ring / 17-tooth planets in the 4.125:1 stage, with
three planets per stage. For simple fixed-ring planetary stages,
`ratio = 1 + ring teeth / sun teeth`. Tooth counts establish only the kinematic
ratio; they do not establish tooth module, face width, material, strength,
bearing life, lubrication or package clearance. The physical track pitch-line
diameter may differ from 350 mm, so the ratio and speed remain provisional.

**CAD package envelope:** The motor body uses the manufacturer-listed 206 mm
diameter × 126 mm length. In the 200 mm track-width study, the body starts at
the roller's outboard face and extends 126 mm inward. The three stage envelopes
are shown at 18 mm each, giving a nominal 180 mm motor-plus-stage stack and
20 mm remaining to the assumed roller-width boundary before the final carrier.
The carrier adds 6 mm axially, leaving 14 mm nominal for any other structures
and clearances; this is not a fit allowance. A visual-only 3 mm gear module
produces ring/sun/planet pitch diameters of 216/72/72 mm for the first two
stages and 150/48/51 mm for the last stage. To see the planets in the model,
view from the final-carrier side (negative Z); the outboard view prioritizes the
motor package. The sketch does not model actual tooth profiles, face widths,
shafts, carriers' structural sections, fixed-ring supports, bearings, seals or
assembly clearances. The 10 mm drum wall used to show its hollow interior is
also a placeholder; none of these envelopes proves the gearbox fits or carries
the required load.

**Load-case screen:** The owner's clarification is recorded in the
[width/slope screen](../../width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates):
use the plan's 300 kg normal-mass estimate for the 40° mower-only case and cap
the 450 kg loaded case at 15°. At the assumed 175 mm effective radius, gravity
alone requires about **165.5 Nm per track at 300 kg / 40°** and
**100.0 Nm per track at 450 kg / 15°**. With 66:1 and an assumed 85% total
mechanical efficiency, those cases require about **2.95 Nm** and **1.78 Nm**
at the motor respectively when running at 4,000 rpm. These screens exclude
rolling resistance, steering, acceleration, transient loads and margin; the
motor's exact continuous torque at speed and gearbox capacity remain unknown.

At 66:1, the temporary 350 mm effective-diameter assumption gives about 4 km/h
at 4,000 rpm; this does not meet the plan's separate 8 km/h general-travel or
15–20 km/h transport aspirations.
Treat 66:1 as a 4 km/h study point, not the final ratio. Resolving multiple
speed requirements, tooth geometry and gear capacity requires the exact motor
curve, confirmed track pitch geometry, a reviewed load/duty factor and detailed
gearbox design. At full advertised 5 kW output, the existing pack's listed
100 A maximum cannot be presumed adequate; at 48 V even loss-free input exceeds
104 A. Review battery/BMS, wiring, fuses, contactors and full-SOC downhill
braking against the eventual limits.

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

**Motor reference:** Volcano VOL-BL400C72; 4 kW, 2,580 rpm, 14.81 Nm, supplier
claims an **S1 continuous-duty rating**. Its page conflicts between 58.82 A and
71.17 A; the rating's test conditions are not established.
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

[↑ Back to document overview](propulsion.md#document-overview)


## Compatibility and duty limitations

The 48 V controller page conflicts between a 24–60 V supply description and a
24–72 V input table. A 51.2 V LiFePO₄ pack can charge to 58.4 V per the battery
listing; this does **not** prove adequate controller transient/regeneration
headroom. Confirm battery bus-current versus phase-current limits, Hall/encoder
interfaces, the documented dynamic-braking mode and energy path, low-speed
behavior, full-SOC downhill braking, BMS opening, and environmental packaging.
Do not treat matching nominal voltage as qualification.

The plan's torque and speed targets cannot all be demanded simultaneously from
a 2 kW motor: **80 Nm at 280 rpm is approximately 2.35 kW at the track**, before
reduction losses. Track-ground speed also depends on actual sprocket pitch
geometry/tooth count; neither example above proves 4 km/h or slope capability.
The owner-selected dynamic motor-braking approach is not a stationary hold or
an independent stop if the controller or its energy path is unavailable. The
default-applied mechanical brake is intended for stationary holding; it is not
credited for dynamic stopping unless specifically rated for it. Loss of
electrical energy must not permit uncontrolled free roll.

The owner accepts slower travel on slopes and clarified that the 450 kg loaded
case is limited to 15°, while 40° is mower-only. At the 350 mm drum's assumed
0.175 m effective radius, the
[gravity-only requirements](../../width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates)
are 165.5 Nm per track at 300 kg / 40° and 100.0 Nm at 450 kg / 15°.
The example 48 V 16:1 reduction yields about 86.6 Nm at 85% assumed efficiency,
below both cases; the 72 V 10:1 example yields about 125.9 Nm, above the
450 kg / 15° gravity-only case but below the 300 kg / 40° case. Neither has a
demonstrated load margin or qualifies either operating condition.

The battery cost difference reflects **different suppliers and qualification
levels**, not proof that 72 V itself doubles battery cost. These are complete
cost-model alternatives, **not two complete supplier-qualified packages**.

[↑ Back to document overview](propulsion.md#document-overview)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS14: Traction motor and controller

**Cost-ledger coverage:** DRV-001:DRV-002

**Required purchasing/manufacturing definition:** Exact motor/controller/gearhead
options; continuous torque-speed curve and low-speed cooling, peak duration, bus/phase
currents, control interfaces and software version; gearbox output/radial loads and duty;
controller-documented dynamic-braking mode and energy path; full-charge/transient/regen
voltage margin; braking torque/speed and thermal performance through the selected
reduction

**Receiving or first-article evidence:** Supplier compatibility statement and complete
package quote; model/nameplate match and configuration backup; instrumented
duty/thermal/fault and controlled-braking evidence; current example ratios do not
qualify 40-degree operation

### PS15: Mechanical brakes

**Cost-ledger coverage:** DRV-003:DRV-003

The current direction is a mechanical brake on each pod for stationary holding,
applied by default when release power is absent. Its dynamic-stop role is not
assumed. Field evidence is intended to decide whether an additional mechanical
dynamic brake is needed.

**Required purchasing/manufacturing definition:** Brake type and de-energized
default state, mounting location, static holding torque versus
temperature/wear, coil voltage, release monitoring and manual service release;
compare integrated and separate holding-brake options against equivalent
delivered configurations; assess drivetrain failure between brake and track.
If a selected brake is expected to stop a moving machine, define its dynamic
stop energy/duty rating.

**Receiving or first-article evidence:** Documented stationary holding at actual
ratio/radius/load and evidence that the brake applies when release power is lost;
no regenerative-only parking hold. Record whether a mechanical dynamic brake is
required based on controlled test evidence and fault analysis. Label any
holding-only brake with its stopping limitation.

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
from 72 V external reduction; ratio/load ratings for propulsion and motor braking,
including downhill back-driven speed and brake torque at the track

**Receiving or first-article evidence:** Parts and centre-distance/chain-alignment
match; recorded tension; calculated torque/speed from verified motor and reduction
data; logged current, voltage, speed, and thermal observations during reviewed
braking checks; kit contents reconcile N/A separate-purchase rows; external
reduction quantities apply only to 72 V. Direct torque measurement is not in the
current test method, so torque capability remains unmeasured and unqualified.

[↑ Back to document overview](propulsion.md#document-overview)


## Sourcing

[S03](../../bom/sources.md#s03) · [S04](../../bom/sources.md#s04) · [S05](../../bom/sources.md#s05) · [S07](../../bom/sources.md#s07) · [S11](../../bom/sources.md#s11) · [S12](../../bom/sources.md#s12) · [S13](../../bom/sources.md#s13) · [S14](../../bom/sources.md#s14) · [S15](../../bom/sources.md#s15) · [S23](../../bom/sources.md#s23) · [S24](../../bom/sources.md#s24) · [S25](../../bom/sources.md#s25).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](propulsion.md#document-overview)


## Interfaces with other scopes

- [Tracks and running gear](../01-structure-and-running-gear/running-gear.md)
- [Batteries, enclosures and charging](../04-battery-and-charging/batteries.md)
- [Power distribution and enclosures](../05-power-cables-and-electronics/power-distribution.md)
- [Safety controls and sensors](../06-safety-controls-and-sensors/safety-controls.md)

[↑ Back to document overview](propulsion.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: motors

**02.01 Traction motors and included planetary where applicable**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-001 - Traction motor with scenario-specific gearbox basis (2 each) | €2,071.88 / C | €1,300.00 / A |
| **Module subtotal** | €2,071.88 | €1,300.00 |

### Cost: motor-controllers

**02.02 Traction motor controllers**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-002 - Matched motor controller (2 each) | €1,023.24 / C | €1,000.00 / A |
| **Module subtotal** | €1,023.24 | €1,000.00 |

### Cost: brakes

**02.03 Mechanical holding brakes**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-003 - Mechanical holding brake provision (2 each) | €446.54 / C | €500.00 / A |
| **Module subtotal** | €446.54 | €500.00 |

### Cost: output-support

**02.04 Output hubs shafts and bearings**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| DRV-004 - Output shaft couplings or mounting hubs (2 each) | €60.00 / A |
| DRV-005 - External output shaft stock (2 each) | €70.00 / A |
| DRV-006 - Output shaft bearing blocks (4 each) | €80.00 / A |
| **Module subtotal** | €210.00 |

### Cost: chain-reduction

**02.05 External chain reduction and keys**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| DRV-007 - Reduction sprockets for two-stage 72 V drive (8 each) | N/A / I | €160.00 / A |
| DRV-008 - Reduction chain (6 m) | N/A / I | €120.00 / A |
| DRV-009 - Intermediate reduction shafts (2 each) | N/A / I | €70.00 / A |
| DRV-010 - Intermediate reduction bearings (4 each) | N/A / I | €80.00 / A |
| DRV-011 - Reduction chain tensioners (2 each) | N/A / I | €50.00 / A |
| DRV-012 - Keys bushes and reduction fasteners (2 pod set) | €30.00 / A | Same as 48 V |
| **Module subtotal** | €30.00 | €510.00 |

| Scope total | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **All items owned by this scope** | €3,781.66 | €3,520.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](propulsion.md#document-overview)
