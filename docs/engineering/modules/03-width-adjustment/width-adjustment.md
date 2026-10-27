# Powered width adjustment

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** The proposed rolling width-adjustment concept, its cost allowance,
and the requirements for drive, feedback, limits, holding, and guarding. The
12 V worm-drive donor motor is owner-reported; load, duty, holding, and motion
limits are not established. See the
[mechanism detail](width-adjustment.md#powered-rolling-width-adjustment) and
[specification requirements](width-adjustment.md#specification-and-inspection-requirements).

**Navigate:** [Adjustment concept](width-adjustment.md#powered-rolling-width-adjustment) ·
[Requirements](width-adjustment.md#specification-and-inspection-requirements) ·
[Sourcing](width-adjustment.md#sourcing) ·
[Interfaces](width-adjustment.md#interfaces-with-other-scopes) ·
[Itemized costs](width-adjustment.md#detailed-module-costs) |
[Chassis BOM](../../bom/chassis-bom.md#scope-and-decisions) ·
[Width-adjustment cost totals](../../cost-breakdown.md#03--width-adjustment) ·
[Ledger](../../bom/chassis-bom.csv) · [Release checklist](../../chassis-build-requirements.md) ·
[Supplier register](../../bom/sources.md#source-id-lookup) ·
[Module 03 overview](README.md)

## Powered rolling width adjustment

The mechanism type is **worm-and-wheel reduction (worm drive)**, confirmed by
the user, not by a motor model/datasheet. The reported 12 V / estimated 3–5 A
implies about **36–60 W electrical input while running**. It establishes neither
output torque nor starting/stall current, continuous duty, or holding capability.
Do not rate the converter, reversing driver, fuse, or wiring from 5 A alone.
The wiper motor's original park circuit must not create unintended actuation.

WID-001–014 budget **€407** excluding the reused motor's acquisition cost:
screw/nut and support bearings, coupling/mounts, separate traction-to-12 V
supply, reversible driver, protected enable, Hall/optical encoder, two travel
limits, current measurement, reference sensor, harness, and guarding. These
are allowances, not selected ratings or a wiring design. Frame hard stops are
already in CHS-011; common scissor guarding remains in CHS-012.

For screw lead `L` in mm/revolution and referenced **screw** turns `N`,
`x = x_reference + N × L`; actual width is `W = f(x)` from the released scissor
geometry, **not generally a linear width-per-turn factor**. A motor-shaft sensor
also needs the exact reduction/coupling relationship and a way to detect slip.
Count direction, pulses/revolution, backlash, reference validity, and missed
pulses must be addressed. Lost reference inhibits automatic width control;
reboot/reconnection cannot automatically resume adjustment or initiate homing.

The desired rolling speed cannot be calculated from 12 V / 3–5 A or a width
setpoint alone. It needs actual screw speed under load, geometry-dependent
width rate, track/sprocket geometry, traction feedback, and acceptable lateral
loads demonstrated under authorized testing. No numeric safe speed, width
range, or automatic adjustment behavior is currently implemented or approved.
The [width/slope screen](../../width-and-slope-sizing.md) records the 400/1,600 mm
study targets and why 40° site inclines cannot be accepted from width alone.

**Holding conflict remains open:** worm geometry alone is not a validated
positive lock under vibration, wear, lubrication, load reversals, or power loss.
The [plan's locking requirement](../../../../plan.md#42-variable-width-scissor-frame)
is retained. CHS-010 is a €48 estimating reserve while that requirement and the
worm-only proposal are reviewed; it is not proof of a feasible automatic lock.
The cost of any different reviewed holding solution must replace that reserve.
Width-drive stopping must remain independent of the normal app/control loop
and coordinated with propulsion; disabling energy is not proof of a held width.

[↑ Back to document overview](width-adjustment.md#document-overview)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS09: Reused wiper motor

**Cost-ledger coverage:** WID-001:WID-001

**Required purchasing/manufacturing definition:** Donor identity/model, wiring/park
circuit, output rpm/torque versus load, start/stall current, thermal duty, mounting and
gearbox condition; no non-backdrive assumption

**Receiving or first-article evidence:** Recorded condition, pin identification and
supplier data where available; reviewed, separately authorized characterization; 3-5 A
remains an estimate

### PS10: Screw drive and supports

**Cost-ledger coverage:** WID-002:WID-005

**Required purchasing/manufacturing definition:** Screw/nut thread form, lead, diameter,
effective stroke, end machining, thrust/buckling/wear rating and lubrication; support
arrangement, coupling retention and misalignment limits; bracket drawings

**Receiving or first-article evidence:** Drawing-based dimensional report,
support/preload and retention records; measured backlash and referenced stroke; axial
screw load not passed into an unqualified wiper gearbox

### PS11: Width-drive power and protection

**Cost-ledger coverage:** WID-006:WID-008

**Required purchasing/manufacturing definition:** Converter full-pack input/transient
range and isolation decision; driver reverse/braking behavior, surge/duty rating,
fuse/cable coordination and independent enable; define loss-of-supply/driver-fault
response

**Receiving or first-article evidence:** Datasheet/configuration match; protection and
stop-interface review; surge/thermal/fault evidence under an authorized plan

### PS12: Width feedback and limits

**Cost-ledger coverage:** WID-009:WID-012

**Required purchasing/manufacturing definition:** Encoder location after slip-prone
coupling where feasible, direction/resolution; independent travel limits and known
reference; current sensor range; geometry-based turns-to-width map, backlash and
lost-reference policy

**Receiving or first-article evidence:** Calibration at defined widths and approach
directions; limit/reference/pulse-loss and jam response evidence; tolerances and trip
thresholds must be set before tests, not inferred afterward

### PS13: Width harness and screw guard

**Cost-ledger coverage:** WID-013:WID-014

**Required purchasing/manufacturing definition:** Actuator harness wire/contact/seal
schedule, flex routing and strain relief; screw guard geometry and service access
distinct from main scissor guards

**Receiving or first-article evidence:** Pin-to-pin and polarity record; clearance
through full approved travel, no trapping or rubbing; guard attachment inspection

[↑ Back to document overview](width-adjustment.md#document-overview)


## Sourcing

[S03](../../bom/sources.md#s03) · [S04](../../bom/sources.md#s04) · [S06](../../bom/sources.md#s06) · [S07](../../bom/sources.md#s07) · [U01](../../bom/sources.md#u01).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](width-adjustment.md#document-overview)


## Interfaces with other scopes

- [Frame, scissor and spine](../01-structure-and-running-gear/frame.md)
- [Cables, connectors and harnesses](../05-power-cables-and-electronics/cables-connectors.md)
- [Power distribution and enclosures](../05-power-cables-and-electronics/power-distribution.md)
- [Safety controls and sensors](../06-safety-controls-and-sensors/safety-controls.md)

[↑ Back to document overview](width-adjustment.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: width-mechanics

**03.01 Width motor screw bearings mounts and guard**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| WID-001 - Existing 12 V windshield motor with worm reduction (1 each) | N/A / R |
| WID-002 - Screw and mating nut mechanism (1 set) | €60.00 / A |
| WID-003 - Screw thrust and radial bearings (1 set) | €35.00 / A |
| WID-004 - Motor-to-screw coupling and adapter (1 set) | €25.00 / A |
| WID-005 - Actuator brackets and bearing mounts (1 set) | €15.00 / A |
| WID-014 - Actuator screw guard and local cable cover materials (1 set) | €20.00 / A |
| **Module subtotal** | €155.00 |

### Cost: width-power

**03.02 Width converter driver and protected enable**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| WID-006 - Traction-pack-to-12 V actuator converter (1 each) | €90.00 / A |
| WID-007 - Reversible DC motor driver (1 each) | €35.00 / A |
| WID-008 - Actuator branch fuse and independent enable provision (1 set) | €30.00 / A |
| **Module subtotal** | €155.00 |

### Cost: width-sensors

**03.03 Width encoder limits current and reference sensors**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| WID-009 - Hall or optical turn encoder and target (1 set) | €25.00 / A |
| WID-010 - Width end-of-travel limit switch (2 each) | €24.00 / A |
| WID-011 - Width-drive current sensing provision (1 set) | €20.00 / A |
| WID-012 - Known-position reference sensor (1 set) | €8.00 / A |
| **Module subtotal** | €77.00 |

### Cost: width-harness

**03.04 Width actuator harness and strain relief**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| WID-013 - Width mechanism harness and strain relief (1 set) | €20.00 / A |
| **Module subtotal** | €20.00 |

| Scope total | Total (both variants) |
| --- | ---: |
| **All items owned by this scope** | €407.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](width-adjustment.md#document-overview)
