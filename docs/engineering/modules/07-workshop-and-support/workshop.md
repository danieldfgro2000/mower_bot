# Workshop, bench equipment and service supplies

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Separate what must be bought from reported existing tools, then
follow each item to the part it measures, supports, or assembles. The planned
method does not measure output torque; neither equipment nor tests are released.

## Parts at a glance

| Item to inspect | Current choice / status | Cost and specifications | Used with / next component |
| --- | --- | --- | --- |
| [DC clamp meter, IR thermometer and hand tools](workshop.md#ps36-instruments-and-workshop-tools) | Two meter allowances; torque wrench, insulated tools and crimp tooling reported available | [Tool-by-tool buy/reuse table](workshop.md#ps36-instruments-and-workshop-tools) · [Cost lines](workshop.md#0704-meters-instruments-hand-tools-and-crimp-tooling) | [Installed sensors/logger](../06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging) · [Cable terminations](../05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness) |
| [Guarded bench fixture](workshop.md#ps34-bench-fixture-and-controls) | Owner-fabricated from purchased materials; no released fixture drawing | [Fixture costs](workshop.md#0702-bench-fixture-and-guards) · [Load/guard requirements](workshop.md#ps34-bench-fixture-and-controls) | [Drive mounting](../02-drive-train/propulsion.md#motor-to-track-mounting) · [Independent stop](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| [Transport straps and service supports](workshop.md#ps33-transport-straps-and-service-supports) | Reused inventory; reported ratings/condition need confirmation | [Reused-cost treatment](workshop.md#0701-loose-transport-straps-and-service-supports) · [Handling requirements](workshop.md#ps33-transport-straps-and-service-supports) | [Installed lifting/tie-down points](../01-structure-and-running-gear/frame.md#ps32-installed-lifting-and-recovery-points) |
| [Calculated torque and observations](workshop.md#ps35-calculated-torque-and-test-evidence) | No dynamometer or direct torque measurement | [Evidence limits](workshop.md#ps35-calculated-torque-and-test-evidence) · [Planned method](workshop.md#test-method-and-evidence) | [Motor/reduction data](../02-drive-train/propulsion.md#ps17-reduction-and-transmission-hardware) |
| [Electrodes and fabrication supplies](workshop.md#ps37-fabrication-consumables) | Electrode/cutting allowances; some supplies reused | [Consumable costs](workshop.md#0705-fabrication-consumables-and-initial-spares) · [Process/material requirements](workshop.md#ps37-fabrication-consumables) | [Frame weldments](../01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments) |
| [Initial spare parts](workshop.md#ps38-initial-spare-parts) | Lot allowance, not a released spare-parts list | [Spare allowance](workshop.md#0705-fabrication-consumables-and-initial-spares) · [Matching requirements](workshop.md#ps38-initial-spare-parts) | [Selected fuses/connectors](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) |
| [PPE, fire provision and cleaning](workshop.md#ps39-ppe-charging-area-and-cleaning) | Starter PPE allowance; fire equipment deferred for review | [Support costs](workshop.md#0706-ppe-deferred-fire-provision-and-cleaning-supplies) · [Task limits](workshop.md#ps39-ppe-charging-area-and-cleaning) | [Charging requirements](../04-battery-and-charging/batteries.md#ps20-charging-and-charge-interlocks) |

**Further detail:** [Test method and evidence](workshop.md#test-method-and-evidence) ·
[Release requirements](workshop.md#specification-and-inspection-requirements) ·
[Sourcing](workshop.md#sourcing) · [Interfaces](workshop.md#interfaces-with-other-scopes) ·
[Itemized costs](workshop.md#detailed-module-costs)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[Module 07 overview](README.md)

## Test method and evidence

The current method is **calculation plus instrumented observation**, not
dynamometer testing. The stages are deliberately distinct:

| Planned stage | Method and linked requirements |
| --- | --- |
| Pre-calculate | Derive torque and speed from verified motor/reduction data. [Calculated torque and test evidence](workshop.md#ps35-calculated-torque-and-test-evidence) remains distinct from measured capability. |
| Bench checks | Use the owner-fabricated [restrained, guarded fixture](workshop.md#ps34-bench-fixture-and-controls), planned [onboard sensors and logger](../06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging), and a [DC clamp meter](workshop.md#ps36-instruments-and-workshop-tools) for an independent current cross-check. |
| Initial field observations | After bench checks and separate release review, use a bare rolling chassis on flat, controlled ground, without mower or attachment. Record motor braking, stationary holding, and track retention as described below. |

The planned logger is primary for current, voltage, speed, temperature, and
faults after installation and channel checks. The budgeted infrared thermometer
is supplementary; it does not measure winding temperature. Separate multimeter,
tachometer, torque sensor, readout, load device, adapters, and bench pendant are
not in the current estimate.

Field logs and observer notes must identify configuration, stopping distance,
surface, load, speed, battery state, and track-retention behavior. The
[braking direction](../02-drive-train/propulsion.md#owner-braking-direction-2026-10-27)
uses motor/controller braking for dynamic deceleration and a default-applied
mechanical brake for stationary holding. Evidence may inform whether an
additional mechanical dynamic brake is needed; it does not establish safety
under untested controller or power faults.

Calculated torque is not measured performance. Logged speed/current/temperature
and observer notes do not prove torque capability, stopping safety, track
retention, or qualification. Test procedures, acceptance criteria, test-area
controls, a response to unavailable motor braking, and authorization remain
open; this document does not authorize energizing or field operation.

[↑ Back to document overview](workshop.md#workshop-bench-equipment-and-service-supplies)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS33: Transport straps and service supports

**Cost-ledger coverage:** MNT-004|MNT-006

**Part links:** [Reused handling-equipment costs](workshop.md#0701-loose-transport-straps-and-service-supports) ·
[Installed frame points](../01-structure-and-running-gear/frame.md#ps32-installed-lifting-and-recovery-points) ·
[Inventory evidence](../../bom/sources.md#u02-owner-reported-workshop-inventory).

The owner reports two transport straps described as 500 kg and two service
supports. No lifting slings or shackles are planned or costed.

**Required purchasing/manufacturing definition:** Confirm the straps' exact
labels, lashing capacity, condition, and compatibility with the actual
transport tie-down layout. Confirm service-support capacity, stability, and
contact geometry against the verified machine mass and support points.

**Receiving or first-article evidence:** Supplier rating/identity and condition;
transport lashing capacity and lifting WLL are not interchangeable. No capacity
is inferred from the owner's reported 500 kg description. No work underneath a
machine supported by unverified equipment.

### PS34: Bench fixture and controls

**Cost-ledger coverage:** TST-001:TST-003

**Part links:** [Fixture material costs](workshop.md#0702-bench-fixture-and-guards) ·
[Drive interfaces to accommodate](../02-drive-train/propulsion.md#motor-to-track-mounting) ·
[E-stop integration](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) ·
[Instruments](workshop.md#ps36-instruments-and-workshop-tools).

The owner plans to fabricate a restrained, guarded bench fixture from purchased
materials. Normal commands are intended to come from the mobile app; no separate
bench pendant is costed.

The owner intends to move the same
[general E-stop assembly](../06-safety-controls-and-sensors/safety-controls.md#app-and-e-stop-intent) from the bench to
individual pod checks and then to the final bot. No second E-stop is costed.
Final stop count, placement, accessibility, and fixture integration remain
subject to the hazard and bench-design review.

**Required purchasing/manufacturing definition:** Bench reaction-load, mounting,
anchor and guard-containment cases; reviewed work-area separation; and a
separate independent hardware stop. The owner's expected stop on app/network
loss is not yet demonstrated and cannot replace that stop.

**Receiving or first-article evidence:** Fixture/guard inspection and reviewed
test-area/stop arrangement before energizing. The general E-stop concept and
the behavior of brakes and stored energy after power interruption remain
unqualified. Portable barriers are not in the current cost estimate; an
acceptable controlled test-area arrangement is still required.

### PS35: Calculated torque and test evidence

**Cost-ledger coverage:** None; no torque-measurement equipment is in the baseline.

**Part links:** [Motor/reduction requirements](../02-drive-train/propulsion.md#ps17-reduction-and-transmission-hardware) ·
[Sensors/logger costs and limits](../06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging) ·
[Bench and field method](workshop.md#test-method-and-evidence).

Torque is to be pre-calculated from the selected motor, reduction, and their
verified data. It will not be directly measured; therefore calculated output
torque is not measured capability or proof that the drive meets its target.

Follow the [staged test method](workshop.md#test-method-and-evidence) for
measurement sources, field configuration, and required records. Before braking
checks, a reviewed test plan must define an independent response if motor
braking is unavailable. A
[holding-only brake](../02-drive-train/propulsion.md#ps15-mechanical-brakes)
cannot be credited with dynamic stopping without its rating and evidence.
Exact procedures, acceptance criteria, and authorized conditions remain open.

### PS36: Instruments and workshop tools

**Cost-ledger coverage:** TST-010:TST-011|TST-013:TST-015

| Tool | Buy / reuse basis | Used with |
| --- | --- | --- |
| DC-capable clamp meter | **€100 allowance**; exact model/range unselected | Independent current cross-check against the [installed sensors/logger](../06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging) |
| Infrared spot thermometer | **€50 allowance**; supplementary, not a winding-temperature measurement | [Drive thermal observations](workshop.md#test-method-and-evidence) |
| Torque wrench | Reused; range and calibration status require confirmation | [Frame and mounting-joint requirements](../01-structure-and-running-gear/frame.md#ps08-fasteners-coatings-and-labels) |
| Insulated hand tools | Reused; condition/suitability require confirmation; no authority for live work | [Isolation and stored-energy requirements](../05-power-cables-and-electronics/power-distribution.md#ps22-precharge-and-discharge) |
| Crimp tools, dies and continuity accessories | Reused; exact die/terminal compatibility open | [Power lugs/connectors](../05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness) · [Signal connectors](../05-power-cables-and-electronics/cables-connectors.md#ps26-signal-harness-and-communications) |

**Cost detail:** [Workshop tools](workshop.md#0704-meters-instruments-hand-tools-and-crimp-tooling).
Separate multimeter and handheld tachometer purchases are removed because the
installed logger/sensors are the intended primary measurement.

**Required purchasing/manufacturing definition:** Confirm meter DC range,
accuracy and electrical ratings; thermometer use limits; torque-wrench range and
calibration status; tool condition; and crimp die compatibility with selected
connectors/lugs.

**Receiving or first-article evidence:** Tool/asset register and inspection
records; calibration evidence where required; approved crimp process coupons.
Insulated tools do not authorize live work, and IR readings are not winding
temperature measurements.

### PS37: Fabrication consumables

**Cost-ledger coverage:** CON-001|CON-003:CON-004

**Part links:** [Consumable costs](workshop.md#0705-fabrication-consumables-and-initial-spares) ·
[Frame stock/weldments](../01-structure-and-running-gear/frame.md#ps04-frame-stock-and-weldments) ·
[Workshop inventory evidence](../../bom/sources.md#u02-owner-reported-workshop-inventory).

The [owner's workshop inventory report (U02)](../../bom/sources.md#u02-owner-reported-workshop-inventory)
describes a 20–160 A Daewoo MOSFET welding machine and flux-coated
electrodes. Stick/MMA is a likely process identification, pending confirmation
from the exact model/manual. The €30 electrode allowance remains; no shielding
gas refill is budgeted. Cutting/grinding/drilling supplies remain an allowance,
and suitable thread-locking/sealant/grease stock is reported available.

**Receiving or first-article evidence:** Batch/expiry and supplier compatibility where
applicable; confirm electrode classification and material/process compatibility
before work. Owner-reported stock is not a released welding procedure or
qualification of a joint.

### PS38: Initial spare parts

**Cost-ledger coverage:** CON-005:CON-005

**Part links:** [Spare allowance](workshop.md#0705-fabrication-consumables-and-initial-spares) ·
[Fuse selection](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) ·
[Connector/terminal selection](../05-power-cables-and-electronics/cables-connectors.md#ps23-high-current-harness).

**Required purchasing/manufacturing definition:** Split spare lot into exact
fuse/contact/seal/fastener/pin MPNs, quantities and approved interchangeability after
installed selections freeze

**Receiving or first-article evidence:** Separate spare stock list and labels; fuse
substitutions need coordination review; no complete spare motor/pack/track included

### PS39: PPE, charging area and cleaning

**Cost-ledger coverage:** CON-006|CON-009:CON-010

**Part links:** [PPE/fire/cleaning costs](workshop.md#0706-ppe-deferred-fire-provision-and-cleaning-supplies) ·
[Charging conditions](../04-battery-and-charging/batteries.md#ps20-charging-and-charge-interlocks) ·
[Controlled bench area](workshop.md#ps34-bench-fixture-and-controls).

The €100 starter PPE allowance is for non-welding tasks. The initial list is:

- Hearing protection.
- A face shield for grinding, used with suitable eye protection.
- A respirator and vapour filters matched to the coating and its safety data
  sheet (SDS); a generic dust mask is not assumed to protect against vapours.
- Task-appropriate gloves only where safe; do not wear gloves near rotating
  machinery.

The owner reports welding PPE, safety glasses, and safety footwear already
available; adequacy remains to be checked. This is a starting list, not a
completed hazard-based PPE assessment. The €60 general fire-equipment provision
is retained but deferred until a competent fire-safety review. Suitable
cleaning/inspection supplies are reported available. Portable test-area
barriers and a non-combustible charging surface were removed from the current
estimate at the owner's direction.

**Receiving or first-article evidence:** Correct items/condition and expiry/service
checks where applicable; task-based PPE assessment; reviewed charging,
incident, and cleaning instructions. The estimate does not establish a safe
charging area or fire response, and no battery-fire suppression capability is
claimed. A controlled test area remains a release requirement even though
portable barriers are not budgeted.

[↑ Back to document overview](workshop.md#workshop-bench-equipment-and-service-supplies)


## Sourcing

| Scope | Evidence and limitation |
| --- | --- |
| Fixture and workshop supplies | [DOLD mechanical parts (S04)](../../bom/sources.md#s04-dold-mechanical-parts) · [Dedeman supplies (S06)](../../bom/sources.md#s06-dedeman-fabrication-supplies) · [RS tools (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools) |
| Budgeted current cross-check | [ATO clamp-meter catalog (S21)](../../bom/sources.md#s21-ato-clamp-meter-catalog); no exact model selected |
| Reused tools and handling equipment | [Owner workshop inventory (U02)](../../bom/sources.md#u02-owner-reported-workshop-inventory); suitability not verified |
| Historical options, excluded from current purchases | [ATO torque sensor (S19)](../../bom/sources.md#s19-ato-dynamic-torque-sensor-excluded-option) · [Torque readout (S20)](../../bom/sources.md#s20-ato-torque-readout-excluded-option) · [Handheld tachometer (S22)](../../bom/sources.md#s22-ato-handheld-tachometer-excluded-option) |

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](workshop.md#workshop-bench-equipment-and-service-supplies)


## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Calculated drive output and braking behavior | [Reduction requirements](../02-drive-train/propulsion.md#ps17-reduction-and-transmission-hardware) · [Mechanical brakes](../02-drive-train/propulsion.md#ps15-mechanical-brakes) |
| Loose equipment versus installed handling points | [Installed lifting and recovery points](../01-structure-and-running-gear/frame.md#ps32-installed-lifting-and-recovery-points) |
| Isolation and residual-energy checks | [Precharge and discharge](../05-power-cables-and-electronics/power-distribution.md#ps22-precharge-and-discharge) |
| Fixture stop and primary measurement | [Independent stopping](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) · [Installed instrumentation and logging](../06-safety-controls-and-sensors/safety-controls.md#ps31-installed-instrumentation-and-logging) |

[↑ Back to document overview](workshop.md#workshop-bench-equipment-and-service-supplies)

## Detailed module costs

**Cost context:** [Workshop/support totals](../../cost-breakdown.md#07--workshop-and-support) ·
[Ledger and assumptions](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md).

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
Item links open the purchasing and inspection requirements.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

<a id="cost-loose-handling"></a>

### 07.01 Loose transport straps and service supports

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [MNT-004 - Transport tie-down straps](workshop.md#ps33-transport-straps-and-service-supports) (2 each) | N/A / R |
| [MNT-006 - Machine service supports](workshop.md#ps33-transport-straps-and-service-supports) (2 each) | N/A / R |
| **Module subtotal** | N/A |

<a id="cost-bench-fixture"></a>

### 07.02 Bench fixture and guards

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [TST-001 - Guarded bench fixture steel](workshop.md#ps34-bench-fixture-and-controls) (20 kg) | €70.00 / A |
| [TST-002 - Fixture feet anchors and fasteners](workshop.md#ps34-bench-fixture-and-controls) (1 set) | €30.00 / A |
| [TST-003 - Fixture guarding and protective screen](workshop.md#ps34-bench-fixture-and-controls) (1 m2) | €35.00 / A |
| **Module subtotal** | €135.00 |

<a id="cost-bench-tools"></a>

### 07.04 Meters instruments hand tools and crimp tooling

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [TST-010 - DC-capable clamp meter](workshop.md#ps36-instruments-and-workshop-tools) (1 each) | €100.00 / A |
| [TST-011 - Infrared spot thermometer](workshop.md#ps36-instruments-and-workshop-tools) (1 each) | €50.00 / A |
| [TST-013 - Torque wrench](workshop.md#ps36-instruments-and-workshop-tools) (1 set) | N/A / R |
| [TST-014 - Insulated hand tools](workshop.md#ps36-instruments-and-workshop-tools) (1 set) | N/A / R |
| [TST-015 - Cable crimp tool dies and continuity accessories](workshop.md#ps36-instruments-and-workshop-tools) (1 set) | N/A / R |
| **Module subtotal** | €150.00 |

<a id="cost-consumables"></a>

### 07.05 Fabrication consumables and initial spares

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [CON-001 - Coated welding electrode allowance](workshop.md#ps37-fabrication-consumables) (1 lot) | €30.00 / A |
| [CON-003 - Cutting grinding and drilling consumables](workshop.md#ps37-fabrication-consumables) (1 lot) | €40.00 / A |
| [CON-004 - Thread locking sealant and grease](workshop.md#ps37-fabrication-consumables) (1 lot) | N/A / R |
| [CON-005 - Initial electrical and mechanical spares](workshop.md#ps38-initial-spare-parts) (1 lot) | €100.00 / A |
| **Module subtotal** | €170.00 |

<a id="cost-ppe-support"></a>

### 07.06 PPE deferred fire provision and cleaning supplies

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [CON-006 - Non-welding starter PPE allowance](workshop.md#ps39-ppe-charging-area-and-cleaning) (1 set) | €100.00 / A |
| [CON-009 - Deferred general workshop fire equipment allowance](workshop.md#ps39-ppe-charging-area-and-cleaning) (1 set) | €60.00 / A |
| [CON-010 - Cleaning and inspection kit](workshop.md#ps39-ppe-charging-area-and-cleaning) (1 set) | N/A / R |
| **Module subtotal** | €160.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €615.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](workshop.md#workshop-bench-equipment-and-service-supplies)
