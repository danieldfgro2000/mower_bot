# Propulsion, reductions and brakes

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** The HPM5000B is the current packaging-study motor, not an installed
or approved selection. The estimate costs the 48 V planetary baseline;
other drive candidates are non-additive. Pick a part below to inspect its price, data, and
connection to the track.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Fit / next component |
| --- | --- | --- | --- |
| [Golden Motor HPM5000B](propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals) | Motor envelope used in the in-drum study; excluded from baseline totals | [Bare-motor price](propulsion.md#hpm5000b-purchase-scope-and-price) · [Supplier specifications](propulsion.md#hpm5000b-ratings-and-sourcing-limits) | [Motor-to-track mounting](propulsion.md#motor-to-track-mounting) |
| [BLDC-GEAR-P2000 / D110BLD2000](propulsion.md#48-v--approximately-2-kw-per-drive) | Costed 48 V / 2 kW planetary scenario | [Motor, controller and brake prices/specs](propulsion.md#48-v--approximately-2-kw-per-drive) | [Output shaft and bearings](propulsion.md#ps16-output-shafts-and-bearings) |
| [Motor controller](propulsion.md#ps14-traction-motor-and-controller) | Must match the chosen motor; the HPM5000B controller is not priced here | [Baseline controller costs](propulsion.md#0202-traction-motor-controllers) · [Compatibility](propulsion.md#compatibility-and-duty-limitations) | [Battery/BMS](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) · [Power wiring](../05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness) |
| [Reduction, drive hub and bearings](propulsion.md#motor-to-track-mounting) | Custom in-drum study differs from costed planetary/chain hardware | [Baseline hardware costs](propulsion.md#0204-output-hubs-shafts-and-bearings) · [Reduction data](propulsion.md#ps17-reduction-and-transmission-hardware) | [Track engagement](../01-structure-and-running-gear/running-gear.md#drive-drum-study) · [Mounting plates](../01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) |
| [Mechanical holding brake](propulsion.md#ps15-mechanical-brakes) | Default-applied stationary hold; exact brake not selected | [Brake costs](propulsion.md#0203-mechanical-holding-brakes) · [Brake requirements](propulsion.md#ps15-mechanical-brakes) | [Independent stop](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |

**Further detail:** [Drive studies](propulsion.md#drive-alternatives) ·
[Mounting interfaces](propulsion.md#motor-to-track-mounting) ·
[Compatibility and duty](propulsion.md#compatibility-and-duty-limitations) ·
[Release requirements](propulsion.md#specification-and-inspection-requirements) ·
[Sourcing](propulsion.md#sourcing) ·
[Interfaces](propulsion.md#interfaces-with-other-scopes) ·
[Itemized costs](propulsion.md#detailed-module-costs)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[Module 02 overview](README.md)

## Drive alternatives

The active 48 V baseline provisions two independent pods. Candidate drive
alternatives remain research inputs, not accepted ratings or safe machine limits.

The [part selector](propulsion.md#parts-at-a-glance) separates the three motor
choices. The [in-drum reduction study](propulsion.md#hpm5000b-planetary-in-drum-study)
and [braking direction](propulsion.md#owner-braking-direction-2026-10-27) describe
unqualified concepts, not additional purchased assemblies.

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
[mechanical brake allowance (DRV-003)](propulsion.md#0203-mechanical-holding-brakes) remains a
provisional stationary-hold allowance, not a selected brake or dynamic-stop
provision. See [brake qualification](propulsion.md#ps15-mechanical-brakes) and
[independent stopping](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

### HPM5000B sourced alternative — not added to baseline totals

**Inspect this motor:** [Price](propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Specifications](propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Mounting to the track](propulsion.md#motor-to-track-mounting) ·
[Controller and integration limits](propulsion.md#hpm5000b-integration-hold).

**Candidate ID:** ALT-DRV-001, an alternative to **DRV-001**, not an additional
motor fitted alongside it. Its machine-readable cost record is in the
[propulsion alternatives CSV](../../bom/propulsion-alternatives.csv). The baseline
ledger and its totals remain unchanged until a complete replacement drive
configuration is chosen and re-costed.

#### HPM5000B purchase scope and price

**Product and supplier:** Golden Motor **HPM5000B**, bare BLDC/PMSM motor;
**48 V air-cooled configuration requested**.
[Golden Motor Technology marketplace listing](https://goldenmotorcz.en.made-in-china.com/product/CwmnvfujhxVi/China-HPM5000B-48V-4000RPM-Brushless-DC-Motor-with-CE-Certificate.html)
([marketplace evidence, S23](../../bom/sources.md#s23-golden-motor-hpm5000b-marketplace-price)). Checked 2026-10-26;
displayed price is not a delivered quote.
The page offers air/liquid cooling and several windings, so obtain confirmation
that the exact requested configuration and bare-motor scope receive this price.

| Purchase question | Current reference |
| --- | --- |
| One bare motor | **US$446 / €482.36** planning cost, using the published 1–9 piece tier |
| Two motors for the chassis | **€964.72**, using rounded unit costs; not added to baseline totals |
| Controller, brake, reduction and mounts | Excluded from this motor price; the custom planetary gearbox remains **unpriced** |
| Delivery and taxes | Excludes freight, duty, brokerage and VAT on those charges |

The EUR calculation is `446 / 1.1188 × 1.21`, including a provisional 21% VAT
addition. Both bench and chassis quantities use the 1–9 tier, not the 10- or
50-piece discounts. This is a calculated public-price reference (`C`), not a
landed quote or a confirmed sub-€500 delivery.

**Continue with this motor:** [Technical specifications](propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[How it connects to the track](propulsion.md#motor-to-track-mounting).

#### HPM5000B ratings and sourcing limits

| Attribute | Recorded supplier claim | Qualification limit |
| --- | --- | --- |
| Voltage and speed | Marketplace title: **48 V / 4,000 rpm**; description: **3,000–5,000 rpm**. Manufacturer family: configurable **2,000–6,000 rpm** | Exact winding and operating point unconfirmed |
| Power | Marketplace: **5 kW rated / 7.5 kW peak**. Manufacturer family: **3–7.5 kW** | Family range is not a continuous rating for the requested variant |
| Torque | Marketplace: **13 Nm rated / 45 Nm peak**. Manufacturer family: **40 Nm peak** | Claims conflict; no accepted continuous torque-speed curve |
| Motor envelope | Manufacturer family: **206 mm diameter × 126 mm length**, approximately **11 kg air-cooled** | Body envelope only; shaft projection, mounting face and cooling clearance unconfirmed |
| Controller | Marketplace names **VEC300** | Mention only, not a qualified match, price or configuration |

Evidence: [marketplace record](../../bom/sources.md#s23-golden-motor-hpm5000b-marketplace-price) ·
[manufacturer family page](https://www.goldenmotor.com/frame-bldcmotor.htm) ·
[recorded family limitations](../../bom/sources.md#s24-golden-motor-hpm5000b-family-specification).
These claims do not form an accepted duty specification. Do not use peak
torque for climbing.

**EU fallback:** [KellyControllers.eu 48 V air-cooled HPM5000B](https://www.kellycontrollers.eu/hpm5000b-5kw-48v-leghuteses)
([EU retail evidence, S25](../../bom/sources.md#s25-kellycontrollerseu-hpm5000b-fallback)) displays **€994.33**, but **out of stock, inquire**.
Its displayed €28.19 shipping fee is not confirmed for Romania; VAT treatment
also needs confirmation. This is a sourcing fallback, not the €482.36 basis.
The [HPM5000A-72 reference](../../bom/sources.md#s15-hpm5000a-72-motor-price-proxy) is a different model,
not an interchangeable B.

**Continue with this motor:** [Mounting and track interfaces](propulsion.md#motor-to-track-mounting) ·
[Gear ratio](propulsion.md#speed-and-ratio-screen) ·
[Price and included scope](propulsion.md#hpm5000b-purchase-scope-and-price).

#### HPM5000B integration hold

This is a larger advertised power class than the retained
approximately 2 kW-per-drive target; adding a candidate does not authorize
increasing machine power. Determine whether it can meet the intended duty with
reviewed current/thermal limits and a matched controller. The
[BD100 recommendation](../../bom/sources.md#s12-bldc-bd100c100-controller) and
[planetary motor's optional brake](../../bom/sources.md#s11-bldc-2-kw-planetary-motor) apply to the former planetary motor,
not to this HPM5000B. A VEC300 mention does not establish its price, exact
voltage/current settings, control interfaces or safe stopping behavior.
The owner's braking direction does not establish HPM5000B/controller braking
compatibility or select its separate holding brake.

### HPM5000B planetary-in-drum study

**Study only:** the motor is priced separately; the custom gearbox is not.
Follow [motor-to-track mounting](propulsion.md#motor-to-track-mounting) for what
is fixed, what rotates, and which attachment details are still missing.

**Detail:** [Motor and drum layout](propulsion.md#motor-and-drum-layout) ·
[Speed and ratio screen](propulsion.md#speed-and-ratio-screen) ·
[CAD package envelope](propulsion.md#cad-package-envelope) ·
[Load cases and performance limits](propulsion.md#load-cases-and-performance-limits).

#### Speed and ratio screen

Temporarily treating the user-selected 350 mm
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

#### CAD package envelope

The motor body uses the manufacturer-listed 206 mm
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

#### Load cases and performance limits

The owner's clarification is recorded in the
[width/slope screen](../../width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates):
use the plan's 300 kg normal-mass estimate for the 40° mower-only case and cap
the 450 kg combined bot-and-trailer case at 15°. The latter is a 300 kg bot
plus 150 kg loaded trailer, not 450 kg supported on the tracks; the gravity
screen assumes both vehicles occupy the same grade. At the assumed 175 mm
effective radius, gravity
alone requires about **165.5 Nm per track at 300 kg / 40°** and
**100.0 Nm per track at 450 kg / 15°**. With 66:1 and an assumed 85% total
mechanical efficiency, those cases require about **2.95 Nm** and **1.78 Nm**
at the motor respectively; the gravity-only torque demand does not fall with
travel speed. The requested 1 km/h mower-only steep-case study would correspond
to approximately 1,000 motor rpm with this assumed ratio and diameter, not
the original 4,000 rpm / 4 km/h point. These screens exclude
rolling resistance, steering, acceleration, transient loads and margin; the
motor's exact continuous torque at speed and gearbox capacity remain unknown.

At 66:1, the temporary 350 mm effective-diameter assumption gives about 4 km/h
at 4,000 rpm, matching the owner's requested **4 km/h maximum V1 travel study
point**. The earlier 8 km/h and 15–20 km/h aspirations are no longer V1
requirements. This kinematic match does not establish duty or qualification.
Treat 66:1 as a study ratio, not the final selection. Resolving the 1 km/h and
4 km/h operating points, tooth geometry and gear capacity requires the exact motor
curve, confirmed track pitch geometry, a reviewed load/duty factor and detailed
gearbox design. At full advertised 5 kW output, even loss-free input at 48 V
exceeds 104 A. The new budget pack's advertised maximum current does not
establish continuous or regenerative capability. Review battery/BMS, wiring,
fuses, contactors and full-SOC downhill
braking against the eventual limits.

### 48 V / approximately 2 kW per drive

**Inspect this package:** [Cumulative motor costs](propulsion.md#0201-traction-motors-and-included-planetary-where-applicable) ·
[Mounting and output support](propulsion.md#motor-to-track-mounting) ·
[Matched battery scenario](../04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive).

| Item | Planning cost per unit | Supplier data / limit |
| --- | --- | --- |
| [BLDC-GEAR-P2000 / D110BLD2000-48A-30S](../../bom/sources.md#s11-bldc-2-kw-planetary-motor) | **€1,035.94** from US$957.86, including base planetary provision | 2 kW, 3,000 rpm, 6.37 Nm motor-shaft torque, listed 52.08 A; 16:1 option needs exact quote and gearbox output ratings |
| [BD100 / page SKU C100 controller](../../bom/sources.md#s12-bldc-bd100c100-controller) | **€511.62** from US$473.06 | Supplier-recommended; listed 75 A and closed-loop speed, but torque loop described as open-loop |
| Optional motor brake | **€223.27** from US$206.44 | 24 V; spring-applied state, holding torque and stopping duty unconfirmed |

EUR references use `USD / 1.1188 × 1.21`; they are not delivered package quotes.

**Reduction screening:** At 16:1 and an **assumed** overall 85% mechanical efficiency:
approximately 86.6 Nm and 187.5 rpm at rated motor speed. Gearbox output torque, peak
load, radial load, and skid-steer duty must be documented.

**Two motors + two controllers + two pack/charger bundles only:** **€5,152.10** using the
[current battery tax basis](../../bom/chassis-bom.md#estimate-rules);
excludes brakes and all other materials. Pack assumptions are in the
[48 V battery scenario](../04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive).

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)

## Motor-to-track mounting

**What exists:** an HPM5000B coaxial in-drum layout study, not a mounting drawing.
There is no approved motor bolt pattern, bracket, shaft fit, bearing arrangement,
or track-engagement profile in this package.

**Follow the drive:** [Motor data](propulsion.md#hpm5000b-ratings-and-sourcing-limits)
→ [three planetary stages](propulsion.md#speed-and-ratio-screen)
→ [final carrier and drum envelope](propulsion.md#cad-package-envelope)
→ [track engagement](../01-structure-and-running-gear/running-gear.md#drive-drum-study).

| Attachment or load path | What the study defines | Open the next detail |
| --- | --- | --- |
| Motor housing to pod structure | Motor body coaxial with the drum; attachment face, bracket and cooling clearance are not defined | [Motor and reducer mounting plates](../01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) |
| Motor shaft through reduction to drum | Three planetary stages; final carrier drives the drum | [Ratio and tooth-count study](propulsion.md#speed-and-ratio-screen) · [Carrier/package envelope](propulsion.md#cad-package-envelope) |
| Stationary ring gears to pod | Rings remain fixed while the carrier/drum rotates; supports and reaction-load attachments are not designed | [Frame definition](../01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments) |
| Drum to track | 350 mm physical drum OD is a study input, not confirmed track pitch geometry | [Drum/sprocket engagement](../01-structure-and-running-gear/running-gear.md#drive-drum-study) · [Track profile](../01-structure-and-running-gear/running-gear.md#ps01-rubber-tracks) |
| Track side loads to structure | Shaft, bearing and retention design must carry the actual loads; gearhead suitability is not assumed | [Output shafts and bearings](propulsion.md#ps16-output-shafts-and-bearings) |

The costed **48 V planetary** package needs its own motor/gearhead mounting
drawings and supported output interfaces. Do not transfer the HPM5000B
envelope or custom gearbox to that package.
Its [hub/shaft/bearing allowances](propulsion.md#0204-output-hubs-shafts-and-bearings)
and [mounting-plate stock](../01-structure-and-running-gear/frame.md#0104-frame-stock-and-mounting-plates)
do not price or qualify a completed custom in-drum assembly.

### Motor and drum layout

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

The [published motor body](propulsion.md#hpm5000b-ratings-and-sourcing-limits)
is modeled at 206 mm diameter × 126 mm length and 11 kg air-cooled. Shaft
projection, mounting face, cooling clearance and actual gearbox dimensions
are not supplied. See the [package envelope](propulsion.md#cad-package-envelope)
for the placeholder stage, carrier, and drum dimensions; none establishes fit.

**Continue:** [Motor price](propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Frame-side mounting](../01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) ·
[Track-side fit](../01-structure-and-running-gear/running-gear.md#drive-drum-study) ·
[Pod/battery clearance](../../width-and-slope-sizing.md#provisional-battery-clearance).

[↑ Back to parts](propulsion.md#parts-at-a-glance)


## Compatibility and duty limitations

The 48 V controller page conflicts between a 24–60 V supply description and a
24–72 V input table. A 16-series LiFePO4 pack may use up to 58.4 V charging,
but the selected pack's exact full-charge voltage must be confirmed; do not
copy the former pack's limits. This does **not** prove adequate controller transient/regeneration
headroom. Confirm battery bus-current versus phase-current limits, Hall/encoder
interfaces, the documented dynamic-braking mode and energy path, low-speed
behavior, full-SOC downhill braking, BMS opening, and environmental packaging.
Do not treat matching nominal voltage as qualification.

The earlier torque and speed illustrations cannot all be demanded simultaneously from
a 2 kW motor: **80 Nm at 280 rpm is approximately 2.35 kW at the track**, before
reduction losses. Track-ground speed also depends on actual sprocket pitch
geometry/tooth count; neither example above proves 4 km/h or slope capability.
The owner-selected dynamic motor-braking approach is not a stationary hold or
an independent stop if the controller or its energy path is unavailable. The
default-applied mechanical brake is intended for stationary holding; it is not
credited for dynamic stopping unless specifically rated for it. Loss of
electrical energy must not permit uncontrolled free roll.

The owner accepts slower travel on slopes and clarified that the 450 kg
combined bot-and-trailer case is limited to 15°, while 40° is mower-only.
The combination is budgeted as a 300 kg bot plus 150 kg loaded trailer;
track-supported load and hitch reactions require their own assessment.
At the 350 mm drum's assumed
0.175 m effective radius, the
[gravity-only requirements](../../width-and-slope-sizing.md#traction-climbing-and-holding-are-separate-gates)
are 165.5 Nm per track at 300 kg / 40° and 100.0 Nm at 450 kg / 15°.
The example 48 V 16:1 reduction yields about 86.6 Nm at 85% assumed efficiency,
below both cases; it has no demonstrated load margin and does not qualify
either operating condition. The
combination's gravity-only figure assumes both vehicles are on the same grade
and does not include trailer rolling resistance or braking behavior.

The battery shortlist compares suppliers, packaging and qualification gaps
within the sole active 48 V direction, not supplier-qualified drive packages.

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS14: Traction motor and controller

**Cost-ledger coverage:** DRV-001:DRV-002

**Part links:** [Motor choices and specifications](propulsion.md#parts-at-a-glance) ·
[Motor costs](propulsion.md#0201-traction-motors-and-included-planetary-where-applicable) ·
[Controller costs](propulsion.md#0202-traction-motor-controllers) ·
[Motor-to-track mounting](propulsion.md#motor-to-track-mounting).

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

**Part links:** [Brake costs](propulsion.md#0203-mechanical-holding-brakes) ·
[Motor-braking direction](propulsion.md#owner-braking-direction-2026-10-27) ·
[Stop-chain connection](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

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

**Part links:** [Shaft, hub and bearing costs](propulsion.md#0204-output-hubs-shafts-and-bearings) ·
[Motor/drum load path](propulsion.md#motor-to-track-mounting) ·
[Track engagement](../01-structure-and-running-gear/running-gear.md#drive-drum-study) ·
[Frame mounting plates](../01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates).

**Required purchasing/manufacturing definition:** Supported sprocket shaft drawing,
material, fits, key/hub/coupling, bearing loads/life and retention; avoid track side
load on an unqualified gearhead

**Receiving or first-article evidence:** Material/fit/runout/alignment records, bearing
identity and fastening evidence; loaded performance per reviewed test plan

### PS17: Reduction and transmission hardware

**Cost-ledger coverage:** DRV-012:DRV-012

**Part links:** [Reduction keys and fasteners](propulsion.md#0205-reduction-keys-and-fasteners) ·
[Unpriced in-drum study](propulsion.md#hpm5000b-planetary-in-drum-study) ·
[Motor-to-track mounting](propulsion.md#motor-to-track-mounting).

**Required purchasing/manufacturing definition:** Released ratio/tooth counts,
lubrication and service factor, shaft/key/bearing drawings, guard interfaces
and, for any future chain alternative, chain size/length and tensioner range.
Identify the baseline motor's included planetary provision separately from
the unpriced custom in-drum study; define ratio/load ratings for propulsion and motor braking,
including downhill back-driven speed and brake torque at the track

**Receiving or first-article evidence:** Parts and centre-distance/chain-alignment
match; recorded tension; calculated torque/speed from verified motor and reduction
data; logged current, voltage, speed, and thermal observations during reviewed
braking checks; kit contents must not be double-counted. Only keys/bushes/
fasteners are separately costed here; replacement reductions need their own
approved scope and quote. Direct torque measurement is not in the
current test method, so torque capability remains unmeasured and unqualified.

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)


## Sourcing

| Evidence scope | Named sources |
| --- | --- |
| 48 V planetary package | [BLDC motor and brake option (S11)](../../bom/sources.md#s11-bldc-2-kw-planetary-motor) · [BD100/C100 controller (S12)](../../bom/sources.md#s12-bldc-bd100c100-controller) |
| Non-additive HPM5000B | [Marketplace price (S23)](../../bom/sources.md#s23-golden-motor-hpm5000b-marketplace-price) · [Manufacturer family data (S24)](../../bom/sources.md#s24-golden-motor-hpm5000b-family-specification) · [KellyControllers.eu fallback (S25)](../../bom/sources.md#s25-kellycontrollerseu-hpm5000b-fallback) |
| Mechanical hardware and alternative reductions | [DOLD bearings (S03)](../../bom/sources.md#s03-dold-bearing-housings) · [Mechanical parts (S04)](../../bom/sources.md#s04-dold-mechanical-parts) · [Chain drives (S05)](../../bom/sources.md#s05-dold-chain-drives) · [Planetary gearboxes (S10)](../../bom/sources.md#s10-dold-planetary-gearbox-alternatives) · [RS components (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools) |

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)


## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Sprocket engagement and track-side loads | [Sprockets, rollers and tensioners](../01-structure-and-running-gear/running-gear.md#ps02-sprockets-rollers-and-tensioners) |
| Bus current, regeneration and BMS opening | [Battery packs and BMS](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) |
| Power interruption and controller input charging | [Main switching](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) · [Precharge](../05-power-cables-and-electronics/power-distribution.md#ps22-precharge-and-discharge) |
| Independent stop and restart behavior | [Independent stopping](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| Torque calculations versus observed performance | [Workshop test method and evidence](../07-workshop-and-support/workshop.md#test-method-and-evidence) |

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)

## Detailed module costs

**Cost context:** [Drive-train totals](../../cost-breakdown.md#02--drive-train) ·
[Ledger and assumptions](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md).

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
Item links open the purchasing and inspection requirements.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

<a id="cost-motors"></a>

### 02.01 Traction motors and included planetary where applicable

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [DRV-001 - Traction motor with planetary gearbox provision](propulsion.md#ps14-traction-motor-and-controller) (2 each) | €2,071.88 / C |
| **Module subtotal** | €2,071.88 |

<a id="cost-motor-controllers"></a>

### 02.02 Traction motor controllers

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [DRV-002 - Matched motor controller](propulsion.md#ps14-traction-motor-and-controller) (2 each) | €1,023.24 / C |
| **Module subtotal** | €1,023.24 |

<a id="cost-brakes"></a>

### 02.03 Mechanical holding brakes

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [DRV-003 - Mechanical holding brake provision](propulsion.md#ps15-mechanical-brakes) (2 each) | €446.54 / C |
| **Module subtotal** | €446.54 |

<a id="cost-output-support"></a>

### 02.04 Output hubs shafts and bearings

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [DRV-004 - Output shaft couplings or mounting hubs](propulsion.md#ps16-output-shafts-and-bearings) (2 each) | €60.00 / A |
| [DRV-005 - External output shaft stock](propulsion.md#ps16-output-shafts-and-bearings) (2 each) | €70.00 / A |
| [DRV-006 - Output shaft bearing blocks](propulsion.md#ps16-output-shafts-and-bearings) (4 each) | €80.00 / A |
| **Module subtotal** | €210.00 |

<a id="cost-chain-reduction"></a>

### 02.05 Reduction keys and fasteners

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [DRV-012 - Keys bushes and reduction fasteners](propulsion.md#ps17-reduction-and-transmission-hardware) (2 pod set) | €30.00 / A |
| **Module subtotal** | €30.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €3,781.66 |
<!-- END GENERATED: details -->

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)
