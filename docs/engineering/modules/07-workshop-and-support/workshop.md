# Workshop, bench equipment and service supplies

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Module 07 budgets a planned owner-fabricated guarded bench fixture,
DC clamp-meter and infrared-thermometer allowances, workshop consumables,
spares, and starter PPE. It excludes a dynamometer: torque is pre-calculated and
remains unmeasured. Planned onboard sensors/logger are intended as the primary
source for current, voltage, speed, and temperature; a clamp meter is retained
as an independent current check.
Owner-reported tools and handling equipment are marked reused pending checks.
Nothing here releases procurement, fabrication, energizing, or testing.

**Navigate:** [Test method and evidence](workshop.md#test-method-and-evidence) ·
[Requirements](workshop.md#specification-and-inspection-requirements) ·
[Sourcing](workshop.md#sourcing) · [Interfaces](workshop.md#interfaces-with-other-scopes) ·
[Itemized costs](workshop.md#detailed-module-costs) |
[Chassis BOM](../../bom/chassis-bom.md#scope-and-decisions) ·
[Workshop cost totals](../../cost-breakdown.md#07--workshop-and-support) ·
[Ledger](../../bom/chassis-bom.csv) · [Release checklist](../../chassis-build-requirements.md) ·
[Supplier register](../../bom/sources.md#source-id-lookup) ·
[Module 07 overview](README.md)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS33: Transport straps and service supports

**Cost-ledger coverage:** MNT-004|MNT-006

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

The owner plans to fabricate a restrained, guarded bench fixture from purchased
materials. Normal commands are intended to come from the mobile app; no separate
bench pendant is costed.

The owner intends to move the same general E-stop assembly from the bench to
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

Torque is to be pre-calculated from the selected motor, reduction, and their
verified data. It will not be directly measured; therefore calculated output
torque is not measured capability or proof that the drive meets its target.

Bench checks precede field checks. The planned [Module 06 sensors and logger](../06-safety-controls-and-sensors/safety-controls.md)
are intended to provide primary current, voltage, speed, temperature, and fault
records after their installation and channel checks. The budgeted DC clamp meter
is an independent current cross-check; the
infrared thermometer is supplementary and does not measure motor winding
temperature. For initial field observations, the owner specifies a bare rolling
chassis on flat, controlled ground without a mower or attachment; braking and
track-retention behavior will be documented using onboard logs plus observer
notes. The exact test procedure, acceptance criteria, and authorized test
conditions remain open.

### PS36: Instruments and workshop tools

**Cost-ledger coverage:** TST-010:TST-011|TST-013:TST-015

The estimate retains a DC-capable clamp meter (€100) and an infrared
thermometer (€50). The owner reports having the torque wrench, insulated tools,
and crimp/continuity tooling; these are treated as reused inventory. Separate
multimeter and handheld tachometer purchases are removed because the user chose
the installed logger/sensors as primary measurement.

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

The owner reports a 20–160 A Daewoo MOSFET welding machine and flux-coated
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

**Required purchasing/manufacturing definition:** Split spare lot into exact
fuse/contact/seal/fastener/pin MPNs, quantities and approved interchangeability after
installed selections freeze

**Receiving or first-article evidence:** Separate spare stock list and labels; fuse
substitutions need coordination review; no complete spare motor/pack/track included

### PS39: PPE, charging area and cleaning

**Cost-ledger coverage:** CON-006|CON-009:CON-010

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

[↑ Back to document overview](workshop.md#document-overview)


## Test method and evidence

The current method is **calculation plus instrumented observation**, not
dynamometer testing. The stages are deliberately distinct:

1. **Pre-calculate:** derive expected torque and speed from verified motor and
   reduction data. Label the result as calculated; direct output torque remains
   unmeasured.
2. **Bench checks:** use the planned owner-fabricated, restrained and guarded fixture.
   The planned onboard logger is primary for current, voltage, speed, temperature,
   and faults; use the purchased DC clamp meter as an independent current
   cross-check. The separate multimeter, tachometer, torque sensor, readout,
   load device, adapters, and bench pendant are not in the current estimate.
3. **Initial field observations:** after bench checks and separate release
   review, begin with a bare rolling chassis on flat, controlled ground without
   the mower or an attachment. Use onboard logs plus observer notes for
   braking and track-retention behavior.

Calculated torque is not measured performance. Logged speed/current/temperature
and observer notes do not prove torque capability, stopping safety, track
retention, or qualification. Test procedures, acceptance criteria, test-area
controls, and authorization remain open; this document does not authorize
energizing or field operation.

[↑ Back to document overview](workshop.md#document-overview)

## Sourcing

[S04](../../bom/sources.md#s04) · [S06](../../bom/sources.md#s06) · [S07](../../bom/sources.md#s07) · [S21](../../bom/sources.md#s21).

Sources [S19](../../bom/sources.md#s19), [S20](../../bom/sources.md#s20), and
[S22](../../bom/sources.md#s22) remain in the register as historical options;
they are not current baseline purchases. Catalog links and price proxies are
not approved suppliers or delivered quotes.

[↑ Back to document overview](workshop.md#document-overview)


## Interfaces with other scopes

- [Propulsion, reductions and brakes](../02-drive-train/propulsion.md)
- [Frame, scissor and spine](../01-structure-and-running-gear/frame.md)
- [Power distribution and enclosures](../05-power-cables-and-electronics/power-distribution.md)
- [Safety controls and sensors](../06-safety-controls-and-sensors/safety-controls.md)

[↑ Back to document overview](workshop.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: loose-handling

**07.01 Loose transport straps and service supports**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| MNT-004 - Transport tie-down straps (2 each) | N/A / R |
| MNT-006 - Machine service supports (2 each) | N/A / R |
| **Module subtotal** | N/A |

### Cost: bench-fixture

**07.02 Bench fixture and guards**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| TST-001 - Guarded bench fixture steel (20 kg) | €70.00 / A |
| TST-002 - Fixture feet anchors and fasteners (1 set) | €30.00 / A |
| TST-003 - Fixture guarding and protective screen (1 m2) | €35.00 / A |
| **Module subtotal** | €135.00 |

### Cost: bench-tools

**07.04 Meters instruments hand tools and crimp tooling**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| TST-010 - DC-capable clamp meter (1 each) | €100.00 / A |
| TST-011 - Infrared spot thermometer (1 each) | €50.00 / A |
| TST-013 - Torque wrench (1 set) | N/A / R |
| TST-014 - Insulated hand tools (1 set) | N/A / R |
| TST-015 - Cable crimp tool dies and continuity accessories (1 set) | N/A / R |
| **Module subtotal** | €150.00 |

### Cost: consumables

**07.05 Fabrication consumables and initial spares**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| CON-001 - Coated welding electrode allowance (1 lot) | €30.00 / A |
| CON-003 - Cutting grinding and drilling consumables (1 lot) | €40.00 / A |
| CON-004 - Thread locking sealant and grease (1 lot) | N/A / R |
| CON-005 - Initial electrical and mechanical spares (1 lot) | €100.00 / A |
| **Module subtotal** | €170.00 |

### Cost: ppe-support

**07.06 PPE deferred fire provision and cleaning supplies**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| CON-006 - Non-welding starter PPE allowance (1 set) | €100.00 / A |
| CON-009 - Deferred general workshop fire equipment allowance (1 set) | €60.00 / A |
| CON-010 - Cleaning and inspection kit (1 set) | N/A / R |
| **Module subtotal** | €160.00 |

| Scope total | Total (both variants) |
| --- | ---: |
| **All items owned by this scope** | €615.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](workshop.md#document-overview)
