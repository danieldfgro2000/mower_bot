# BOM feedback and qualification loops

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Why a part or estimating assumption changed, and what remains
open. Use the current-component links beside each decision to inspect today's
price, specifications, and fit; the dated record itself is not approval.

**On this page:** [Decision map and history](feedback.md#feedback-decisions) ·
[Qualification loops](feedback.md#feedback-and-qualification-loops)

**Related documents:**
[Chassis BOM](chassis-bom.md) ·
[Cost ledger](chassis-bom.csv) ·
[Supplier register](sources.md#source-id-lookup) ·
[Chassis Build and Procurement Checklist](../chassis-build-requirements.md)

## Feedback decisions

Read each date and correction together. Current requirements live in the
linked engineering scopes, not in an earlier proposal.

| Decision record | Current component / working view |
| --- | --- |
| [Propulsion comparison (F01)](feedback.md#f01-propulsion) | [Motor choices, prices and specifications](../modules/02-drive-train/propulsion.md#parts-at-a-glance) |
| [Budget target (F02)](feedback.md#f02-budget) | [Estimate rules and scope](chassis-bom.md#estimate-rules) |
| [Existing inventory and fabrication (F03)](feedback.md#f03-existing-inventory-and-fabrication) | [Workshop buy/reuse choices](../modules/07-workshop-and-support/workshop.md#parts-at-a-glance) |
| [Rolling adjustment and donor motor (F04)](feedback.md#f04-adjustment-mode-and-actuator) | [Motor data and mechanical drive path](../modules/03-width-adjustment/width-adjustment.md#donor-motor-and-allowance) |
| [Worm-only holding and position proposal (F05)](feedback.md#f05-holding-and-position-proposal) | [Unresolved holding and stopping](../modules/03-width-adjustment/width-adjustment.md#width-holding-and-stopping) |
| [Packaging and site targets (F06)](feedback.md#f06-packaging-and-site-targets) | [Width and slope inputs](../width-and-slope-sizing.md#inputs-and-unresolved-definitions) |
| [Slope orientation and reduced speed (F07)](feedback.md#f07-slope-orientation-and-speed) | [Reduced-speed implications](../width-and-slope-sizing.md#effect-of-accepting-reduced-speed) |
| [Bare motor and HPM5000B sourcing (F08)](feedback.md#f08-bare-motor-two-stage-chains-and-hpm5000b-sourcing) | [HPM5000B price and exclusions](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate) · [Later in-drum study](../modules/02-drive-train/propulsion.md#hpm5000b-planetary-in-drum-study) |
| [Rear motor position (F09)](feedback.md#f09-rear-traction-motor-position) | [Motor/drum layout and mounting interfaces](../modules/02-drive-train/propulsion.md#motor-to-track-mounting) |
| [Workshop, test method and app control (F10)](feedback.md#f10-workshop-equipment-test-method-and-mobile-app-control) | [Tool-by-tool price/reuse table](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) · [Independent stop requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| [Motor braking and stationary hold (F11)](feedback.md#f11-motor-braking-and-stationary-hold) | [Braking direction](../modules/02-drive-train/propulsion.md#owner-braking-direction-2026-10-27) |
| [48 V baseline and scenario retirement (F12)](feedback.md#f12-48-v-battery-baseline-and-scenario-retirement) | [Active cost configuration](chassis-bom.md#propulsionbattery-comparison) |
| [Value battery shortlist and charger bundles (F13)](feedback.md#f13-value-battery-shortlist-and-bundled-chargers) | [DC HOUSE first choice and priced alternatives](../modules/04-battery-and-charging/batteries.md#battery-alternatives) |
| [HPM5000B, controller and brake baseline (F14)](feedback.md#f14-hpm5000b-controller-and-brake-cost-baseline) | [Current component references](../modules/02-drive-train/propulsion.md#parts-at-a-glance) · [Brake fitment](../modules/02-drive-train/propulsion.md#fdb-13-c-to-hpm5000b-fitment) |

### F01: propulsion

**Decision recorded on 2026-10-26:** Compare 48 V / approximately 2 kW and 72 V /
approximately 4 kW per motor before selecting.

**Historical effect on estimate (superseded by F12):** Two alternative cost columns; never buy or add both scenarios
together.

### F02: budget

**Decision recorded on 2026-10-26:** €5,000 is a target estimate, not a hard upper
limit; include every material estimate and a total.

**Effect on estimate:** Replace blank costs with explicit allowances; show overruns
rather than omit necessary systems.

### F03: existing inventory and fabrication

**Decision recorded on 2026-10-26:** Welding machine and 3D printer already available;
frame and electronics/cable enclosures will be manufactured by the user.

**Effect on estimate:** No welder/printer purchase; purchased frame labor N/A,
retain steel/consumables, and replace bought electronics boxes with
filament/backplates/seals/inserts. Precision machining and test equipment were
unconfirmed at this date; later inventory/access inputs are in
[Workshop, test method and app control (F10)](feedback.md#f10-workshop-equipment-test-method-and-mobile-app-control).

### F04: adjustment mode and actuator

**Decision recorded on 2026-10-26:** Operator enters width; chassis rolls at a
predefined calculated speed during powered adjustment. Existing windshield motor is 12
V, estimated 3–5 A; user confirms worm-and-wheel reduction.

**Effect on estimate:** Add €407 of screw, driver, converter, feedback, limits, and
associated materials per machine, identical in both traction scenarios. Donor motor is
reused with purchase cost N/A (already owned). No adjustment speed is yet validated.

### F05: holding and position proposal

**Decision recorded on 2026-10-26:** User proposes worm-only holding without another
lock and incremental Hall/optical turn counting converted to width.

**Effect on estimate:** Record the proposal and reference/limit provisions; **do not yet
remove the [plan's positive-locking requirement](../../../plan.md#42-variable-width-scissor-frame)**.
The [width-lock provision (CHS-010)](../modules/01-structure-and-running-gear/frame.md#0105-scissor-pivots-locks-and-hard-stops) retains a €48 pin-cost
reserve, not a selected or integrated automatic locking design. Holding remains a
release blocker.

### F06: packaging and site targets

**Decision recorded on 2026-10-26:** Aspirational 400 mm minimum outside-track width,
allowing mechanical adjustment; 1,600 mm maximum suggested for stability; expected
inclines up to 40°.

**Effect on estimate:** Record as unvalidated targets. [Feasibility
screen](../width-and-slope-sizing.md) shows zero gap at 400 mm, battery packaging conflict,
and separate lateral/longitudinal/traction requirements. Material quantities remain
provisional; 40° is not an operating limit.

### F07: slope orientation and speed

**Decision recorded on 2026-10-26:** The 40° site target includes both uphill/downhill
and cross-slope travel. Speed reduction below the normal-condition 4 km/h target is
accepted.

**Effect on estimate:** Reassess both drive ratios, continuous torque, braking/holding,
and stability. Lower speed reduces power demand, not gravitational torque. Neither cost
scenario is qualified for this site target; repricing follows the reviewed sizing, not
an assumed safe speed.

### F08: bare motor, two-stage chains and HPM5000B sourcing

**Historical estimating status:** The alternative-only status below is
superseded by [F14](feedback.md#f14-hpm5000b-controller-and-brake-cost-baseline).

**Decision recorded on 2026-10-26:** Owner prefers a cheaper bare motor and
two-stage chain reduction rather than the planetary package. Initially retain
approximately 2 kW per drive with a €500 tax-inclusive bare-motor allowance;
subsequently requested a sourced HPM5000B with price and link.

**Effect on estimate:** [HPM5000B alternative ALT-DRV-001](../modules/02-drive-train/propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals)
records a 48 V candidate at
US$446 / €482.36 each under existing FX and provisional VAT assumptions,
excluding delivery/duty/brokerage. This is a sourced alternative, not a selected
5 kW machine-power upgrade or an extra motor added to baseline totals.
The main CSV still costs the former planetary scenario: a complete replacement
must re-cost reduction hardware, compatible controller/brake, machining and any
affected battery/electrical/cooling provisions. No updated total is claimed yet.

**2026-10-27 correction:** The [HPM5000B CAD study](../modules/02-drive-train/propulsion.md#hpm5000b-planetary-in-drum-study) uses three custom
planetary stages inside a 350 mm drive drum, replacing the earlier two-stage
chain concept for this candidate only. The custom gearbox remains unpriced and
unqualified; this does not change the baseline drive or its totals.

**Continue with the current candidate:** [HPM5000B price](../modules/02-drive-train/propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Specifications](../modules/02-drive-train/propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Mounting to the track](../modules/02-drive-train/propulsion.md#motor-to-track-mounting).

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
[plan's fore-aft direction](../../../plan.md#52-motor-and-gearbox-target)
retains the up-to-50 kg tool case without claiming a validated counterbalance.

### F10: workshop equipment, test method, and mobile-app control

**Detail:** [Test-method decision](feedback.md#test-method-decision) ·
[App control and E-stop intent](feedback.md#app-control-and-e-stop-decision) ·
[Workshop inventory](feedback.md#workshop-inventory-and-fabrication) ·
[Cost-scope changes](feedback.md#workshop-cost-scope-changes).

#### Test-method decision

**Decision recorded on 2026-10-27:** Use bench checks before field checks.
Torque will be calculated from the selected motor/reduction data and will remain
unmeasured; no dynamometer is planned. Planned onboard sensors and the logger
are the intended primary source for current, voltage, speed, and temperature,
with a purchased DC-capable clamp meter as an independent current check and the
existing infrared-thermometer allowance retained. Field braking and track-retention
observations will use onboard logs plus observer notes. Initial field checks are
for a bare rolling chassis on flat, controlled ground, without a mower or
attachment.

#### App control and E-stop decision

**Control intent:** The owner intends a mobile app as the only normal operator
control, expects loss of connection to stop the bot, and proposes one general
emergency stop that interrupts current to all modules. This is a proposed
behavior, not a verified safety architecture: loss-of-link stopping, the
independent stop path, brake/holding response, stored energy, and safe reset
still need reviewed design and separate evidence. The industrial-remote and
standalone bench-pendant allowances are removed; the app is not treated as the
independent emergency stop. One general E-stop assembly is budgeted and reused
from the bench through individual pod checks to the final bot; the final
machine's required stop count and placement remain subject to hazard review.
See the [independent stopping requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

#### Workshop inventory and fabrication

**Workshop and fabrication inputs:** The owner reports two transport straps
described as 500 kg, two service supports, a torque wrench, insulated tools,
crimp tooling, suitable thread-locking/sealant/grease stock, cleaning supplies,
welding PPE, safety glasses, and safety footwear. These are treated as reused
inventory pending rating, condition, calibration, compatibility, or suitability
checks. No lifting slings or shackles are planned. The user will fabricate a
restrained, guarded bench fixture from purchased material.

The owner reports a 20–160 A Daewoo MOSFET welder using flux-coated electrodes;
stick/MMA is a likely identification pending the exact model/manual. Welding is
planned outdoors. Keep the electrode allowance, remove shielding gas, and budget
€100 for non-welding starter PPE, including hearing protection, a grinding
face shield, paint-vapour respiratory protection selected for the coating/SDS,
and task-appropriate gloves only where safe; no gloves near rotating machinery.
Welding PPE, glasses, and footwear are reported
available. Use off-the-shelf gears where possible; general lathe/mill access is
available but no gear-cutting capability. Retain the outsourced machining
provision for parts that cannot be made in-house.

#### Workshop cost-scope changes

**Effect on estimate:** Remove the dynamometer/torque package and separate
multimeter, tachometer, bench pendant, industrial remote, lifting slings,
shackles, portable test-area barriers, and charging-surface allowance. Retain
the fire-equipment provision but defer its selection/purchase until a
fire-safety review. Reused equipment does not establish suitability; field or
bench testing remains unauthorized until the relevant safety and test gates are
released. Remove the separate €250 calibration/setup service allowance and
rely on supplier calibration data where provided; end-to-end sensor scaling,
channel mapping, and measurement checks remain required.
Current [workshop parts, requirements and costs](../modules/07-workshop-and-support/workshop.md#parts-at-a-glance)
separate reused inventory from new allowances.

### F11: motor braking and stationary hold

**Historical estimating status:** The unchanged old brake allowance and
unselected component status below are superseded by
[F14](feedback.md#f14-hpm5000b-controller-and-brake-cost-baseline);
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
[mechanical brake provision (DRV-003)](../modules/02-drive-train/propulsion.md#0203-mechanical-holding-brakes)
remains a stationary-hold allowance, not a qualified dynamic brake;
its quantities and scenario costs do not change. No motor, controller, brake,
or gearbox is selected, and the HPM5000B alternative still excludes its
controller, brake, and custom gearbox. Field observations can inform the
additional dynamic-brake decision but do not by themselves qualify fault or
power-loss stopping. Test and safety release remain open.

[↑ Back to document overview](feedback.md#bom-feedback-and-qualification-loops)


### F12: 48 V battery baseline and scenario retirement

**Decision recorded on 2026-10-28:** Use two 48 V-class / 51.2 V, 100 Ah
LiFePO4 packs, one per pod; assess current capability separately from capacity.
Prioritize European-stocked mobile/traction packs and consider worthwhile
direct imports. Document three publicly priced options and use the recommended
option as the budget reference. Remove the 72 V scenario from all active BOM
and cost-comparison tables; this does not change the retained 48 V drive scenario.

**Historical budget recommendation, superseded by F13:** [Ultimatron UBL-48-100H](sources.md#s27-ultimatron-ubl-48-100h-and-charger),
with the separately listed 10 A charger, replaces the former Elker reference.
The other two [priced packs](../modules/04-battery-and-charging/batteries.md#battery-alternatives)
are non-additive alternatives. This is a recommended estimating baseline,
not a purchased or mower-qualified assembly. Pack fit, current/regen, cold
charging and supplier-rating conflicts remain HOLD.

**Historical effect on estimate:** Retire the 72 V CSV columns and its five external-drive
lines DRV-007–011, which had no 48 V purchase cost. Preserve all other 48 V
costs before the battery update. The new pack/charger references add €990.28
to materials: €13,879.10 total and €17,710.92 including the existing provisions
and contingency. Freight remains a provision, not a confirmed delivery price.

### F13: value battery shortlist and bundled chargers

**Decision recorded on 2026-10-28:** Retain only the €1,199 Greenboatsolutions
offer from the previous shortlist and research other suppliers. Capacity is
approximately 100 Ah, with modest upward variation such as 105 Ah accepted.
The owner initially approved GBS as the provisional budget reference, then
preferred DC HOUSE's charger bundle as first option if suitable while
continuing research.

**Conditional recommendation:** [DC HOUSE's non-DE EU €849.99 bundle](sources.md#s30-dc-house-100-ah-charger-bundle)
passes a voltage/load/envelope candidate screen, not vehicle qualification.
Use it first and as the estimating reference; preserve GBS and add Vatrer's
priced 105 Ah mobile variants. LiTime's inspected 100 Ah offer is unavailable.
Ultimatron/ACES remain only dated source history, not active recommendations.
The GBS/DC HOUSE SKU relationship does not prove independent pack designs.

**Effect on estimate:** BAT-001 includes an 18 A charger and BMS per pack.
Apply the disclosed conditional 21% tax reserve to €849.99: **€1,028.49
per bundle / €2,056.98 for two**. Destination VAT inclusion is unresolved;
replace the reserve once confirmed, without double taxation. BAT-005 becomes
included (`I / N/A`), avoiding a duplicate charger purchase. Other component
costs and the retired 72 V status are unchanged. Materials decrease by
**€1,721.46 to €12,157.64**; battery/charging costs become **€2,416.98**;
the indicative budget with unchanged provisions and 20% contingency becomes
**€15,645.17**.

**Open holds:** Exact revision and dimensions, contradictory peak/charger
ratings, regen/BMS behavior, cell-temperature protection, environmental and
vibration evidence, 89.8 kg pair mass/CG and full pod fit, household charger
capacity, Romania shipment/tax and warranty. No hardware, purchasing or
supplier-contact authorization is implied.

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
The [20 Nm static screen](../modules/02-drive-train/propulsion.md#precima-fdb-13-c-holding-brake-candidate)
is favorable at ideal 66:1, but does not qualify dynamic stopping, transmission
capacity or slope safety. No purchase, modification, energizing or field test
is authorized.

## Feedback and qualification loops

Each loop records **input → proposed revision → user review → BOM/total update**.
A decision can close an estimating assumption; only evidence can close a
component qualification. A failed check reopens downstream selections and costs.

| Qualification loop | Evidence owner |
| --- | --- |
| [Inventory and cost scope (L1)](feedback.md#l1-inventory-and-cost-scope) | [Workshop tools and qualification](../modules/07-workshop-and-support/workshop.md#specification-and-inspection-requirements) |
| [Drive operating points (L2)](feedback.md#l2-drive-operating-points) | [Drive compatibility and duty](../modules/02-drive-train/propulsion.md#compatibility-and-duty-limitations) |
| [Energy and battery (L3)](feedback.md#l3-energy-and-battery) | [Packs and BMS requirements](../modules/04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) |
| [Running gear and structure (L4)](feedback.md#l4-running-gear-and-structure) | [Module 01 requirements](../modules/01-structure-and-running-gear/README.md) · [Width-adjustment requirements](../modules/03-width-adjustment/width-adjustment.md#specification-and-inspection-requirements) |
| [Stopping and electrical safety (L5)](feedback.md#l5-stopping-and-electrical-safety) | [Independent stop requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| [Supplier and price convergence (L6)](feedback.md#l6-supplierprice-convergence) | [Supplier request packages](../chassis-build-requirements.md#4-prepare-procurement-work-packages) · [Cost-update procedure](updating-linked-costs.md) |

### L1: inventory and cost scope

**Inputs needed / next feedback:** Welder/printer and DIY frame/electronics enclosures
confirmed. Owner reports general lathe/mill access without gear cutting; standard gears
are preferred where possible and the machining provision remains for unavoidable
outsourcing. Exact component drawings and tool/inventory suitability checks remain open.

**What changes:** DIY labor and printing materials now reflected; replace other new-buy
allowances only after confirmed inventory/suitability

**Closure evidence:** Partially closed by
[existing-inventory decision (F03)](feedback.md#f03-existing-inventory-and-fabrication)
and [workshop decision (F10)](feedback.md#f10-workshop-equipment-test-method-and-mobile-app-control);
required measurement and
safety functions remain subject to exact selection, design, and qualification.

### L2: drive operating points

**Inputs needed / next feedback:** Derive continuous and short-duty output
torque **at** the rpm implied by the [current operating cases](../../../plan.md#51-duty-requirement)
and confirmed track geometry. The V1 maximum travel target is now 4 km/h;
measure configuration mass, resistance and duty rather than reusing the
withdrawn higher-speed/rpm assumptions.

**What changes:** Qualify the 48 V drive and its non-additive motor/reduction
candidates against the current operating cases; review any plan change before selection

**Closure evidence:** Supplier torque-speed/thermal curves and reduction load ratings;
one-drive bench results remain a later authorized gate

### L3: energy and battery

**Inputs needed / next feedback:** Required usable capacity versus job-energy
measurements; reserve, cold/aging provision, module size/mass and vehicle-duty evidence

**What changes:** Confirm chemistry, exact full-charge/cutoff voltages,
capacity/current, BMS behavior, chargers, and realistic quote

**Closure evidence:** Compatible pack/controller/charger documentation, shipping quote,
and later measured usable energy; no online claim alone closes this

### L4: running gear and structure

**Inputs needed / next feedback:** Powered rolling adjustment chosen; track geometry,
sprocket tooth count, width envelope, scissor/screw dimensions, motor data, mower
interface and load cases still needed

**What changes:** Replace stock masses and provisional counts with drawings; derive
referenced turns-to-width conversion and candidate rolling-speed relationship; resolve
worm-only holding proposal

**Closure evidence:** Reviewed mechanical/load data and separately authorized
validation; positive holding and fault/reference behavior remain open, not waived

### L5: stopping and electrical safety

**Inputs needed / next feedback:** Hazard review, safe-state sequence, independent
remote-stop/heartbeat path, motor/controller dynamic-braking mode and energy
handling at full SOC or BMS cutoff, default-applied stationary brake, power-loss
response, reset/charge/width interlocks

**What changes:** Select braking and stop sequence, switching, fusing, pre-charge,
DC/DC, stop chain and cable sizes; revise all affected costs

**Closure evidence:** Competent design review and independently observed
motor-braking, holding and fault tests under separately authorized commissioning;
decide from evidence whether an additional mechanical dynamic brake is needed;
no firmware-only substitute

### L6: supplier/price convergence

**Inputs needed / next feedback:** Exact MPN/options, quantity, VAT, freight/customs,
stock/lead time, warranty/returns

**What changes:** Replace C/A with actual matched quotations; remove bundle duplicates
and recalculate stage and scenario totals

**Closure evidence:** Itemized delivered offers and procurement approval; remaining
unknowns stay identified

No supplier contact, order, fabrication, upload, energizing, or field test has
been authorized by these feedback decisions. No component, braking arrangement,
controller topology, or operating envelope is approved by this estimate.

[↑ Back to document overview](feedback.md#bom-feedback-and-qualification-loops)
