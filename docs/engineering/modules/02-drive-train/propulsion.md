# Propulsion, reductions and brakes

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** The estimate now costs the HPM5000B bare motor, EZ-A48500 controller
and FDB 13 C holding brake for each 48 V pod. These are unqualified candidates,
not an installed or approved package. Custom reduction and brake integration
remain **unpriced**; the lower total is not a complete-drive saving.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Fit / next component |
| --- | --- | --- | --- |
| [Golden Motor HPM5000B](propulsion.md#hpm5000b-main-motor-candidate) | Main bare-motor cost reference; unqualified | [Bare-motor price](propulsion.md#hpm5000b-purchase-scope-and-price) · [Supplier specifications](propulsion.md#hpm5000b-ratings-and-sourcing-limits) | [Motor-to-track mounting](propulsion.md#motor-to-track-mounting) |
| [BLDC-GEAR-P2000 / D110BLD2000](propulsion.md#48-v--approximately-2-kw-per-drive) | Former baseline, now non-additive ALT-DRV-002 | [Motor, controller and brake prices/specs](propulsion.md#48-v--approximately-2-kw-per-drive) | [Output shaft and bearings](propulsion.md#ps16-output-shafts-and-bearings) |
| [EZ-A48500 controller](propulsion.md#ez-a48500-controller-candidate) | Selected price reference, not a confirmed HPM match | [Price and comparison](propulsion.md#ez-a48500-controller-candidate) · [Compatibility](propulsion.md#compatibility-and-duty-limitations) | [Battery/BMS](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) · [Power wiring](../05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness) |
| [Reduction, drive hub and bearings](propulsion.md#motor-to-track-mounting) | Custom in-drum reduction unpriced; only generic hardware allowances retained | [Hardware costs](propulsion.md#0204-output-hubs-shafts-and-bearings) · [Reduction data](propulsion.md#ps17-reduction-and-transmission-hardware) | [Track engagement](../01-structure-and-running-gear/running-gear.md#drive-drum-study) · [Mounting plates](../01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) |
| [Precima FDB 13 C](propulsion.md#precima-fdb-13-c-holding-brake-candidate) | 48 V / 20 Nm / 19H7 holding candidate; not direct-fit | [Supplier price and data](propulsion.md#precima-fdb-13-c-holding-brake-candidate) · [Brake requirements](propulsion.md#ps15-mechanical-brakes) | [HPM5000B fitment](propulsion.md#fdb-13-c-to-hpm5000b-fitment) · [Independent stop](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |

**Further detail:** [Drive studies](propulsion.md#drive-alternatives) ·
[Mounting interfaces](propulsion.md#motor-to-track-mounting) ·
[Compatibility and duty](propulsion.md#compatibility-and-duty-limitations) ·
[Release requirements](propulsion.md#specification-and-inspection-requirements) ·
[Sourcing](propulsion.md#sourcing) ·
[Interfaces](propulsion.md#interfaces-with-other-scopes) ·
[Itemized costs](propulsion.md#detailed-module-costs) ·
[Procurement and holds](propulsion.md#procurement-and-release-holds) ·
[Decision records](propulsion.md#decision-records) ·
[Supplier evidence](propulsion.md#supplier-evidence)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[All modules](../README.md#module-directory)

## Drive alternatives

The active 48 V baseline provisions two independent pods. Candidate drive
alternatives remain research inputs, not accepted ratings or safe machine limits.

The [part selector](propulsion.md#parts-at-a-glance) separates the current and former
drive choices. The [in-drum reduction study](propulsion.md#hpm5000b-planetary-in-drum-study)
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
[mechanical brake reference (DRV-003)](propulsion.md#precima-fdb-13-c-holding-brake-candidate)
now costs the FDB 13 C component, not a complete installation or qualified
dynamic-stop provision. See [brake qualification](propulsion.md#ps15-mechanical-brakes) and
[independent stopping](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

<a id="hpm5000b-sourced-alternative--not-added-to-baseline-totals"></a>

### HPM5000B main motor candidate

**Inspect this motor:** [Price](propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Specifications](propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Mounting to the track](propulsion.md#motor-to-track-mounting) ·
[Controller and integration limits](propulsion.md#hpm5000b-integration-hold).

**Cost-ledger item:** **DRV-001**, promoted from the former ALT-DRV-001
reference on 2026-10-28. Two bare motors enter the baseline, not additional
motors alongside the old package. The custom reduction remains unpriced.
The [former geared motor](propulsion.md#48-v--approximately-2-kw-per-drive)
is now ALT-DRV-002, excluded from totals. This is a budget choice, not hardware
qualification or a change to the approximately 2 kW-per-pod operating target.

#### HPM5000B purchase scope and price

**Product and supplier:** Golden Motor **HPM5000B**, bare BLDC/PMSM motor;
**48 V air-cooled configuration requested**.
[Golden Motor Technology marketplace listing](https://goldenmotorcz.en.made-in-china.com/product/CwmnvfujhxVi/China-HPM5000B-48V-4000RPM-Brushless-DC-Motor-with-CE-Certificate.html)
([marketplace evidence, S23](propulsion.md#s23-golden-motor-hpm5000b-marketplace-price)). Checked 2026-10-26;
displayed price is not a delivered quote.
The page offers air/liquid cooling and several windings, so obtain confirmation
that the exact requested configuration and bare-motor scope receive this price.

| Purchase question | Current reference |
| --- | --- |
| One bare motor | **US$446 / €482.36** planning cost, using the published 1–9 piece tier |
| Two motors for the chassis | **€964.72**, using rounded unit costs; included as DRV-001 |
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
| Motor envelope | Manufacturer family: **206 mm diameter × 126 mm length**, approximately **11 kg air-cooled** | Linked drawing shows 53 mm shaft projection and 179 mm overall; exact delivered revision and cooling clearance unconfirmed |
| Controller | Marketplace names **VEC300** | Mention only, not a qualified match, price or configuration |

Evidence: [marketplace record](propulsion.md#s23-golden-motor-hpm5000b-marketplace-price) ·
[manufacturer family page](https://www.goldenmotor.com/frame-bldcmotor.htm) ·
[recorded family limitations](propulsion.md#s24-golden-motor-hpm5000b-family-specification).
These claims do not form an accepted duty specification. Do not use peak
torque for climbing.

**EU fallback:** [KellyControllers.eu 48 V air-cooled HPM5000B](https://www.kellycontrollers.eu/hpm5000b-5kw-48v-leghuteses)
([EU retail evidence, S25](propulsion.md#s25-kellycontrollerseu-hpm5000b-fallback)) displays **€994.33**, but **out of stock, inquire**.
Its displayed €28.19 shipping fee is not confirmed for Romania; VAT treatment
also needs confirmation. This is a sourcing fallback, not the €482.36 basis.
The [HPM5000A-72 reference](propulsion.md#s15-hpm5000a-72-motor-price-proxy) is a different model,
not an interchangeable B.

**Continue with this motor:** [Mounting and track interfaces](propulsion.md#motor-to-track-mounting) ·
[Gear ratio](propulsion.md#speed-and-ratio-screen) ·
[Price and included scope](propulsion.md#hpm5000b-purchase-scope-and-price).

#### HPM5000B integration hold

This is a larger advertised power class than the retained
approximately 2 kW-per-drive target; adding a candidate does not authorize
increasing machine power. Determine whether it can meet the intended duty with
reviewed current/thermal limits and a matched controller. The
[BD100 recommendation](propulsion.md#s12-bldc-bd100c100-controller) and
[planetary motor's optional brake](propulsion.md#s11-bldc-2-kw-planetary-motor) apply to the former planetary motor,
not to this HPM5000B. A VEC300 mention does not establish its price, exact
voltage/current settings, control interfaces or safe stopping behavior.
The selected EZ-A48500 and FDB 13 C references below do not establish
HPM5000B/controller braking compatibility or mechanical fit.

### EZ-A48500 controller candidate

**Selected estimating reference:** [Golden Motor EZ-A48500](https://www.goldenmotor.com/frame-controllers.htm),
**US$286 / €309.31 each / €618.62 pair**, checked 2026-10-28.
The EUR reference uses `286 / 1.1188 × 1.21`, rounded per unit, excluding
freight, duty and brokerage. [S32](propulsion.md#s32-golden-motor-ez-a48500-controller)
owns evidence and the linked manual. Exact kit contents, revision and availability
require a quote.

| Published attribute | Interpretation / hold |
| --- | --- |
| Nominal 48 V; advertised motor class 3–5 kW | Candidate for evaluation, not authorization to exceed approximately 2 kW per pod |
| 500 A maximum phase / 200 A rated phase / 250 A maximum bus | Hardware claims, **not proposed settings**; establish separate motor-phase and battery-current limits |
| Maximum voltage: page 72 V / manual 75 V | Conflicting family evidence; resolve exact revision. Neither value is an allowable regeneration threshold for a 58.4 V-full-charge pack |
| Regeneration, adjustable torque/speed/power, sensor support, Bluetooth and CAN/RS485/UART family claims | Obtain exact HPM sensor/wiring match, command protocol, control-mode support, configuration backup and verified fault behavior |

Qualify thermal installation, low-speed duty, full-SOC/BMS-open braking and
independent stopping. A common manufacturer does not establish plug-and-play
compatibility.

**Other researched controllers, excluded from totals:** These compare bare
public prices, not equivalent delivered/configured kits.

| Candidate | Public price / planning unit EUR | Important difference |
| --- | --- | --- |
| [Golden Motor EZ-A48400](https://www.goldenmotor.com/frame-controllers.htm) | US$244 / **€263.89** | Advertised 2–4 kW; exact current/thermal match remains unqualified |
| [Golden Motor VEC300-48](https://www.goldenmotor.com/frame-controllers.htm) | US$452 / **€488.85** | 120 A listed rated current, 300 A maximum phase; optional US$60 programming tool adds €64.89 if required |
| [Kelly KLS7218S, standard body](https://kellycontroller.com/shop/kls-s/) | US$179 / **€193.59** | Exact direct-store variant; 200 A motor RMS for one minute / 80 A continuous, separately limited battery current; Hall/analog controls, no assumed CAN speed-command interface |
| [Kelly KLS7218S EU fallback](https://www.kellycontrollers.eu/kls7218s) | **€357.31**, tax basis unconfirmed | Out of stock/inquire; delivery and optional waterproofing/programming cable/heat sink not assumed included |

USD references use the same FX/VAT basis as the selected controller.
The [current Kelly manual](https://media.kellycontroller.com/new/Kelly-Cheetah-series-KLS-SUserManualV2.12.pdf)
states 40–86 V operating range for this 48–72 V controller family; this does not
reintroduce another battery scenario. Its regeneration reduces/stops at
overvoltage and is to be used with mechanical brakes. The EU page's older
10-second peak wording differs from the manufacturer's one-minute claim;
resolve revision rather than mixing ratings.

**Current two-pod basket:** Two HPM5000B motors + two EZ-A48500 controllers +
two DC HOUSE pack/charger bundles = **€3,640.32**. This excludes brakes,
custom reduction and all other materials; the battery tax reserve is unchanged.

**Continue:** [Motor data](propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Battery/BMS qualification](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) ·
[Controller wiring](../05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness).

### Precima FDB 13 C holding-brake candidate

**Selected estimating variant:** **FDB 13 C S 20NM-48VDC-19H7**, BJ-Gear
SKU **HV2052113232S**, one spring-applied/electrically released brake per pod,
on the motor side of the reduction. This is a component-price reference,
not a qualified HPM5000B bolt-on accessory.

| Purchase / specification | Reference |
| --- | --- |
| Supplier link | [Precima FDB 13 C at BJ-Gear](https://shop.bj-gear.com/en_eur/precima-spring-applied-brake-fdb-adjustable-13-48vdc-19h7o) |
| Listed unit price | **€159 excluding tax and delivery**, checked 2026-10-28 |
| Planning cost | **€192.39 each / €384.78 for two**, using `159 × 1.21`; DRV-003, basis C |
| Nominal torque / release coil | **20 Nm / 48 V DC**; spring applied without release power |
| Hub bore | **19H7**; exact shaft, key and axial retention compatibility unconfirmed |
| Availability / environment | Listed in stock; quantity and Romania shipment unconfirmed. Seller claims IP54/55, subject to exact installed options |
| Excluded integration | Reaction flange, shaft/hub adaptation, regulated release supply, switching, release monitoring and guarding remain **unpriced** |

**Does 20 Nm before reduction suffice?** For the existing gravity-only
300 kg / 40° / 0.175 m-radius case, equal track sharing gives
`300 × 9.81 × sin(40°) × 0.175 / 2 = 165.53 Nm` per sprocket.
At the provisional **66:1** ratio, ideal reflected static torque is
**2.51 Nm per motor shaft**. The nominal 20 Nm brake is about **7.97 times**
that ideal requirement. This is encouraging for holding, not a certified
safety factor or proof of the complete system. No gearbox friction is credited.
At the former 16:1 illustration it would require 10.35 Nm, so the final ratio
matters. The ideal `20 × 66 = 1,320 Nm` output equivalent is not a gearbox rating.

**Qualification holds:** Establish torque across wear/temperature, unequal
loading, exact shaft/hub fit, reaction mounting, release monitoring and power.
Do not connect a nominal 48 V coil directly to the 40–58.4 V pack without its
approved voltage range or regulation. A motor-side brake cannot hold through
a broken coupling, shaft or gear path. Sudden application while moving can
impose large transient loads; qualify friction work, stopping duty and driveline
strength separately. Whole-track sliding is a separate limit.

The [FDB installation manual](https://sabjgearweuprodmedia.blob.core.windows.net/pim-perfion-files/product-assets/HV2052113232S/en-GB-installationManual.pdf)
lists **6,000 rpm maximum rotor speed** for size 13 (PDF page 13); this is not
a repeated emergency-stop rating. The exact delivered revision still governs.
No off-the-shelf braked track roller was verified in the supplier screen.
Braking a smooth support roller relies on belt friction, not positive track
engagement. A custom disc/caliper remains a possible unpriced design alternative,
not permission to defer independent stopping and power-off holding until after
field trials.

**Continue:** [Brake source and manual (S33)](propulsion.md#s33-precima-fdb-13-c-holding-brake) ·
[Motor/brake fitment](propulsion.md#fdb-13-c-to-hpm5000b-fitment) ·
[Motor-to-track mounting](propulsion.md#motor-to-track-mounting) ·
[Brake acceptance requirements](propulsion.md#ps15-mechanical-brakes) ·
[Independent stop](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

#### FDB 13 C to HPM5000B fitment

**Finding, 2026-10-28: the selected 19H7 brake is not a direct shaft fit or
verified bolt-on assembly.** The motor page's `19mm(D:22.3mm)` wording must
not be mistaken for a 19 mm shaft.

| Interface | Published drawing evidence | Consequence |
| --- | --- | --- |
| Motor shaft and key | [Golden Motor air-cooled drawing GD-JS-03000001](https://www.goldenmotor.com/hubmotors/hubmotor-imgs/HPM5000B%20Drawing.pdf): nominal **Ø22.3 mm** shaft; **5 mm** keyway width; **43 mm** keyed length; **53 mm** projection | The drawing's 19 mm section dimension refers to the keyway geometry, not shaft diameter. A 19H7 hub cannot slide over Ø22.3 mm |
| Brake hub | Exact purchased reference is **19H7**; [FDB family brochure](https://sabjgearweuprodmedia.blob.core.windows.net/pim-perfion-files/product-assets/HV2052113232S/en-GB-brochure.pdf), page 2, lists other size-13 hub options and DIN keyways | The brochure does not establish a Ø22.3 mm / 5 mm-key hub option. Confirm the exact supplied hub/key/retention drawing; do not assume interchangeability |
| Mounting pattern | Motor drawing: **four M8 holes on Ø148 mm** circle; brake size-13 family drawing: **three M6 mounts on Ø112 mm** circle | Patterns do not match. A properly designed stationary reaction flange/support is required; the motor face is not automatically a suitable brake friction surface |
| Brake envelope | Size-13 family: **Ø130 mm** body, **Ø135 mm** outer envelope, axial body dimension **g = 53.1 mm**; C-version adjustment projection **p = 3.5 mm**, up to **9.5 mm** | Space is needed beyond the body for options, hub/retention, adjustment and service. Obtain exact SKU drawing before layout release |
| Combined axial fit | Motor drawing: **179 mm overall**, including 53 mm projection; existing CAD uses the 126 mm body only and has just **14 mm nominal remainder** after placeholder stages/carrier | The brake body alone exceeds that remainder. No validated axial stack fits the existing study; shaft, reducer and brake may share some axial space only after detailed design |

**Integration directions to investigate, not fabrication instructions:** Ask
Precima/BJ-Gear about a manufacturer-approved hub matching the actual motor
shaft/key, with a designed reaction flange and revised axial layout; its price
is unknown and is not included in the €159 variant. Alternatively, evaluate
a separately supported intermediate shaft with the selected 19H7 brake hub
and rated motor/reducer couplings. That adds bearings, coupling/retention
requirements, length and cost; holding still depends on the intact downstream
transmission. The motor drawing does not establish an accessible second shaft
for rear mounting.

Do not treat a sleeve as a way to fit a smaller bore over a larger shaft.
No reboring of the brake hub or machining of the motor shaft is approved.
Release requires manufacturer-confirmed revisions, fit/key tolerances, axial
retention, reaction loads, bearing support and a complete assembly drawing.
The published family coil load is **34 W at 20°C** for size 13
(about **0.71 A at 48 V**, 68 W for two continuously released brakes);
confirm the delivered coil, supply and hot/cold behavior before adding this
to the auxiliaries/runtime budget.

**Continue:** [Motor drawing evidence (S24)](propulsion.md#s24-golden-motor-hpm5000b-family-specification) ·
[Brake evidence (S33)](propulsion.md#s33-precima-fdb-13-c-holding-brake) ·
[Frame reaction mounting](../01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates).

### HPM5000B planetary-in-drum study

**Study only:** the motor is priced separately; the custom gearbox is not.
Follow [motor-to-track mounting](propulsion.md#motor-to-track-mounting) for what
is fixed, what rotates, and which attachment details are still missing.

**Detail:** [Motor and drum layout](propulsion.md#motor-and-drum-layout) ·
[Speed and ratio screen](propulsion.md#speed-and-ratio-screen) ·
[CAD package envelope](propulsion.md#cad-package-envelope) ·
[Load cases and performance limits](propulsion.md#load-cases-and-performance-limits).

#### Speed and ratio screen

Temporarily treating the 350 mm physical drum outside-diameter study
placeholder as the effective rolling diameter, 4 km/h requires about
**60.6 rpm** at the drum. The 350 mm value is not a required drum size. At the
listing's 4,000 rpm motor
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

**Former baseline, excluded from current totals:** The motor/planetary provision
is retained as **ALT-DRV-002**. Its old controller and brake prices below are
non-additive comparisons, not compatible HPM5000B accessories.

**Inspect this package:** [Alternative motor costs](../../bom/chassis-bom.md#propulsionbattery-comparison) ·
[Mounting and output support](propulsion.md#motor-to-track-mounting) ·
[Matched battery scenario](../04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive).

| Item | Planning cost per unit | Supplier data / limit |
| --- | --- | --- |
| [BLDC-GEAR-P2000 / D110BLD2000-48A-30S](propulsion.md#s11-bldc-2-kw-planetary-motor) | **€1,035.94** from US$957.86, including base planetary provision | 2 kW, 3,000 rpm, 6.37 Nm motor-shaft torque, listed 52.08 A; 16:1 option needs exact quote and gearbox output ratings |
| [BD100 / page SKU C100 controller](propulsion.md#s12-bldc-bd100c100-controller) | **€511.62** from US$473.06 | Supplier-recommended; listed 75 A and closed-loop speed, but torque loop described as open-loop |
| Optional motor brake | **€223.27** from US$206.44 | 24 V; spring-applied state, holding torque and stopping duty unconfirmed |

EUR references use `USD / 1.1188 × 1.21`; they are not delivered package quotes.

**Reduction screening:** At 16:1 and an **assumed** overall 85% mechanical efficiency:
approximately 86.6 Nm and 187.5 rpm at rated motor speed. Gearbox output torque, peak
load, radial load, and skid-steer duty must be documented.

**Former-package comparison, not the current basket:** Two motors + two controllers
+ two pack/charger bundles = **€5,152.10** using the
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
| Drum to track | 350 mm physical drum OD is a flexible study placeholder, not a required size or confirmed track pitch geometry | [Drum/sprocket engagement](../01-structure-and-running-gear/running-gear.md#drive-drum-study) · [Track profile](../01-structure-and-running-gear/running-gear.md#ps01-rubber-tracks) |
| Track side loads to structure | Shaft, bearing and retention design must carry the actual loads; gearhead suitability is not assumed | [Output shafts and bearings](propulsion.md#ps16-output-shafts-and-bearings) |

The former **48 V planetary** package needs its own motor/gearhead mounting
drawings and supported output interfaces. Do not transfer the HPM5000B
envelope or custom gearbox to that package.
The retained [hub/shaft/bearing allowances](propulsion.md#0204-output-hubs-shafts-and-bearings)
and [mounting-plate stock](../01-structure-and-running-gear/frame.md#0104-frame-stock-and-mounting-plates)
do not price or qualify a completed custom in-drum assembly.

### Motor and drum layout

**Provisional study direction (2026-10-27):** Use the HPM5000B as the
provisional motor envelope, coaxial with the drive drum and extending into it
as far as packaging allows. The 350 mm outside diameter is a flexible starting
placeholder, not an owner-selected dimension; choose the drum diameter and
tooth/profile geometry with the selected track, reduction, and packaging. Place
the motor/drive drum at
the rear of the bot, behind the front-mounted implement zone. House three
planetary stages inside the drum; hold each ring gear stationary to the pod and
connect the final carrier to the rotating drum. This fore-aft location is a
layout decision, not proof that the motor counterbalances implement loads. The
[editable CAD study](../../cad/module-01-track-pod-fit.scad) remains
orientation-neutral and shows motor/gear envelopes on that axis only. This is
not a gearbox quote or release for manufacture. The motor is now the cost
reference; its custom reduction and brake installation are still unpriced.

The [published motor body](propulsion.md#hpm5000b-ratings-and-sourcing-limits)
is modeled at 206 mm diameter × 126 mm length and 11 kg air-cooled. The
[new drawing/fit screen](propulsion.md#fdb-13-c-to-hpm5000b-fitment) adds shaft
and mounting dimensions not yet represented in CAD. Cooling clearance and
actual gearbox dimensions remain unresolved. See the [package envelope](propulsion.md#cad-package-envelope)
for the placeholder stage, carrier, and drum dimensions; none establishes fit.

**Continue:** [Motor price](propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Frame-side mounting](../01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) ·
[Track-side fit](../01-structure-and-running-gear/running-gear.md#drive-drum-study) ·
[Pod/battery clearance](../04-battery-and-charging/batteries.md#provisional-battery-clearance).

[↑ Back to parts](propulsion.md#parts-at-a-glance)


## Compatibility and duty limitations

The selected [EZ-A48500](propulsion.md#ez-a48500-controller-candidate) has a
72 V page / 75 V manual maximum-voltage conflict. The **former BD100**
page separately conflicts between a 24–60 V supply description and a
24–72 V input table; those are not EZ ratings. A 16-series LiFePO4 pack may use up to 58.4 V charging,
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
[Selected FDB 13 C price/data](propulsion.md#precima-fdb-13-c-holding-brake-candidate) ·
[Motor/brake fit](propulsion.md#fdb-13-c-to-hpm5000b-fitment) ·
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
The HPM5000B baseline is a bare motor with **no included reduction**.
Price and qualify the custom in-drum study separately; define ratio/load ratings for propulsion and motor braking,
including downhill back-driven speed and brake torque at the track

**Receiving or first-article evidence:** Parts and centre-distance/chain-alignment
match; recorded tension; calculated torque/speed from verified motor and reduction
data; logged current, voltage, speed, and thermal observations during reviewed
braking checks; kit contents must not be double-counted. Only keys/bushes/
fasteners are separately costed here; the required custom reduction needs its own
approved scope and quote. Direct torque measurement is not in the
current test method, so torque capability remains unmeasured and unqualified.

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)


## Sourcing

| Evidence scope | Named sources |
| --- | --- |
| Former 48 V planetary package | [BLDC motor and brake option (S11)](propulsion.md#s11-bldc-2-kw-planetary-motor) · [BD100/C100 controller (S12)](propulsion.md#s12-bldc-bd100c100-controller) |
| Main HPM5000B reference | [Marketplace price (S23)](propulsion.md#s23-golden-motor-hpm5000b-marketplace-price) · [Manufacturer data/drawing (S24)](propulsion.md#s24-golden-motor-hpm5000b-family-specification) · [KellyControllers.eu fallback (S25)](propulsion.md#s25-kellycontrollerseu-hpm5000b-fallback) |
| Selected controller and brake references | [EZ-A48500 (S32)](propulsion.md#s32-golden-motor-ez-a48500-controller) · [FDB 13 C (S33)](propulsion.md#s33-precima-fdb-13-c-holding-brake) |
| Mechanical hardware and alternative reductions | [DOLD bearings (S03)](../01-structure-and-running-gear/running-gear.md#s03-dold-bearing-housings) · [Mechanical parts (S04)](../../bom/sources.md#s04-dold-mechanical-parts) · [Chain drives (S05)](propulsion.md#s05-dold-chain-drives) · [Planetary gearboxes (S10)](propulsion.md#s10-dold-planetary-gearbox-alternatives) · [RS components (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools) |

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)


## Procurement and release holds

Prepared supplier requests and release holds owned by this scope. Sending a request needs separate user approval; every hold is **OPEN**. Shared document control, manufacturing packs and cross-cutting holds stay in the [Chassis Build and Procurement Checklist](../../chassis-build-requirements.md#chassis-build-and-procurement-checklist).

### Q02: alternative complete drives

**Requirements:** [Motor, controller, brake and reduction](propulsion.md#specification-and-inspection-requirements).
**Current leads:** [HPM5000B](propulsion.md#s23-golden-motor-hpm5000b-marketplace-price),
[EZ-A48500](propulsion.md#s32-golden-motor-ez-a48500-controller) and
[FDB 13 C](propulsion.md#s33-precima-fdb-13-c-holding-brake).
The former [BLDC planetary motor](propulsion.md#s11-bldc-2-kw-planetary-motor) /
[BD100/C100 controller](propulsion.md#s12-bldc-bd100c100-controller) is a
non-additive alternative; other reduction leads are
[planetary gearboxes](propulsion.md#s10-dold-planetary-gearbox-alternatives) or [chain components](propulsion.md#s05-dold-chain-drives).

**Specific response needed:** One bench drive with second identical drive priced
separately; documented operating-point curves, reduction and brake ratings, controller
configuration and all wiring/interfaces; flag present voltage/current contradictions

**Main motor cost candidate:** [HPM5000B DRV-001](propulsion.md#hpm5000b-main-motor-candidate),
[marketplace evidence](propulsion.md#s23-golden-motor-hpm5000b-marketplace-price) and
[manufacturer data](propulsion.md#s24-golden-motor-hpm5000b-family-specification), with
[KellyControllers.eu](propulsion.md#s25-kellycontrollerseu-hpm5000b-fallback) as an EU fallback.
Confirm 48 V air-cooled winding/shaft and
motor-only contents at the published quantity tier. Confirm EZ-A48500 compatibility,
command interface, bus/phase limits, thermal path and full-SOC/BMS-open braking.
Obtain a complete installed holding/stopping and custom gearbox quote;
the [in-drum gearbox concept](propulsion.md#hpm5000b-planetary-in-drum-study)
is unpriced. Do not transfer the BLDC planetary-package compatibility
or infer approval of a 5 kW power increase.

**Brake fit response:** Resolve the selected FDB 13 C 19H7 hub versus the
published motor Ø22.3 mm / 5 mm-key shaft and mismatched mounting patterns.
Require an approved hub or separately supported shaft, reaction-flange drawing,
axial fit/retention, regulated release supply and default-applied fault behavior.
Confirm exact SKU dimensions, coil voltage range and torque/dynamic-work ratings;
the €159 component price does not cover this integration.

### H02: drive and braking sizing

**Must close before:** Drive/reduction/brake purchase

**Closure evidence / responsible review role:** Torque-speed/duty and stopping/holding
assessment using actual radius, loaded mass and terrain; qualified full-SOC/power-loss
strategy; drivetrain and safety review

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
| [DRV-001 - Golden Motor HPM5000B bare motor 48 V](propulsion.md#ps14-traction-motor-and-controller) (2 each) | €964.72 / C |
| **Module subtotal** | €964.72 |

<a id="cost-motor-controllers"></a>

### 02.02 Traction motor controllers

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [DRV-002 - Golden Motor EZ-A48500 controller candidate](propulsion.md#ps14-traction-motor-and-controller) (2 each) | €618.62 / C |
| **Module subtotal** | €618.62 |

<a id="cost-brakes"></a>

### 02.03 Mechanical holding brakes

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [DRV-003 - Precima FDB 13 C 48 V 20 Nm holding brake](propulsion.md#ps15-mechanical-brakes) (2 each) | €384.78 / C |
| **Module subtotal** | €384.78 |

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
| **All items owned by this scope** | €2,208.12 |
<!-- END GENERATED: details -->

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)


## Decision records

Dated owner decisions and qualification loops for this scope. Read each date with its later corrections; a decision closes an estimating assumption, not a component qualification. Cross-module decisions remain in [BOM feedback](../../bom/feedback.md#feedback-decisions).

### F01: propulsion

**Decision recorded on 2026-10-26:** Compare 48 V / approximately 2 kW and 72 V /
approximately 4 kW per motor before selecting.

**Historical effect on estimate (superseded by F12):** Two alternative cost columns; never buy or add both scenarios
together.

### F08: bare motor, two-stage chains and HPM5000B sourcing

**Historical estimating status:** The alternative-only status below is
superseded by [F14](propulsion.md#f14-hpm5000b-controller-and-brake-cost-baseline).

**Decision recorded on 2026-10-26:** Owner prefers a cheaper bare motor and
two-stage chain reduction rather than the planetary package. Initially retain
approximately 2 kW per drive with a €500 tax-inclusive bare-motor allowance;
subsequently requested a sourced HPM5000B with price and link.

**Effect on estimate:** [HPM5000B alternative ALT-DRV-001](propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals)
records a 48 V candidate at
US$446 / €482.36 each under existing FX and provisional VAT assumptions,
excluding delivery/duty/brokerage. This is a sourced alternative, not a selected
5 kW machine-power upgrade or an extra motor added to baseline totals.
The main CSV still costs the former planetary scenario: a complete replacement
must re-cost reduction hardware, compatible controller/brake, machining and any
affected battery/electrical/cooling provisions. No updated total is claimed yet.

**2026-10-27 correction:** The [HPM5000B CAD study](propulsion.md#hpm5000b-planetary-in-drum-study) uses three custom
planetary stages inside a 350 mm drive drum, replacing the earlier two-stage
chain concept for this candidate only. The custom gearbox remains unpriced and
unqualified; this does not change the baseline drive or its totals.

**Continue with the current candidate:** [HPM5000B price](propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Specifications](propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Mounting to the track](propulsion.md#motor-to-track-mounting).

### F09: rear traction-motor position

**Decision recorded on 2026-10-27:** Place the traction motors at the rear of
the bot, behind the front-mounted implements.

**Effect on design:** The owner identifies front tools up to 50 kg, roughly 1 m
forward, that may push against the ground. Record the rear motor position as a
layout direction only; the distance datum, tool reactions, complete-machine CG,
and track support loads remain unverified. This does not change the CAD
orientation, baseline BOM quantities, or costs.

**2026-10-28 clarification:** The roughly 1 m forward distance is not a fixed
requirement. Choose the tool position through packaging and stability
analysis, then define its actual CG and working-force datums. The
[plan's fore-aft direction](../../../../plan.md#52-motor-and-gearbox-target)
retains the up-to-50 kg tool case without claiming a validated counterbalance.

### F11: motor braking and stationary hold

**Historical estimating status:** The unchanged old brake allowance and
unselected component status below are superseded by
[F14](propulsion.md#f14-hpm5000b-controller-and-brake-cost-baseline);
the holding/stopping qualification requirements remain.

**Decision recorded on 2026-10-27:** Use controlled motor/controller braking
for dynamic deceleration, through regeneration or another supported
reverse-current braking mode. Use a mechanical brake that is applied by
default when release power is absent for stationary holding. Field evidence is
intended to determine whether an additional mechanical dynamic brake is needed.
If an integrated mechanical holding-brake option materially raises the
motor/gearbox price, use a separate brake instead; no numeric price threshold
has been set.

**Effect on design and estimate:** Motor, controller, and reduction selection
must establish braking torque and speed, electrical energy handling, and
thermal limits as well as propulsion performance. The existing
[mechanical brake provision (DRV-003)](propulsion.md#0203-mechanical-holding-brakes)
remains a stationary-hold allowance, not a qualified dynamic brake;
its quantities and scenario costs do not change. No motor, controller, brake,
or gearbox is selected, and the HPM5000B alternative still excludes its
controller, brake, and custom gearbox. Field observations can inform the
additional dynamic-brake decision but do not by themselves qualify fault or
power-loss stopping. Test and safety release remain open.

### F14: HPM5000B, controller and brake cost baseline

**Decision recorded on 2026-10-28:** Use the recorded HPM5000B bare-motor price
as the main cost candidate; select Golden Motor EZ-A48500 for controller
costing and Precima FDB 13 C 48 V / 20 Nm / 19H7 for holding-brake costing.
Add the brake supplier link/price and investigate its HPM5000B fit.
These decisions do not increase the approximately 2 kW-per-pod operating target.

| Replaced ledger reference | New unit / pair | Evidence |
| --- | --- | --- |
| DRV-001 motor/planetary package | HPM5000B **€482.36 / €964.72** | Recorded US$446, S23/S24 |
| DRV-002 BD100/C100 | EZ-A48500 **€309.31 / €618.62** | US$286, S32 |
| DRV-003 former optional brake | FDB 13 C **€192.39 / €384.78** | €159 excluding taxes/delivery, S33 |

USD references use `USD / 1.1188 × 1.21`; the EUR brake uses `159 × 1.21`.
Unit amounts round before extension. Stage 1 remains one each and cumulative
Stage 2 two each. DC HOUSE bundle costs and included-charger treatment are
unchanged. Former HPM alternative ID ALT-DRV-001 is retained in history, not
as an extra purchase; ALT-DRV-002 now holds the former BLDC motor/planetary
reference only, excluded from totals.

**Estimate effect:** Drive train **€2,208.12**, materials **€10,584.10** and
indicative budget **€13,756.92**, with unchanged €880 non-material provisions
and 20% contingency. Materials fall by **€1,573.54**, but this is not a
like-for-like completed-drive saving. The custom reduction, brake adaptation/
reaction mount, release-power/control integration and any further required
stopping hardware are **unpriced**, not included/free.

**Fitment result:** Published motor drawing shows Ø22.3 mm shaft with 5 mm
keyway; the selected brake is 19H7. Mounting patterns also differ, and the
brake body alone exceeds the CAD study's nominal 14 mm axial remainder.
Manufacturer-approved hub/support integration and repackaging are required;
the €159 variant is not qualified as a bolt-on motor accessory.
The [20 Nm static screen](propulsion.md#precima-fdb-13-c-holding-brake-candidate)
is favorable at ideal 66:1, but does not qualify dynamic stopping, transmission
capacity or slope safety. No purchase, modification, energizing or field test
is authorized.

### L2: drive operating points

**Inputs needed / next feedback:** Derive continuous and short-duty output
torque **at** the rpm implied by the [current operating cases](../../../../plan.md#51-duty-requirement)
and confirmed track geometry. The V1 maximum travel target is now 4 km/h;
measure configuration mass, resistance and duty rather than reusing the
withdrawn higher-speed/rpm assumptions.

**What changes:** Qualify the 48 V drive and its non-additive motor/reduction
candidates against the current operating cases; review any plan change before selection

**Closure evidence:** Supplier torque-speed/thermal curves and reduction load ratings;
one-drive bench results remain a later authorized gate

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)


## Supplier evidence

Dated supplier claims for this scope, recorded under the [common sourcing weights](../../bom/sources.md#common-sourcing-weights). Catalog listings are leads, not quotes or qualification. Source IDs stay stable for the [cost ledger](../../bom/chassis-bom.csv).

<a id="s05"></a>

### S05: DOLD chain drives

**Source / source type:** [DOLD chain
drives](https://www.dold-mechatronik.de/Kettenantriebe), catalog

**Evidence or limitation:** Chain/sprocket sourcing lead; pitch, service factor, tooth
counts, and material need engineering selection.

**Engineering detail:** [Reduction and transmission hardware](propulsion.md#ps17-reduction-and-transmission-hardware).

<a id="s10"></a>

### S10: DOLD planetary-gearbox alternatives

**Source / source type:** [DOLD planetary
gearboxes](https://www.dold-mechatronik.de/Planetengetriebe), alternative catalog

**Evidence or limitation:** Obtain output load/duty data and an alternative matched
reduction quote; not an extra purchase in either cost column.

**Engineering detail:** [Reduction qualification](propulsion.md#ps17-reduction-and-transmission-hardware).

<a id="s11"></a>

### S11: BLDC 2 kW planetary motor

**Source / source type:** [BLDC 2 kW planetary
motor](https://www.bldc.com/2000w-planetary-gear-motor), product/options

**Evidence or limitation:** US$957.86 base; controller +US$473.06; optional 24 V brake
+US$206.44. 16:1 appears in options without a displayed surcharge. Listing summary
contradicts its longer ratio list; obtain exact configuration and PLE090 gearhead
ratings.

**Engineering detail:** [48 V package price and specifications](propulsion.md#48-v--approximately-2-kw-per-drive) ·
[Motor-to-track mounting](propulsion.md#motor-to-track-mounting).

<a id="s12"></a>

### S12: BLDC BD100/C100 controller

**Source / source type:** [BLDC BD100/C100
controller](https://www.bldc.com/24v-60v-brushless-dc-motor-controller), product

**Evidence or limitation:** US$473.06, supplier-recommended for the
[BLDC planetary motor](propulsion.md#s11-bldc-2-kw-planetary-motor), 75 A listed,
closed-loop speed; input-range/model naming and environmental limits need clarification.
Direct outdoor/high-vibration use is cautioned against.

**Engineering detail:** [Drive compatibility and duty limitations](propulsion.md#compatibility-and-duty-limitations).

<a id="s13"></a>

### S13: Volcano VOL-BL400C72 motor

**Status:** Historical source only; excluded from the active 48 V BOM.

**Source / source type:** [Volcano
VOL-BL400C72](https://www.volcanomotors.com/product/251mm-72v-4kw-hall-sensor-bldc-motor-with-controller/),
product/RFQ

**Evidence or limitation:** Genuine 4 kW listing claims an S1 continuous-duty
rating; controller optional/customized, no public price, current conflict.
The rating conditions are not established. €650 motor and €500 controller
allowances do not qualify a matched pair.

**Decision history:** [Scenario retirement](../04-battery-and-charging/batteries.md#f12-48-v-battery-baseline-and-scenario-retirement).

<a id="s14"></a>

### S14: EZ-A72500 controller price proxy

**Status:** Historical source only; excluded from the active 48 V BOM.

**Source / source type:** [DOLD
EZ-A72500](https://www.dold-mechatronik.de/EZ-Controller-fuer-5kW-72V-Motor-EZ-A72500),
price proxy

**Evidence or limitation:** €451.98 including 19% VAT in HTML; not a confirmed
controller for the [Volcano VOL-BL400C72](propulsion.md#s13-volcano-vol-bl400c72-motor).

**Decision history:** [Scenario retirement](../04-battery-and-charging/batteries.md#f12-48-v-battery-baseline-and-scenario-retirement).

<a id="s15"></a>

### S15: HPM5000A-72 motor price proxy

**Status:** Historical source only; excluded from the active 48 V BOM.

**Source / source type:** [DOLD
HPM5000A-72](https://www.dold-mechatronik.de/BLDC-Motor-Brushless-DC-Motor-5kW-72V-Luftgeguehlt-HPM5000A-72),
price proxy

**Evidence or limitation:** €630.48 including 19% VAT in HTML; this is a 5 kW model, not
the 4 kW estimating scenario or the HPM5000B marketplace model.

**Decision history:** [Scenario retirement](../04-battery-and-charging/batteries.md#f12-48-v-battery-baseline-and-scenario-retirement) ·
[Distinct HPM5000B current candidate](propulsion.md#hpm5000b-main-motor-candidate).

<a id="s23"></a>

### S23: Golden Motor HPM5000B marketplace price

**Source / source type:** [Golden Motor Technology HPM5000B 48 V / 4,000 rpm
marketplace listing](https://goldenmotorcz.en.made-in-china.com/product/CwmnvfujhxVi/China-HPM5000B-48V-4000RPM-Brushless-DC-Motor-with-CE-Certificate.html),
manufacturer storefront / public price reference

**Evidence or limitation:** Checked 2026-10-26 in public HTML: US$446 per piece
at 1–9 pieces, US$340 at 10–49 and US$310 at 50+. The chassis needs two, so
use US$446. Title identifies HPM5000B 48 V / 4,000 rpm; table claims 5 kW rated,
7.5 kW peak, 13 Nm rated, 45 Nm peak and VEC300 controller. Winding/cooling/shaft
options and included scope need an exact quote; controller is not presumed
included. Existing FX and provisional 21% VAT yield €482.36 per bare motor,
excluding delivery, duty, brokerage and taxes on those charges.
**2026-10-28 promotion:** This recorded price now supplies DRV-001,
replacing the former ALT-DRV-001 record; the motor price itself has not been
freshly rechecked. [F14](propulsion.md#f14-hpm5000b-controller-and-brake-cost-baseline)
records owner selection and downstream re-costing. Qualification is unchanged.

**Continue with HPM5000B:** [Planning price](propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Specifications and conflicts](propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Motor-to-track mounting](propulsion.md#motor-to-track-mounting).

<a id="s24"></a>

### S24: Golden Motor HPM5000B family specification

**Source / source type:** [Golden Motor HPM5000B family
specification](https://www.goldenmotor.com/frame-bldcmotor.htm), manufacturer

**Evidence or limitation:** Rechecked 2026-10-27: 48/72/96/120 V family,
3–7.5 kW, configurable 2,000–6,000 rpm, 40 Nm peak, 11 kg air-cooled /
11.35 kg water-cooled, 206 mm diameter and 126 mm length.
Family claims differ from the
[marketplace's 45 Nm peak and speed claim](propulsion.md#s23-golden-motor-hpm5000b-marketplace-price).
Obtain the exact winding/cooling/shaft drawing, rated operating curve, continuous
thermal duty and permissible shaft loads. The dimensions are the published
motor envelope only; this source does not specify a planetary reducer. No price
or machine approval here.

**Drawing checked 2026-10-28:** The manufacturer's linked
[HPM5000B air-cooled drawing GD-JS-03000001](https://www.goldenmotor.com/hubmotors/hubmotor-imgs/HPM5000B%20Drawing.pdf)
shows nominal Ø22.3 mm output shaft, 5 mm keyway width, 43 mm keyed length,
53 mm shaft projection, 179 mm overall length and four M8 mounting holes
on Ø148 mm circle. The 19 mm cross-section dimension is keyway geometry,
not shaft diameter. It does not match the selected brake's 19H7 bore.
Confirm the drawing revision against the actual 48 V air-cooled order and
obtain controlled tolerances before designing any adaptation. This is newly
read drawing evidence, not a released motor/brake assembly.

**Continue with HPM5000B:** [Specification comparison](propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Motor/drum mounting](propulsion.md#motor-to-track-mounting) ·
[Gearbox study](propulsion.md#hpm5000b-planetary-in-drum-study).

<a id="s25"></a>

### S25: KellyControllers.eu HPM5000B fallback

**Source / source type:** [KellyControllers.eu HPM5000B 5 kW / 48 V air
cooling](https://www.kellycontrollers.eu/hpm5000b-5kw-48v-leghuteses), EU retail fallback

**Evidence or limitation:** Checked 2026-10-26 in public HTML: €994.33 and
availability "Out of stock, inquire!". Page shows €28.19 shipping, not verified
for Romania; VAT basis and delivered price remain unconfirmed. The motor is
explicitly HPM5000B, not HPM5000A. Not the basis for DRV-001's lower import
reference and not evidence of immediate availability.

**Continue with HPM5000B:** [Ratings and sourcing limits](propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Motor/drum mounting](propulsion.md#motor-to-track-mounting).

<a id="s32"></a>

### S32: Golden Motor EZ-A48500 controller

**Checked:** 2026-10-28. **Source / source type:**
[Golden Motor controller catalogue](https://www.goldenmotor.com/frame-controllers.htm),
manufacturer public price/specification table, and
[EZkontrol manual](https://www.goldenmotor.com/controllers/EZkontrol%20Users%20Manual.pdf).

**Evidence:** EZ-A48500 nominal 48 V, advertised 3–5 kW, **US$286**.
`286 / 1.1188 × 1.21 = €309.31` each, **€618.62 for two**,
rounded per unit. Controller only; excludes delivery, duty, brokerage and
taxes on those charges. Exact stock, revision, kit contents and Romania
delivery are unconfirmed. Owner-selected DRV-002 budget candidate, not an
approved motor/controller package.

The page lists **500 A maximum phase**, **200 A rated phase** and
**250 A maximum bus current**. These are distinct supplier limits, not
configuration values or evidence of safe battery/motor currents. Maximum
voltage conflicts: **72 V on the page / 75 V in the manual**. Both require
exact revision confirmation and neither is an allowed pack regeneration voltage.
The family advertises Hall/encoder support, regeneration, Bluetooth configuration,
CAN/RS485/UART and IP66; exact-model command protocol, torque/speed behavior,
motor sensor match, thermal installation and fault response remain HOLD.

**Engineering detail:** [Controller price and integration](propulsion.md#ez-a48500-controller-candidate).

<a id="s33"></a>

### S33: Precima FDB 13 C holding brake

**Checked:** 2026-10-28. **Source / source type:** [BJ-Gear FDB 13 C listing](https://shop.bj-gear.com/en_eur/precima-spring-applied-brake-fdb-adjustable-13-48vdc-19h7o),
European distributor public product page; exact SKU **HV2052113232S**,
designation **FDB 13 C S 20NM-48VDC-19H7**.

**Price:** **€159 excluding taxes and delivery**; listed in stock, without
confirmed two-unit availability or Romanian delivery. Existing 21% planning
VAT gives **€192.39 each / €384.78 pair**. This prices the brake component,
not a complete installed or delivered assembly. It replaces the former
S11 optional motor-brake price in DRV-003.

**Specification claims:** Spring-applied/electrically released, 48 V DC,
20 Nm, 19H7 hub bore, adjustable torque, seller IP54/55 claim.
Confirm exact enclosure options, shaft/key/retention fit, reaction mounting,
torque over wear/temperature, switching time, release monitoring and coil
voltage limits. Do not equate 48 V nominal with direct 58.4 V battery compatibility.
Mounting, shaft adaptation, regulated release supply and associated integration
remain unpriced. Motor-side holding depends on an intact transmission.

**Manufacturer material supplied by the distributor:**
[FDB brochure](https://sabjgearweuprodmedia.blob.core.windows.net/pim-perfion-files/product-assets/HV2052113232S/en-GB-brochure.pdf) ·
[FDB installation manual](https://sabjgearweuprodmedia.blob.core.windows.net/pim-perfion-files/product-assets/HV2052113232S/en-GB-installationManual.pdf).
The manual's PDF page 13 lists 6,000 rpm maximum rotor speed for size 13.
That is not proof of permitted dynamic-stop energy/duty at that speed, nor
confirmation of the delivered revision.

The linked April 2017 family brochure gives size-13 body Ø130 mm,
outer envelope Ø135 mm, axial body dimension g = 53.1 mm, three M6 mounts
on Ø112 mm circle, and 34 W coil power at 20°C. C-version adjustment
projection p is 3.5 mm, pmax 9.5 mm. These are family drawing observations,
not an exact SKU assembly envelope. The motor drawing has Ø22.3 mm shaft
and four M8 mounts on Ø148 mm; neither shaft nor mounting pattern is a direct
match. Price any approved alternative hub or supported-shaft integration
separately. The brochure's torque tolerances and operating conditions prevent
treating nominal 20 Nm as a guaranteed minimum or certified safety margin.

**Engineering detail:** [Price, static-holding screen and integration limits](propulsion.md#precima-fdb-13-c-holding-brake-candidate).

[↑ Back to document overview](propulsion.md#propulsion-reductions-and-brakes)
