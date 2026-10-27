# Cables, connectors and harnesses

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Cost allowance and release requirements for high-current power
harnesses, signal wiring, connectors, shielding, routing, and strain relief.
The [specification and inspection section](cables-connectors.md#specification-and-inspection-requirements)
defines evidence still needed; exact wire sizes, connector part numbers, and
acceptance limits remain unqualified.

**Contents:** [Requirements](cables-connectors.md#specification-and-inspection-requirements) ·
[Sourcing](cables-connectors.md#sourcing) ·
[Interfaces](cables-connectors.md#interfaces-with-other-scopes) ·
[Itemized costs](cables-connectors.md#detailed-module-costs)

**Related:** [BOM overview](../chassis-bom.md#scope-and-decisions) ·
[Power cable and electronics costs](../cost-breakdown.md#power-cables-and-electronics) ·
[Cost ledger](../chassis-bom.csv) ·
[Build checklist](../chassis-build-requirements.md) ·
[Supplier register](sources.md#source-register)

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

[S07](sources.md#s07).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](cables-connectors.md#document-overview)


## Interfaces with other scopes

- [Electronics, power distribution and safety](electronics.md)
- [Powered width adjustment](width-adjustment.md)
- [Batteries, enclosures and charging](batteries.md)

[↑ Back to document overview](cables-connectors.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: power-cables

**High-current cable**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| PWR-008 - High-current cable (10 m) | €90.00 / A | €90.00 / A |
| **Module subtotal** | €90.00 | €90.00 |

### Cost: power-connectors

**Power lugs connectors and terminal insulation**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| PWR-009 - Power cable lugs (24 each) | €48.00 / A | €48.00 / A |
| PWR-010 - High-current sealed connector (4 pair) | €100.00 / A | €100.00 / A |
| PWR-011 - Power insulation heat-shrink and terminal boots (1 lot) | €20.00 / A | €20.00 / A |
| **Module subtotal** | €168.00 | €168.00 |

### Cost: signal-cables

**Control and communications cables**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| PWR-017 - Low-voltage control wire (50 m) | €40.00 / A | €40.00 / A |
| PWR-018 - Shielded communications cable (15 m) | €45.00 / A | €45.00 / A |
| **Module subtotal** | €85.00 | €85.00 |

### Cost: signal-connectors

**Signal connectors conduit clips and labels**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| PWR-019 - Sealed signal connectors (12 pair) | €60.00 / A | €60.00 / A |
| PWR-020 - Conduit loom P-clips ties and wire labels (1 lot) | €35.00 / A | €35.00 / A |
| **Module subtotal** | €95.00 | €95.00 |

| Scope total | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **All items owned by this scope** | €438.00 | €438.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](cables-connectors.md#document-overview)
