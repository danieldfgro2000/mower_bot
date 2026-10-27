# Safety controls and sensors

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; unqualified requirements. No procurement,
fabrication, energizing, or operation is authorized.

**Summary:** Module 06 covers independent stopping, operator control,
interlocks, status, instrumentation, and logging. The requirements identify
evidence still needed; listed examples do not establish a qualified machine
safety system.

**Navigate:** [Requirements](safety-controls.md#specification-and-inspection-requirements) ·
[Sourcing](safety-controls.md#sourcing) ·
[Interfaces](safety-controls.md#interfaces-with-other-scopes) ·
[Itemized costs](safety-controls.md#detailed-module-costs) |
[Chassis BOM](../../bom/chassis-bom.md#scope-and-decisions) ·
[Module cost totals](../../cost-breakdown.md#06--safety-controls-and-sensors) ·
[Ledger](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md) ·
[Supplier register](../../bom/sources.md#source-id-lookup) ·
[Module 06 overview](README.md)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS28: Independent stopping and remote control

**Cost-ledger coverage:** SAF-001:SAF-004

**Required purchasing/manufacturing definition:** Hazard-derived independent stop
architecture and required safety performance; exact relay/controller and remote
variants, EU radio configuration, channels/outputs/reset/heartbeat logic; machine stop
locations

**Receiving or first-article evidence:** Approved safety requirements and schematic,
configuration/certificate applicability review, measured complete-path
stop/link-loss/reset evidence; component certification is not machine certification

### PS29: Normal control and diagnostics

**Cost-ledger coverage:** SAF-005:SAF-008

**Required purchasing/manufacturing definition:** Exact boards/interfaces, isolation,
bus termination, supply and connector maps, firmware/configuration revision, diagnostic
indications and service-port access

**Receiving or first-article evidence:** Hardware identity, traceable
firmware/configuration and communications/diagnostic checks; normal controller remains
outside sole authority for safety

### PS30: Tilt sensing and interlocks

**Cost-ledger coverage:** SAF-009:SAF-010

**Required purchasing/manufacturing definition:** Tilt/interlock purpose, mounting,
range/accuracy and fault detection; configuration-specific thresholds and stop/hold
response; guard/pod-disconnect interlock contacts and bypass prevention

**Receiving or first-article evidence:** Approved hazard-derived thresholds and
calibration/fault evidence; sensor orientation and interlock installation records; no
arbitrary 40-degree trip threshold

### PS31: Installed instrumentation and logging

**Cost-ledger coverage:** INS-001:INS-006

**Required purchasing/manufacturing definition:** Current/voltage/temperature/speed
measurement range, isolation, uncertainty, bandwidth, sensor mounting and scaling;
logger channels, timestamps/sample rate, storage/fault behavior and data export

**Receiving or first-article evidence:** Sensor/calibration identities, end-to-end
scaling and channel mapping, logging completeness and missing-data indication; logger
not a safety substitute

[↑ Back to document overview](safety-controls.md#document-overview)

## Sourcing

[S07](../../bom/sources.md#s07) ·
[S08](../../bom/sources.md#s08) ·
[S09](../../bom/sources.md#s09).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](safety-controls.md#document-overview)

## Interfaces with other scopes

- [Power distribution and enclosures](../05-power-cables-and-electronics/power-distribution.md)
- [Cables, connectors and harnesses](../05-power-cables-and-electronics/cables-connectors.md)
- [Propulsion, reductions and brakes](../02-drive-train/propulsion.md)
- [Batteries and charging](../04-battery-and-charging/batteries.md)
- [Workshop, bench equipment and service supplies](../07-workshop-and-support/workshop.md)

[↑ Back to document overview](safety-controls.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: stop-controls

**06.01 Independent safety relay E-stops and reset controls**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-001 - Independent safety relay or controller allowance (1 set) | €300.00 / A |
| SAF-002 - Machine emergency-stop assembly (2 each) | €70.00 / A |
| SAF-003 - Manual reset enable and status controls (1 set) | €45.00 / A |
| **Module subtotal** | €415.00 |

### Cost: remote

**06.02 Industrial operator remote and stop provision**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-004 - Industrial remote transmitter receiver and stop provision (1 set) | €1,500.00 / A |
| **Module subtotal** | €1,500.00 |

### Cost: control-boards

**06.03 Local control boards communications and service display**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-005 - Local non-safety control board (2 each) | €50.00 / A |
| SAF-006 - Isolated control communications interfaces (2 each) | €40.00 / A |
| SAF-008 - Service display USB interface and connectors (1 set) | €30.00 / A |
| **Module subtotal** | €120.00 |

### Cost: status

**06.04 Status beacon and buzzer**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-007 - Status beacon and buzzer (1 set) | €30.00 / A |
| **Module subtotal** | €30.00 |

### Cost: tilt-interlocks

**06.05 Tilt sensing and pod or guard interlocks**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-009 - Tilt and rollover sensing provision (1 set) | €120.00 / A |
| SAF-010 - Pod disconnect and guard interlock provision (1 set) | €80.00 / A |
| **Module subtotal** | €200.00 |

### Cost: drive-sensors

**06.06 Drive current voltage temperature and speed sensors**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| INS-001 - Isolated DC current transducer (2 each) | €100.00 / A |
| INS-002 - Isolated pack-voltage measurement (2 each) | €40.00 / A |
| INS-003 - Temperature probes and harnesses (8 each) | €40.00 / A |
| INS-004 - Output shaft speed sensor and target (2 each) | €60.00 / A |
| **Module subtotal** | €240.00 |

### Cost: logging

**06.07 Data logger storage and reader**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| INS-005 - Non-safety test data logger (1 set) | €60.00 / A |
| INS-006 - Logger storage and reader (1 set) | €15.00 / A |
| **Module subtotal** | €75.00 |

| Scope total | Total (both variants) |
| --- | ---: |
| **All items owned by this scope** | €2,580.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](safety-controls.md#document-overview)
