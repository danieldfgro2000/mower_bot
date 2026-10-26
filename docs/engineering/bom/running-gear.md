# Tracks and running gear

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**On this page:** [Itemized costs](running-gear.md#detailed-module-costs) ·
[Requirements](running-gear.md#specification-and-inspection-requirements) ·
[Sourcing](running-gear.md#sourcing) · [Interfaces](running-gear.md#interfaces-with-other-scopes)

**BOM documents:** [BOM overview](../chassis-bom.md) ·
[Structure and running gear totals](../cost-breakdown.md#structure-and-running-gear)

**Related records:** [Cost ledger](../chassis-bom.csv) ·
[Build checklist](../chassis-build-requirements.md) ·
[Supplier register](sources.md#source-register)

Track selection, matched sprockets, rollers, tensioners, axles and guides.

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: tracks

**Rubber tracks**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| RUN-001 - Rubber track 200x72x36 (2 each) | €280.00 / A | €280.00 / A |
| **Module subtotal** | €280.00 | €280.00 |

### Cost: track-hardware

**Sprockets idlers rollers and tensioners**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| RUN-002 - Track drive sprocket and hub (2 each) | €180.00 / A | €180.00 / A |
| RUN-003 - Front idler assembly (2 each) | €150.00 / A | €150.00 / A |
| RUN-004 - Lower support roller (8 each) | €200.00 / A | €200.00 / A |
| RUN-005 - Upper return guide roller (2 each) | €40.00 / A | €40.00 / A |
| RUN-006 - Track tension adjuster (2 each) | €90.00 / A | €90.00 / A |
| **Module subtotal** | €660.00 | €660.00 |

### Cost: track-support

**Track axles bearings guides and scrapers**

| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |
| --- | ---: | ---: |
| RUN-007 - Undercarriage axle stock and spacers (2 pod set) | €90.00 / A | €90.00 / A |
| RUN-008 - Undercarriage sealed bearings and seals (12 each) | €144.00 / A | €144.00 / A |
| RUN-009 - Track retention guides and scrapers (2 pod set) | €50.00 / A | €50.00 / A |
| **Module subtotal** | €284.00 | €284.00 |

| Scope total | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **All items owned by this scope** | €1,224.00 | €1,224.00 |
<!-- END GENERATED: details -->

## Sourcing

[S01](sources.md#s01) · [S02](sources.md#s02) · [S03](sources.md#s03) · [S06](sources.md#s06).

Catalog links and price proxies are not approved suppliers or delivered quotes.

## Specification and inspection requirements

All specifications are **HOLD**. Checks describe evidence still required, not
completed tests. Cost-ledger ranges are inclusive.

### PS01: Rubber tracks

**Cost-ledger coverage:** RUN-001:RUN-001

**Required purchasing/manufacturing definition:** Matched 200 x 72 x 36 track MPN,
guide-lug profile, internal width, sprocket engagement, load/speed/duty limits,
compound, tension specification and replacement availability; S01/S02 remain leads

**Receiving or first-article evidence:** Identity and dimensional match to supplier
drawings; condition and batch; compatibility with the selected complete undercarriage

### PS02: Sprockets, rollers and tensioners

**Cost-ledger coverage:** RUN-002:RUN-006

**Required purchasing/manufacturing definition:** Sprocket tooth count/profile, pitch
geometry, bore/key/hub; idler and roller diameters, flanges, axle interfaces and
capacities; tensioner stroke, adjustment/retention and track sag method

**Receiving or first-article evidence:** Matched kit contents; drawing-based
dimensional/alignment report; approved tension/retention and rolling checks under a
separately authorized plan

### PS03: Axles, bearings and track guides

**Cost-ledger coverage:** RUN-007:RUN-009

**Required purchasing/manufacturing definition:** Axle grades, diameters/fits, bearing
IDs, seals/lubrication, spacers and axial retention; scraper/guide clearances through
track movement; remove kit overlap

**Receiving or first-article evidence:** Material/part identity, fits and retained
assembly; no binding or prohibited track contact against reviewed limits

## Interfaces with other scopes

- [Propulsion, reductions and brakes](propulsion.md)
- [Frame, scissor and spine](frame.md)
