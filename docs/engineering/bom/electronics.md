# Electronics, power distribution and safety

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Cost allowances and unqualified requirements for switchgear,
power distribution, independent stopping, operator control, sensors, and
logging. The [requirements section](electronics.md#specification-and-inspection-requirements)
links each item family to evidence still needed. The listed examples are not
selected or safety-qualified components.

**Navigate:** [Requirements](electronics.md#specification-and-inspection-requirements) ·
[Sourcing](electronics.md#sourcing) · [Interfaces](electronics.md#interfaces-with-other-scopes) ·
[Itemized costs](electronics.md#detailed-module-costs) |
[BOM estimate](../chassis-bom.md#scope-and-decisions) ·
[Power cost totals](../cost-breakdown.md#power-cables-and-electronics) ·
[Safety cost totals](../cost-breakdown.md#safety-controls-and-sensors) ·
[Ledger](../chassis-bom.csv) · [Release checklist](../chassis-build-requirements.md) ·
[Source register](sources.md#source-id-lookup)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS21: Main fuses, disconnects and contactors

**Cost-ledger coverage:** PWR-001:PWR-005

**Required purchasing/manufacturing definition:** Fuse time-current curve, DC breaking
capacity and fault coordination; holder/disconnect DC ratings; contactor
make/break/duty/coil ratings at full bus voltage and current; feedback and suppression
compatible with stop timing

**Receiving or first-article evidence:** Exact MPN/certificates where required;
schematic/rating review against pack fault current; assembly polarity, tightening and
feedback records; welded-contact fault response evidence

### PS22: Precharge and discharge

**Cost-ledger coverage:** PWR-006:PWR-007

**Required purchasing/manufacturing definition:** Controller input capacitance and
charging limits; precharge resistance/energy/duty and relay sequence; discharge energy,
component ratings, voltage-test points and isolation criteria

**Receiving or first-article evidence:** Calculation and schematic review; documented
voltage/time measurements and failure responses under authorized energizing; no assumed
safe discharge interval

### PS24: Control supplies and branch protection

**Cost-ledger coverage:** PWR-012:PWR-014

**Required purchasing/manufacturing definition:** Actual control-rail/load budget
including brakes, safety coils and startup loads; DC/DC input range/isolation/thermal
derating and grounding; branch fuse/wire coordination and brownout behavior

**Receiving or first-article evidence:** Rail and isolation design review; supply
identity and authorized load/brownout evidence; control power loss cannot create an
automatic restart

### PS25: Printed enclosures and cable glands

**Cost-ledger coverage:** PWR-015:PWR-016

**Required purchasing/manufacturing definition:** Enclosure CAD/revision, resin grade
and batch, print orientation/walls/infill/process, heat/UV/flame suitability, gland
cable diameter ranges, vent/drain and sealing strategy

**Receiving or first-article evidence:** First-article dimensions and print inspection;
material/process record, cable retention and approved temperature/ingress evidence; no
IP rating inferred from nominal filament type

### PS27: Thermal paths and enclosure hardware

**Cost-ledger coverage:** PWR-021:PWR-024

**Required purchasing/manufacturing definition:** Heat-flow/loss budget,
backplate/spreader material/thickness/contact area, thermal interface, gasket
compression, lid fastener spacing and insert retention at service temperature

**Receiving or first-article evidence:** Assembly flatness/interface and fastener
inspection; thermal and insert-retention evidence on actual printed configuration; no
enclosure thermal/ingress rating claimed before qualification

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

[↑ Back to document overview](electronics.md#document-overview)


## Sourcing

[S06](sources.md#s06) · [S07](sources.md#s07) · [S08](sources.md#s08) · [S09](sources.md#s09) · [S18](sources.md#s18).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](electronics.md#document-overview)


## Interfaces with other scopes

- [Cables, connectors and harnesses](cables-connectors.md)
- [Propulsion, reductions and brakes](propulsion.md)
- [Powered width adjustment](width-adjustment.md)

[↑ Back to document overview](electronics.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: switchgear

**Main fuses disconnects contactors and feedback**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-001 - DC main fuse (2 each) | €50.00 / A |
| PWR-002 - Touch-protected main fuse holder (2 each) | €50.00 / A |
| PWR-003 - DC service disconnect (2 each) | €110.00 / A |
| PWR-004 - Monitored DC contactor provision (4 each) | €440.00 / A |
| PWR-005 - Contactor feedback and coil protection provision (4 each) | €60.00 / A |
| **Module subtotal** | €710.00 |

### Cost: precharge

**Precharge discharge and voltage-test hardware**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-006 - Pre-charge relay resistor and mounting (2 pod set) | €70.00 / A |
| PWR-007 - Controlled discharge and voltage-test provision (2 pod set) | €20.00 / A |
| **Module subtotal** | €90.00 |

### Cost: control-supplies

**Control DC/DC logic supplies and branch protection**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-012 - Protected traction-to-control DC/DC converter (2 each) | €180.00 / A |
| PWR-013 - Logic step-down supply (2 each) | €30.00 / A |
| PWR-014 - Low-voltage fuse blocks fuses and terminals (2 pod set) | €50.00 / A |
| **Module subtotal** | €260.00 |

### Cost: enclosures

**Electronics enclosures glands cooling and mounting**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-015 - Filament for DIY electronics enclosures and cable covers (2 kg) | €50.00 / A |
| PWR-016 - Cable glands vent and strain relief (1 lot) | €35.00 / A |
| PWR-021 - Controller heat spreaders and thermal interface (2 pod set) | €50.00 / A |
| PWR-022 - DIY enclosure mounting backplates (2 each) | €20.00 / A |
| PWR-023 - DIY enclosure gaskets and lid fasteners (2 pod set) | €16.00 / A |
| PWR-024 - Threaded inserts for printed enclosures (2 pod set) | €10.00 / A |
| **Module subtotal** | €181.00 |

### Cost: stop-controls

**Independent safety relay E-stops and reset controls**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-001 - Independent safety relay or controller allowance (1 set) | €300.00 / A |
| SAF-002 - Machine emergency-stop assembly (2 each) | €70.00 / A |
| SAF-003 - Manual reset enable and status controls (1 set) | €45.00 / A |
| **Module subtotal** | €415.00 |

### Cost: remote

**Industrial operator remote and stop provision**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-004 - Industrial remote transmitter receiver and stop provision (1 set) | €1,500.00 / A |
| **Module subtotal** | €1,500.00 |

### Cost: control-boards

**Local control boards communications and service display**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-005 - Local non-safety control board (2 each) | €50.00 / A |
| SAF-006 - Isolated control communications interfaces (2 each) | €40.00 / A |
| SAF-008 - Service display USB interface and connectors (1 set) | €30.00 / A |
| **Module subtotal** | €120.00 |

### Cost: status

**Status beacon and buzzer**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-007 - Status beacon and buzzer (1 set) | €30.00 / A |
| **Module subtotal** | €30.00 |

### Cost: tilt-interlocks

**Tilt sensing and pod or guard interlocks**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| SAF-009 - Tilt and rollover sensing provision (1 set) | €120.00 / A |
| SAF-010 - Pod disconnect and guard interlock provision (1 set) | €80.00 / A |
| **Module subtotal** | €200.00 |

### Cost: drive-sensors

**Drive current voltage temperature and speed sensors**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| INS-001 - Isolated DC current transducer (2 each) | €100.00 / A |
| INS-002 - Isolated pack-voltage measurement (2 each) | €40.00 / A |
| INS-003 - Temperature probes and harnesses (8 each) | €40.00 / A |
| INS-004 - Output shaft speed sensor and target (2 each) | €60.00 / A |
| **Module subtotal** | €240.00 |

### Cost: logging

**Data logger storage and reader**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| INS-005 - Non-safety test data logger (1 set) | €60.00 / A |
| INS-006 - Logger storage and reader (1 set) | €15.00 / A |
| **Module subtotal** | €75.00 |

| Scope total | Total (both variants) |
| --- | ---: |
| **All items owned by this scope** | €3,821.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](electronics.md#document-overview)
