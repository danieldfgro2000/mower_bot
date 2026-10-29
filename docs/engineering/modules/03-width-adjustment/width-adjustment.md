# Powered width adjustment

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** A reused 12 V worm-drive motor is proposed to drive a screw and
change pod spacing. Follow the motor through the screw, scissor pivots, and
holding mechanism; loads, feedback accuracy, and motion limits remain open.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Fit / next component |
| --- | --- | --- | --- |
| [Windshield/wiper motor](width-adjustment.md#ps09-reused-wiper-motor) | Owner-reported 12 V worm drive; exact model and duty unverified | [Reused-cost treatment](width-adjustment.md#0301-width-motor-screw-bearings-mounts-and-guard) · [Known motor data](width-adjustment.md#donor-motor-and-allowance) | [Coupling, screw and supports](width-adjustment.md#ps10-screw-drive-and-supports) |
| [Screw, nut and bearings](width-adjustment.md#ps10-screw-drive-and-supports) | No released lead, stroke, fits or thrust rating | [Mechanical allowance](width-adjustment.md#0301-width-motor-screw-bearings-mounts-and-guard) · [Required data](width-adjustment.md#ps10-screw-drive-and-supports) | [Scissor pivots](../01-structure-and-running-gear/frame.md#ps05-scissor-pivots) |
| [12 V converter and reversible driver](width-adjustment.md#ps11-width-drive-power-and-protection) | Allowances, not devices sized from the 3–5 A running estimate | [Power costs](width-adjustment.md#0302-width-converter-driver-and-protected-enable) · [Protection requirements](width-adjustment.md#ps11-width-drive-power-and-protection) | [Traction pack](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) · [Independent enable](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| [Encoder, limits and reference sensor](width-adjustment.md#ps12-width-feedback-and-limits) | Incremental turns-to-width proposal; reference recovery unqualified | [Sensor costs](width-adjustment.md#0303-width-encoder-limits-current-and-reference-sensors) · [Position calculation](width-adjustment.md#position-feedback-and-rolling-speed) | [Screw geometry](width-adjustment.md#ps10-screw-drive-and-supports) · [Hard stops/lock](../01-structure-and-running-gear/frame.md#ps06-width-holding-and-hard-stops) |
| [Harness and screw guard](width-adjustment.md#ps13-width-harness-and-screw-guard) | Local moving harness/guard, separate from main scissor guards | [Harness cost](width-adjustment.md#0304-width-actuator-harness-and-strain-relief) · [Guard allowance](width-adjustment.md#0301-width-motor-screw-bearings-mounts-and-guard) · [Requirements](width-adjustment.md#ps13-width-harness-and-screw-guard) | [Signal routing](../05-power-cables-and-electronics/cables-connectors.md#ps26-signal-harness-and-communications) |

**Further detail:** [Adjustment concept](width-adjustment.md#powered-rolling-width-adjustment) ·
[Holding and stopping](width-adjustment.md#width-holding-and-stopping) ·
[Release requirements](width-adjustment.md#specification-and-inspection-requirements) ·
[Sourcing](width-adjustment.md#sourcing) ·
[Interfaces](width-adjustment.md#interfaces-with-other-scopes) ·
[Itemized costs](width-adjustment.md#detailed-module-costs) ·
[Procurement and holds](width-adjustment.md#procurement-and-release-holds) ·
[Decision records](width-adjustment.md#decision-records) ·
[Supplier evidence](width-adjustment.md#supplier-evidence)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[All modules](../README.md#module-directory)

## Powered rolling width adjustment

**Detail:** [Motor and allowance](width-adjustment.md#donor-motor-and-allowance) ·
[Position feedback and rolling speed](width-adjustment.md#position-feedback-and-rolling-speed) ·
[Holding and stopping](width-adjustment.md#width-holding-and-stopping).

### Donor motor and allowance

**Follow the mechanical path:** [Motor](width-adjustment.md#ps09-reused-wiper-motor)
→ [coupling, screw and support bearings](width-adjustment.md#ps10-screw-drive-and-supports)
→ [scissor pivots](../01-structure-and-running-gear/frame.md#ps05-scissor-pivots).
The [positive lock and hard stops](../01-structure-and-running-gear/frame.md#ps06-width-holding-and-hard-stops)
are a separate unresolved holding interface, not a proven property of the motor.

The mechanism type is **worm-and-wheel reduction (worm drive)**, confirmed by
the user, not by a motor model/datasheet. The reported 12 V / estimated 3–5 A
implies about **36–60 W electrical input while running**. It establishes neither
output torque nor starting/stall current, continuous duty, or holding capability.
Do not rate the converter, reversing driver, fuse, or wiring from 5 A alone.
The wiper motor's original park circuit must not create unintended actuation.

The [width-drive cost lines (WID-001–014)](width-adjustment.md#detailed-module-costs)
budget **€407** excluding the reused motor's acquisition cost:
screw/nut and support bearings, coupling/mounts, separate traction-to-12 V
supply, reversible driver, protected enable, Hall/optical encoder, two travel
limits, current measurement, reference sensor, harness, and guarding. These
are allowances, not selected ratings or a wiring design.
[Frame hard stops (CHS-011)](../01-structure-and-running-gear/frame.md#ps06-width-holding-and-hard-stops)
and [common scissor guards (CHS-012)](../01-structure-and-running-gear/frame.md#ps07-guards-and-edge-protection)
are budgeted in the frame scope.

### Position feedback and rolling speed

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

### Width holding and stopping

**Holding conflict remains open:** worm geometry alone is not a validated
positive lock under vibration, wear, lubrication, load reversals, or power loss.
The [plan's locking requirement](../../../../plan.md#42-variable-width-scissor-frame)
is retained. The [width-lock provision (CHS-010)](../01-structure-and-running-gear/frame.md#0105-scissor-pivots-locks-and-hard-stops)
is a €48 estimating reserve while that requirement and the
worm-only proposal are reviewed; it is not proof of a feasible automatic lock.
The cost of any different reviewed holding solution must replace that reserve.
Width-drive stopping must remain independent of the normal app/control loop
and coordinated with propulsion; disabling energy is not proof of a held width.

[↑ Back to document overview](width-adjustment.md#powered-width-adjustment)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS09: Reused wiper motor

**Cost-ledger coverage:** WID-001:WID-001

**Part links:** [Motor data](width-adjustment.md#donor-motor-and-allowance) ·
[Reused cost and associated mechanics](width-adjustment.md#0301-width-motor-screw-bearings-mounts-and-guard) ·
[Screw mounting](width-adjustment.md#ps10-screw-drive-and-supports) ·
[Driver and protection](width-adjustment.md#ps11-width-drive-power-and-protection).

**Required purchasing/manufacturing definition:** Donor identity/model, wiring/park
circuit, output rpm/torque versus load, start/stall current, thermal duty, mounting and
gearbox condition; no non-backdrive assumption

**Receiving or first-article evidence:** Recorded condition, pin identification and
supplier data where available; reviewed, separately authorized characterization; 3-5 A
remains an estimate

### PS10: Screw drive and supports

**Cost-ledger coverage:** WID-002:WID-005

**Part links:** [Screw/bearing/mount costs](width-adjustment.md#0301-width-motor-screw-bearings-mounts-and-guard) ·
[Donor motor](width-adjustment.md#ps09-reused-wiper-motor) ·
[Scissor pivots](../01-structure-and-running-gear/frame.md#ps05-scissor-pivots) ·
[Encoder relationship](width-adjustment.md#position-feedback-and-rolling-speed).

**Required purchasing/manufacturing definition:** Screw/nut thread form, lead, diameter,
effective stroke, end machining, thrust/buckling/wear rating and lubrication; support
arrangement, coupling retention and misalignment limits; bracket drawings

**Receiving or first-article evidence:** Drawing-based dimensional report,
support/preload and retention records; measured backlash and referenced stroke; axial
screw load not passed into an unqualified wiper gearbox

### PS11: Width-drive power and protection

**Cost-ledger coverage:** WID-006:WID-008

**Part links:** [Converter/driver costs](width-adjustment.md#0302-width-converter-driver-and-protected-enable) ·
[Motor current/duty data](width-adjustment.md#ps09-reused-wiper-motor) ·
[Pack voltage and BMS](../04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) ·
[Stop-chain interface](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control).

**Required purchasing/manufacturing definition:** Converter full-pack input/transient
range and isolation decision; driver reverse/braking behavior, surge/duty rating,
fuse/cable coordination and independent enable; define loss-of-supply/driver-fault
response

**Receiving or first-article evidence:** Datasheet/configuration match; protection and
stop-interface review; surge/thermal/fault evidence under an authorized plan

### PS12: Width feedback and limits

**Cost-ledger coverage:** WID-009:WID-012

**Part links:** [Feedback/limit costs](width-adjustment.md#0303-width-encoder-limits-current-and-reference-sensors) ·
[Turns-to-width calculation](width-adjustment.md#position-feedback-and-rolling-speed) ·
[Mechanical hard stops](../01-structure-and-running-gear/frame.md#ps06-width-holding-and-hard-stops).

**Required purchasing/manufacturing definition:** Encoder location after slip-prone
coupling where feasible, direction/resolution; independent travel limits and known
reference; current sensor range; geometry-based turns-to-width map, backlash and
lost-reference policy

**Receiving or first-article evidence:** Calibration at defined widths and approach
directions; limit/reference/pulse-loss and jam response evidence; tolerances and trip
thresholds must be set before tests, not inferred afterward

### PS13: Width harness and screw guard

**Cost-ledger coverage:** WID-013:WID-014

**Part links:** [Harness cost](width-adjustment.md#0304-width-actuator-harness-and-strain-relief) ·
[Local guard cost](width-adjustment.md#0301-width-motor-screw-bearings-mounts-and-guard) ·
[Main scissor guards](../01-structure-and-running-gear/frame.md#ps07-guards-and-edge-protection) ·
[Signal connectors/routing](../05-power-cables-and-electronics/cables-connectors.md#ps26-signal-harness-and-communications).

**Required purchasing/manufacturing definition:** Actuator harness wire/contact/seal
schedule, flex routing and strain relief; screw guard geometry and service access
distinct from main scissor guards

**Receiving or first-article evidence:** Pin-to-pin and polarity record; clearance
through full approved travel, no trapping or rubbing; guard attachment inspection

[↑ Back to document overview](width-adjustment.md#powered-width-adjustment)


## Sourcing

[DOLD bearings (S03)](../01-structure-and-running-gear/running-gear.md#s03-dold-bearing-housings) ·
[DOLD mechanical parts (S04)](../../bom/sources.md#s04-dold-mechanical-parts) ·
[Dedeman fabrication supplies (S06)](../../bom/sources.md#s06-dedeman-fabrication-supplies) ·
[RS electrical components (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools) ·
[Owner-reported wiper motor (U01)](width-adjustment.md#u01-owner-reported-windshield-motor).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](width-adjustment.md#powered-width-adjustment)


## Procurement and release holds

Prepared supplier requests and release holds owned by this scope. Sending a request needs separate user approval; every hold is **OPEN**. Shared document control, manufacturing packs and cross-cutting holds stay in the [Chassis Build and Procurement Checklist](../../chassis-build-requirements.md#chassis-build-and-procurement-checklist).

### H03: width holding and adjustment

**Must close before:** Width mechanism fabrication/actuation

**Closure evidence / responsible review role:** Positive-holding conflict resolved
through explicit plan decision and engineering evidence; screw/load/guard/reference/stop
definitions; mechanical and safety review

[↑ Back to document overview](width-adjustment.md#powered-width-adjustment)


## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Frame load path and positive lock | [Width holding and hard stops](../01-structure-and-running-gear/frame.md#ps06-width-holding-and-hard-stops) |
| Moving signal wiring | [Signal harness and communications](../05-power-cables-and-electronics/cables-connectors.md#ps26-signal-harness-and-communications) |
| Control power and branch protection | [Supply requirements](../05-power-cables-and-electronics/power-distribution.md#ps24-control-supplies-and-branch-protection) |
| Coordinated stopping and restart inhibition | [Independent stopping](../06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| Allowed geometry and stability evidence | [Width and slope design consequences](../../width-and-slope-sizing.md#consequences-for-the-design-and-bom) |

[↑ Back to document overview](width-adjustment.md#powered-width-adjustment)

## Detailed module costs

**Cost context:** [Width-adjustment totals](../../cost-breakdown.md#03--width-adjustment) ·
[Ledger and assumptions](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md).

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
Item links open the purchasing and inspection requirements.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

<a id="cost-width-mechanics"></a>

### 03.01 Width motor screw bearings mounts and guard

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [WID-001 - Existing 12 V windshield motor with worm reduction](width-adjustment.md#ps09-reused-wiper-motor) (1 each) | N/A / R |
| [WID-002 - Screw and mating nut mechanism](width-adjustment.md#ps10-screw-drive-and-supports) (1 set) | €60.00 / A |
| [WID-003 - Screw thrust and radial bearings](width-adjustment.md#ps10-screw-drive-and-supports) (1 set) | €35.00 / A |
| [WID-004 - Motor-to-screw coupling and adapter](width-adjustment.md#ps10-screw-drive-and-supports) (1 set) | €25.00 / A |
| [WID-005 - Actuator brackets and bearing mounts](width-adjustment.md#ps10-screw-drive-and-supports) (1 set) | €15.00 / A |
| [WID-014 - Actuator screw guard and local cable cover materials](width-adjustment.md#ps13-width-harness-and-screw-guard) (1 set) | €20.00 / A |
| **Module subtotal** | €155.00 |

<a id="cost-width-power"></a>

### 03.02 Width converter driver and protected enable

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [WID-006 - Traction-pack-to-12 V actuator converter](width-adjustment.md#ps11-width-drive-power-and-protection) (1 each) | €90.00 / A |
| [WID-007 - Reversible DC motor driver](width-adjustment.md#ps11-width-drive-power-and-protection) (1 each) | €35.00 / A |
| [WID-008 - Actuator branch fuse and independent enable provision](width-adjustment.md#ps11-width-drive-power-and-protection) (1 set) | €30.00 / A |
| **Module subtotal** | €155.00 |

<a id="cost-width-sensors"></a>

### 03.03 Width encoder limits current and reference sensors

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [WID-009 - Hall or optical turn encoder and target](width-adjustment.md#ps12-width-feedback-and-limits) (1 set) | €25.00 / A |
| [WID-010 - Width end-of-travel limit switch](width-adjustment.md#ps12-width-feedback-and-limits) (2 each) | €24.00 / A |
| [WID-011 - Width-drive current sensing provision](width-adjustment.md#ps12-width-feedback-and-limits) (1 set) | €20.00 / A |
| [WID-012 - Known-position reference sensor](width-adjustment.md#ps12-width-feedback-and-limits) (1 set) | €8.00 / A |
| **Module subtotal** | €77.00 |

<a id="cost-width-harness"></a>

### 03.04 Width actuator harness and strain relief

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [WID-013 - Width mechanism harness and strain relief](width-adjustment.md#ps13-width-harness-and-screw-guard) (1 set) | €20.00 / A |
| **Module subtotal** | €20.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €407.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](width-adjustment.md#powered-width-adjustment)


## Decision records

Dated owner decisions and qualification loops for this scope. Read each date with its later corrections; a decision closes an estimating assumption, not a component qualification. Cross-module decisions remain in [BOM feedback](../../bom/feedback.md#feedback-decisions).

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
remove the [plan's positive-locking requirement](../../../../plan.md#42-variable-width-scissor-frame)**.
The [width-lock provision (CHS-010)](../01-structure-and-running-gear/frame.md#0105-scissor-pivots-locks-and-hard-stops) retains a €48 pin-cost
reserve, not a selected or integrated automatic locking design. Holding remains a
release blocker.

[↑ Back to document overview](width-adjustment.md#powered-width-adjustment)


## Supplier evidence

Dated supplier claims for this scope, recorded under the [common sourcing weights](../../bom/sources.md#common-sourcing-weights). Catalog listings are leads, not quotes or qualification. Source IDs stay stable for the [cost ledger](../../bom/chassis-bom.csv).

<a id="u01"></a>

### U01: Owner-reported windshield motor

**Source / source type:** Owner feedback, 2026-10-26; existing inventory, not an online
purchase source

**Evidence or limitation:** Available windshield motor; owner reports 12 V, estimates
3–5 A, and confirms worm-and-wheel type. Model, current measurement, torque, speed,
duty, and non-backdrive evidence not supplied. Purchase cost N/A (already owned); not free capability
validation.

**Engineering detail:** [Reused wiper-motor qualification](width-adjustment.md#ps09-reused-wiper-motor).

[↑ Back to document overview](width-adjustment.md#powered-width-adjustment)
