# Cables, connectors and harnesses

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Cost allowance and release requirements for high-current power
harnesses, signal wiring, connectors, shielding, routing, and strain relief.
The [specification and inspection section](cables-connectors.md#specification-and-inspection-requirements)
defines evidence still needed; exact wire sizes, connector part numbers, and
acceptance limits remain unqualified.

**Navigate:** [Requirements](cables-connectors.md#specification-and-inspection-requirements) ·
[Sourcing](cables-connectors.md#sourcing) ·
[Interfaces](cables-connectors.md#interfaces-with-other-scopes) ·
[Itemized costs](cables-connectors.md#detailed-module-costs) |
[Chassis BOM](../../bom/chassis-bom.md#scope-and-decisions) ·
[Cost totals](../../cost-breakdown.md#05--power-cables-and-electronics) ·
[Ledger](../../bom/chassis-bom.csv) ·
[Release checklist](../../chassis-build-requirements.md) ·
[Supplier register](../../bom/sources.md#source-id-lookup) ·
[Module 05 overview](README.md)

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS23: High-current harness

**Cost-ledger coverage:** PWR-008:PWR-011

**Required purchasing/manufacturing definition:** Cable
section/insulation/temperature/flex class, lengths and derating; lug/terminal/stud
compatibility, connector complete mating BOM and full-voltage DC rating; crimp tooling
and terminal insulation

**Receiving or first-article evidence:** Harness drawing/cut list, crimp process
evidence and specified pull checks, continuity/polarity, strain relief and tightening
records; no universal wire size or fuse rating inferred from motor kW

### PS26: Signal harness and communications

**Cost-ledger coverage:** PWR-017:PWR-020

**Required purchasing/manufacturing definition:** Signal wire size, shielding/bonding,
topology/termination, connector pin maps and unused-cavity seals; moving-loop bend
radius/flex life, clips/labels and protected service loops

**Receiving or first-article evidence:** Pin-to-pin record, shield/ground inspection,
full-travel routing check and defined communications fault evidence; separate safety and
normal control as designed

[↑ Back to document overview](cables-connectors.md#document-overview)


## Sourcing

[S07](../../bom/sources.md#s07).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](cables-connectors.md#document-overview)


## Interfaces with other scopes

- [Power distribution and enclosures](power-distribution.md)
- [Safety controls and sensors](../06-safety-controls-and-sensors/safety-controls.md)
- [Powered width adjustment](../03-width-adjustment/width-adjustment.md)
- [Batteries, enclosures and charging](../04-battery-and-charging/batteries.md)

[↑ Back to document overview](cables-connectors.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: power-cables

**05.01 High-current cable**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-008 - High-current cable (10 m) | €90.00 / A |
| **Module subtotal** | €90.00 |

### Cost: power-connectors

**05.02 Power lugs connectors and terminal insulation**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-009 - Power cable lugs (24 each) | €48.00 / A |
| PWR-010 - High-current sealed connector (4 pair) | €100.00 / A |
| PWR-011 - Power insulation heat-shrink and terminal boots (1 lot) | €20.00 / A |
| **Module subtotal** | €168.00 |

### Cost: signal-cables

**05.03 Control and communications cables**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-017 - Low-voltage control wire (50 m) | €40.00 / A |
| PWR-018 - Shielded communications cable (15 m) | €45.00 / A |
| **Module subtotal** | €85.00 |

### Cost: signal-connectors

**05.04 Signal connectors conduit clips and labels**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| PWR-019 - Sealed signal connectors (12 pair) | €60.00 / A |
| PWR-020 - Conduit loom P-clips ties and wire labels (1 lot) | €35.00 / A |
| **Module subtotal** | €95.00 |

| Scope total | Total (both variants) |
| --- | ---: |
| **All items owned by this scope** | €438.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](cables-connectors.md#document-overview)
