# Safety controls and sensors

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; unqualified requirements. No procurement,
fabrication, energizing, or operation is authorized.

**Summary:** The app is intended for normal commands; an independent hardware
stop is still required. Stop hardware, control boards, interlocks, and sensors
remain unqualified. Follow each device to the power, brake, or measurement
interface it must serve.

## Parts at a glance

| Part to inspect | Current choice / status | Cost and specifications | Connects to / use |
| --- | --- | --- | --- |
| [E-stop, safety relay and reset](safety-controls.md#ps28-independent-stopping-and-normal-control) | One E-stop purchase budgeted for reuse across stages; final architecture/count open | [Stop-control costs](safety-controls.md#0601-independent-safety-relay-e-stops-and-reset-controls) · [Safe-state requirements](safety-controls.md#independent-stop-definition-and-evidence) | [Contactors](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) · [Brake behavior](../02-drive-train/propulsion.md#ps15-mechanical-brakes) |
| [Normal control boards and diagnostics](safety-controls.md#ps29-normal-control-and-diagnostics) | Boards/interfaces not selected by this BOM; app-only normal-control intent | [Board/display costs](safety-controls.md#0603-local-control-boards-communications-and-service-display) · [Status hardware](safety-controls.md#0604-status-beacon-and-buzzer) · [Required interfaces](safety-controls.md#ps29-normal-control-and-diagnostics) | [Control supplies](../05-power-cables-and-electronics/power-distribution.md#ps24-control-supplies-and-branch-protection) · [Signal harness](../05-power-cables-and-electronics/cables-connectors.md#ps26-signal-harness-and-communications) |
| [Tilt and guard/pod interlocks](safety-controls.md#ps30-tilt-sensing-and-interlocks) | Purpose, thresholds and mounting not qualified | [Interlock costs](safety-controls.md#0605-tilt-sensing-and-pod-or-guard-interlocks) · [Required data](safety-controls.md#ps30-tilt-sensing-and-interlocks) | [Guards](../01-structure-and-running-gear/frame.md#ps07-guards-and-edge-protection) · [Width/slope configurations](../../width-and-slope-sizing.md#lateral-static-tipping-screen) |
| [Current, voltage, temperature and speed sensors](safety-controls.md#ps31-installed-instrumentation-and-logging) | Intended primary measurements; ranges/scaling still open | [Sensor costs](safety-controls.md#0606-drive-current-voltage-temperature-and-speed-sensors) · [Measurement requirements](safety-controls.md#ps31-installed-instrumentation-and-logging) | [Motor/reduction data](../02-drive-train/propulsion.md#ps14-traction-motor-and-controller) · [Bench method](../07-workshop-and-support/workshop.md#test-method-and-evidence) |
| [Logger and storage](safety-controls.md#ps31-installed-instrumentation-and-logging) | Non-safety records, not proof of stopping or torque capability | [Logging costs](safety-controls.md#0607-data-logger-storage-and-reader) · [Channel/timestamp requirements](safety-controls.md#ps31-installed-instrumentation-and-logging) | [Independent clamp-meter check](../07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) |

**Further detail:** [Release requirements](safety-controls.md#specification-and-inspection-requirements) ·
[Owner control and stop intent](safety-controls.md#ps28-independent-stopping-and-normal-control) ·
[Sourcing](safety-controls.md#sourcing) ·
[Interfaces](safety-controls.md#interfaces-with-other-scopes) ·
[Itemized costs](safety-controls.md#detailed-module-costs)

**Related documents:** [Chassis BOM](../../bom/chassis-bom.md) ·
[Module 06 overview](README.md)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS28: Independent stopping and normal control

**Cost-ledger coverage:** SAF-001:SAF-003

**Part links:** [Stop-hardware costs](safety-controls.md#0601-independent-safety-relay-e-stops-and-reset-controls) ·
[Contactor feedback and interruption](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) ·
[Mechanical brake](../02-drive-train/propulsion.md#ps15-mechanical-brakes) ·
[Bench stop placement](../07-workshop-and-support/workshop.md#ps34-bench-fixture-and-controls).

**Detail:** [App and E-stop intent](safety-controls.md#app-and-e-stop-intent) ·
[Braking intent](safety-controls.md#braking-intent) ·
[Independent stop definition and evidence](safety-controls.md#independent-stop-definition-and-evidence).

#### App and E-stop intent

**Owner intent:** Use a mobile app as the only normal operator control. The
owner expects the bot to stop if the app connection is interrupted
and proposes a general emergency stop that interrupts current to all modules.
These are intended behaviors, not verified implementation or safety evidence.
One E-stop assembly is budgeted and intended to be reused from the bench through
individual pod checks to the final bot; no industrial-remote purchase is
included in the current estimate. The required final stop count and placement
remain open.

#### Braking intent

Use a controller-supported motor-braking mode for dynamic
deceleration, through regeneration or another documented reverse-current mode.
Use a mechanical brake on each pod for stationary holding, applied by default
when release power is absent. Field evidence is intended to determine whether
an additional mechanical dynamic brake is needed. This is a design direction,
not a selected or validated stopping system. The
[drive braking direction](../02-drive-train/propulsion.md#owner-braking-direction-2026-10-27)
and [mechanical brake requirements](../02-drive-train/propulsion.md#ps15-mechanical-brakes)
own the drivetrain detail.

#### Independent stop definition and evidence

**Required purchasing/manufacturing definition:** Hazard-derived independent
stop architecture and required safety performance; exact relay/controller,
stop locations, outputs, reset and heartbeat logic; and a reviewed definition
of the safe state when propulsion/implement power is interrupted. Normal
mobile-app control and loss-of-link behavior cannot be the independent stop.
Power interruption alone does not demonstrate that the machine stops or remains
held; brake behavior, stored energy, and safe reset require explicit design.
Define whether the E-stop sequence can use motor braking before isolation; if
the controller, battery path, or its braking mode is unavailable, active motor
braking cannot be assumed. The stationary holding brake is not credited with
stopping a moving bot unless its dynamic-stop rating is established.

**Receiving or first-article evidence:** Approved safety requirements and schematic,
configuration/certificate applicability review, and independently observed
complete-path stop/link-loss/reset evidence. The app/network stop expectation
and general E-stop proposal remain unverified. Motor-braking tests do not alone
resolve controller-fault or power-loss stopping. Component certification is not
machine certification.

### PS29: Normal control and diagnostics

**Cost-ledger coverage:** SAF-005:SAF-008

**Part links:** [Board/display costs](safety-controls.md#0603-local-control-boards-communications-and-service-display) ·
[Beacon/buzzer costs](safety-controls.md#0604-status-beacon-and-buzzer) ·
[Control supply](../05-power-cables-and-electronics/power-distribution.md#ps24-control-supplies-and-branch-protection) ·
[Signal connectors](../05-power-cables-and-electronics/cables-connectors.md#ps26-signal-harness-and-communications).

**Required purchasing/manufacturing definition:** Exact boards/interfaces, isolation,
bus termination, supply and connector maps, firmware/configuration revision, diagnostic
indications and service-port access

**Receiving or first-article evidence:** Hardware identity, traceable
firmware/configuration and communications/diagnostic checks; normal controller remains
outside sole authority for safety

### PS30: Tilt sensing and interlocks

**Cost-ledger coverage:** SAF-009:SAF-010

**Part links:** [Tilt/interlock costs](safety-controls.md#0605-tilt-sensing-and-pod-or-guard-interlocks) ·
[Guard mounting](../01-structure-and-running-gear/frame.md#ps07-guards-and-edge-protection) ·
[Configuration and tipping screen](../../width-and-slope-sizing.md#lateral-static-tipping-screen).

**Required purchasing/manufacturing definition:** Tilt/interlock purpose, mounting,
range/accuracy and fault detection; configuration-specific thresholds and stop/hold
response; guard/pod-disconnect interlock contacts and bypass prevention

**Receiving or first-article evidence:** Approved hazard-derived thresholds and
calibration/fault evidence; sensor orientation and interlock installation records; no
arbitrary 40-degree trip threshold

### PS31: Installed instrumentation and logging

**Cost-ledger coverage:** INS-001:INS-006

**Part links:** [Sensor costs](safety-controls.md#0606-drive-current-voltage-temperature-and-speed-sensors) ·
[Logger costs](safety-controls.md#0607-data-logger-storage-and-reader) ·
[Signal harness](../05-power-cables-and-electronics/cables-connectors.md#ps26-signal-harness-and-communications) ·
[Measurement tools and limitations](../07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools).

**Required purchasing/manufacturing definition:** Current/voltage/temperature/speed
measurement range, isolation, uncertainty, bandwidth, sensor mounting and scaling;
logger channels, timestamps/sample rate, storage/fault behavior and data export

**Receiving or first-article evidence:** Sensor/calibration identities, end-to-end
scaling and channel mapping, logging completeness and missing-data indication; logger
not a safety substitute

[↑ Back to document overview](safety-controls.md#safety-controls-and-sensors)

## Sourcing

[RS controls and sensors (S07)](../../bom/sources.md#s07-rs-electrical-parts-and-tools) ·
[Schneider XPSUAF13AP relay example (S08)](../../bom/sources.md#s08-schneider-xpsuaf13ap-safety-relay-example).

Catalog links and price proxies are not approved suppliers or delivered quotes.
The [Tele Radio Tiger G2 remote family (S09)](../../bom/sources.md#s09-tele-radio-tiger-g2-remote-alternative) remains historical
research; it is not part of the current baseline.

[↑ Back to document overview](safety-controls.md#safety-controls-and-sensors)

## Interfaces with other scopes

| Interface | Owning detail |
| --- | --- |
| Power interruption and contactor feedback | [Main switching and protection](../05-power-cables-and-electronics/power-distribution.md#ps21-main-fuses-disconnects-and-contactors) |
| Control/safety routing and communications | [Signal harness requirements](../05-power-cables-and-electronics/cables-connectors.md#ps26-signal-harness-and-communications) |
| Dynamic braking versus stationary holding | [Owner braking direction](../02-drive-train/propulsion.md#owner-braking-direction-2026-10-27) · [Mechanical brakes](../02-drive-train/propulsion.md#ps15-mechanical-brakes) |
| Charging inhibits motion | [Charging and charge interlocks](../04-battery-and-charging/batteries.md#ps20-charging-and-charge-interlocks) |
| Fixture stop and measurement limitations | [Bench fixture and controls](../07-workshop-and-support/workshop.md#ps34-bench-fixture-and-controls) · [Test method and evidence](../07-workshop-and-support/workshop.md#test-method-and-evidence) |

[↑ Back to document overview](safety-controls.md#safety-controls-and-sensors)

## Detailed module costs

**Cost context:** [Safety/sensing totals](../../cost-breakdown.md#06--safety-controls-and-sensors) ·
[Ledger and assumptions](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md).

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
Item links open the purchasing and inspection requirements.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

<a id="cost-stop-controls"></a>

### 06.01 Independent safety relay E-stops and reset controls

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [SAF-001 - Independent safety relay or controller allowance](safety-controls.md#ps28-independent-stopping-and-normal-control) (1 set) | €300.00 / A |
| [SAF-002 - General emergency-stop assembly reused across build stages](safety-controls.md#ps28-independent-stopping-and-normal-control) (1 each) | €35.00 / A |
| [SAF-003 - Manual reset enable and status controls](safety-controls.md#ps28-independent-stopping-and-normal-control) (1 set) | €45.00 / A |
| **Module subtotal** | €380.00 |

<a id="cost-control-boards"></a>

### 06.03 Local control boards communications and service display

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [SAF-005 - Local non-safety control board](safety-controls.md#ps29-normal-control-and-diagnostics) (2 each) | €50.00 / A |
| [SAF-006 - Isolated control communications interfaces](safety-controls.md#ps29-normal-control-and-diagnostics) (2 each) | €40.00 / A |
| [SAF-008 - Service display USB interface and connectors](safety-controls.md#ps29-normal-control-and-diagnostics) (1 set) | €30.00 / A |
| **Module subtotal** | €120.00 |

<a id="cost-status"></a>

### 06.04 Status beacon and buzzer

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [SAF-007 - Status beacon and buzzer](safety-controls.md#ps29-normal-control-and-diagnostics) (1 set) | €30.00 / A |
| **Module subtotal** | €30.00 |

<a id="cost-tilt-interlocks"></a>

### 06.05 Tilt sensing and pod or guard interlocks

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [SAF-009 - Tilt and rollover sensing provision](safety-controls.md#ps30-tilt-sensing-and-interlocks) (1 set) | €120.00 / A |
| [SAF-010 - Pod disconnect and guard interlock provision](safety-controls.md#ps30-tilt-sensing-and-interlocks) (1 set) | €80.00 / A |
| **Module subtotal** | €200.00 |

<a id="cost-drive-sensors"></a>

### 06.06 Drive current voltage temperature and speed sensors

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [INS-001 - Isolated DC current transducer](safety-controls.md#ps31-installed-instrumentation-and-logging) (2 each) | €100.00 / A |
| [INS-002 - Isolated pack-voltage measurement](safety-controls.md#ps31-installed-instrumentation-and-logging) (2 each) | €40.00 / A |
| [INS-003 - Temperature probes and harnesses](safety-controls.md#ps31-installed-instrumentation-and-logging) (8 each) | €40.00 / A |
| [INS-004 - Output shaft speed sensor and target](safety-controls.md#ps31-installed-instrumentation-and-logging) (2 each) | €60.00 / A |
| **Module subtotal** | €240.00 |

<a id="cost-logging"></a>

### 06.07 Data logger storage and reader

| Item / cumulative quantity | 48 V total / basis |
| --- | ---: |
| [INS-005 - Non-safety test data logger](safety-controls.md#ps31-installed-instrumentation-and-logging) (1 set) | €60.00 / A |
| [INS-006 - Logger storage and reader](safety-controls.md#ps31-installed-instrumentation-and-logging) (1 set) | €15.00 / A |
| **Module subtotal** | €75.00 |

| Scope total | 48 V |
| --- | ---: |
| **All items owned by this scope** | €1,045.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](safety-controls.md#safety-controls-and-sensors)
