# BOM feedback and qualification loops

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** A dated record of user inputs that changed estimate assumptions,
followed by [qualification loops](feedback.md#feedback-and-qualification-loops)
that identify technical evidence still needed. Decisions in this log are not
component approval or operating authorization.

**Navigate:** [Feedback decisions](feedback.md#feedback-decisions) ·
[Qualification loops](feedback.md#feedback-and-qualification-loops) |
[Chassis BOM](chassis-bom.md) ·
[Cost ledger](chassis-bom.csv) ·
[Supplier register](sources.md#source-id-lookup) ·
[Chassis Build and Procurement Checklist](../chassis-build-requirements.md)

## Feedback decisions

### F01: propulsion

**Decision recorded on 2026-10-26:** Compare 48 V / approximately 2 kW and 72 V /
approximately 4 kW per motor before selecting.

**Effect on estimate:** Two alternative cost columns; never buy or add both scenarios
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
filament/backplates/seals/inserts. Precision machining and test equipment remain
unconfirmed.

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
remove the plan's positive-locking requirement**. CHS-010 retains a €48 pin-cost
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

**Decision recorded on 2026-10-26:** Owner prefers a cheaper bare motor and
two-stage chain reduction rather than the planetary package. Initially retain
approximately 2 kW per drive with a €500 tax-inclusive bare-motor allowance;
subsequently requested a sourced HPM5000B with price and link.

**Effect on estimate:** ALT-DRV-001 records a 48 V HPM5000B candidate at
US$446 / €482.36 each under existing FX and provisional VAT assumptions,
excluding delivery/duty/brokerage. This is a sourced alternative, not a selected
5 kW machine-power upgrade or an extra motor added to baseline totals.
The main CSV still costs the former planetary scenario: a complete replacement
must re-cost reduction hardware, compatible controller/brake, machining and any
affected battery/electrical/cooling provisions. No updated total is claimed yet.

**2026-10-27 correction:** The current HPM5000B CAD study uses three custom
planetary stages inside a 350 mm drive drum, replacing the earlier two-stage
chain concept for this candidate only. The custom gearbox remains unpriced and
unqualified; this does not change the baseline drive or its totals.

### F09: rear traction-motor position

**Decision recorded on 2026-10-27:** Place the traction motors at the rear of
the bot, behind the front-mounted implements.

**Effect on design:** The owner identifies front tools up to 50 kg, roughly 1 m
forward, that may push against the ground. Record the rear motor position as a
layout direction only; the distance datum, tool reactions, complete-machine CG,
and track support loads remain unverified. This does not change the CAD
orientation, baseline BOM quantities, or costs.

### F10: workshop equipment, test method, and mobile-app control

**Decision recorded on 2026-10-27:** Use bench checks before field checks.
Torque will be calculated from the selected motor/reduction data and will remain
unmeasured; no dynamometer is planned. Planned onboard sensors and the logger
are the intended primary source for current, voltage, speed, and temperature,
with a purchased DC-capable clamp meter as an independent current check and the
existing infrared-thermometer allowance retained. Field braking and track-retention
observations will use onboard logs plus observer notes. Initial field checks are
for a bare rolling chassis on flat, controlled ground, without a mower or
attachment.

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

**Effect on estimate:** Remove the dynamometer/torque package and separate
multimeter, tachometer, bench pendant, industrial remote, lifting slings,
shackles, portable test-area barriers, and charging-surface allowance. Retain
the fire-equipment provision but defer its selection/purchase until a
fire-safety review. Reused equipment does not establish suitability; field or
bench testing remains unauthorized until the relevant safety and test gates are
released. Remove the separate €250 calibration/setup service allowance and
rely on supplier calibration data where provided; end-to-end sensor scaling,
channel mapping, and measurement checks remain required.

### F11: motor braking and stationary hold

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
thermal limits as well as propulsion performance. The existing DRV-003
provision remains a stationary-hold allowance, not a qualified dynamic brake;
its quantities and scenario costs do not change. No motor, controller, brake,
or gearbox is selected, and the HPM5000B alternative still excludes its
controller, brake, and custom gearbox. Field observations can inform the
additional dynamic-brake decision but do not by themselves qualify fault or
power-loss stopping. Test and safety release remain open.

[↑ Back to document overview](feedback.md#document-overview)


## Feedback and qualification loops

Each loop records **input → proposed revision → user review → BOM/total update**.
A decision can close an estimating assumption; only evidence can close a
component qualification. A failed check reopens downstream selections and costs.

### L1: inventory and cost scope

**Inputs needed / next feedback:** Welder/printer and DIY frame/electronics enclosures
confirmed. Owner reports general lathe/mill access without gear cutting; standard gears
are preferred where possible and the machining provision remains for unavoidable
outsourcing. Exact component drawings and tool/inventory suitability checks remain open.

**What changes:** DIY labor and printing materials now reflected; replace other new-buy
allowances only after confirmed inventory/suitability

**Closure evidence:** Partially closed by F03 and F10; required measurement and
safety functions remain subject to exact selection, design, and qualification.

### L2: drive operating points

**Inputs needed / next feedback:** Required continuous output torque **at** working rpm;
acceptable transport speed; measured/estimated loaded mass and terrain

**What changes:** Compare matched 48 V / 2 kW and 72 V / 4 kW packages; review any plan
change before selection

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

[↑ Back to document overview](feedback.md#document-overview)
