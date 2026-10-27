# Power distribution and enclosures

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Cost allowances and unqualified requirements for switchgear,
precharge, control supplies, power distribution, and electronics enclosures.
The [requirements section](power-distribution.md#specification-and-inspection-requirements)
links each item family to evidence still needed. The listed examples are not
selected or qualified components.

**Navigate:** [Requirements](power-distribution.md#specification-and-inspection-requirements) ·
[Sourcing](power-distribution.md#sourcing) · [Interfaces](power-distribution.md#interfaces-with-other-scopes) ·
[Itemized costs](power-distribution.md#detailed-module-costs) |
[Chassis BOM](../../bom/chassis-bom.md#scope-and-decisions) ·
[Cost totals](../../cost-breakdown.md#05--power-cables-and-electronics) ·
[Ledger](../../bom/chassis-bom.csv) · [Release checklist](../../chassis-build-requirements.md) ·
[Supplier register](../../bom/sources.md#source-id-lookup) ·
[Module 05 overview](README.md)

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

[↑ Back to document overview](power-distribution.md#document-overview)


## Sourcing

[S06](../../bom/sources.md#s06) · [S07](../../bom/sources.md#s07) ·
[S18](../../bom/sources.md#s18).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](power-distribution.md#document-overview)


## Interfaces with other scopes

- [Cables, connectors and harnesses](cables-connectors.md)
- [Safety controls and sensors](../06-safety-controls-and-sensors/safety-controls.md)
- [Propulsion, reductions and brakes](../02-drive-train/propulsion.md)
- [Batteries and charging](../04-battery-and-charging/batteries.md)

[↑ Back to document overview](power-distribution.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: switchgear

**05.05 Main fuses disconnects contactors and feedback**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-001 - DC main fuse (2 each) | €50.00 / A |
| PWR-002 - Touch-protected main fuse holder (2 each) | €50.00 / A |
| PWR-003 - DC service disconnect (2 each) | €110.00 / A |
| PWR-004 - Monitored DC contactor provision (4 each) | €440.00 / A |
| PWR-005 - Contactor feedback and coil protection provision (4 each) | €60.00 / A |
| **Module subtotal** | €710.00 |

### Cost: precharge

**05.06 Precharge discharge and voltage-test hardware**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-006 - Pre-charge relay resistor and mounting (2 pod set) | €70.00 / A |
| PWR-007 - Controlled discharge and voltage-test provision (2 pod set) | €20.00 / A |
| **Module subtotal** | €90.00 |

### Cost: control-supplies

**05.07 Control DC/DC logic supplies and branch protection**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-012 - Protected traction-to-control DC/DC converter (2 each) | €180.00 / A |
| PWR-013 - Logic step-down supply (2 each) | €30.00 / A |
| PWR-014 - Low-voltage fuse blocks fuses and terminals (2 pod set) | €50.00 / A |
| **Module subtotal** | €260.00 |

### Cost: enclosures

**05.08 Electronics enclosures glands cooling and mounting**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-015 - Filament for DIY electronics enclosures and cable covers (2 kg) | €50.00 / A |
| PWR-016 - Cable glands vent and strain relief (1 lot) | €35.00 / A |
| PWR-021 - Controller heat spreaders and thermal interface (2 pod set) | €50.00 / A |
| PWR-022 - DIY enclosure mounting backplates (2 each) | €20.00 / A |
| PWR-023 - DIY enclosure gaskets and lid fasteners (2 pod set) | €16.00 / A |
| PWR-024 - Threaded inserts for printed enclosures (2 pod set) | €10.00 / A |
| **Module subtotal** | €181.00 |

| Scope total | Total (both variants) |
| --- | ---: |
| **All items owned by this scope** | €1,241.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](power-distribution.md#document-overview)
