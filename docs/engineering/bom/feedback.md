# BOM feedback and qualification loops

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**On this page:** [Feedback decisions](feedback.md#feedback-decisions) ·
[Qualification loops](feedback.md#feedback-and-qualification-loops)

**BOM documents:** [BOM overview](../chassis-bom.md) ·
[Cost breakdown](../cost-breakdown.md)

**Related records:** [Cost ledger](../chassis-bom.csv) ·
[Build checklist](../chassis-build-requirements.md) ·
[Supplier register](sources.md#source-register)

Dated estimating decisions and remaining qualification inputs; the product plan remains authoritative.

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
must re-cost chain parts, compatible controller/brake, machining and any affected
battery/electrical/cooling provisions. No updated total is claimed yet.

## Feedback and qualification loops

Each loop records **input → proposed revision → user review → BOM/total update**.
A decision can close an estimating assumption; only evidence can close a
component qualification. A failed check reopens downstream selections and costs.

### L1: inventory and cost scope

**Inputs needed / next feedback:** Welder/printer and DIY frame/electronics enclosures
confirmed; remaining tracks, motors, packs, measuring equipment, and precision machining
access not supplied

**What changes:** DIY labor and printing materials now reflected; replace other new-buy
allowances only after confirmed inventory/suitability

**Closure evidence:** Partially closed by F03; required measurement/safety functions
remain budgeted

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
remote-stop/heartbeat path, full-SOC downhill behavior, power-loss holding,
reset/charge/width interlocks

**What changes:** Select braking, switching, fusing, pre-charge, DC/DC, stop chain and
cable sizes; revise all affected costs

**Closure evidence:** Competent design review and independently observed
stop/holding/fault tests under separately authorized commissioning; no firmware-only
substitute

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
