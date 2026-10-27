# Tracks and running gear

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Cost allowances and release requirements for tracks, sprockets,
rollers, tensioners, axles, bearings, and guides. The nominal track dimensions
are a plan target, not a qualified undercarriage selection. Current concept:
spring-loaded upper-return support rollers push outward to tension the track;
their layout and settings remain open. See the
[specification and inspection requirements](running-gear.md#specification-and-inspection-requirements)
for the evidence needed to select them.

**Navigate:** [Requirements](running-gear.md#specification-and-inspection-requirements) ·
[Sourcing](running-gear.md#sourcing) ·
[Interfaces](running-gear.md#interfaces-with-other-scopes) ·
[Itemized costs](running-gear.md#detailed-module-costs) |
[Pod-fit sketch](../../cad/module-01-track-pod-fit.scad) ·
[Chassis BOM](../../bom/chassis-bom.md#scope-and-decisions) ·
[Structure cost totals](../../cost-breakdown.md#01--structure-and-running-gear) ·
[Ledger](../../bom/chassis-bom.csv) · [Release checklist](../../chassis-build-requirements.md) ·
[Supplier register](../../bom/sources.md#source-id-lookup) ·
[Module 01 overview](README.md)

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
capacities. Owner-selected concept: spring-load the upper-return support rollers
to push outward and tension the track. Define roller count/spacing, whether they
move together or independently, contact profile and usable stroke, spring
type/rate/preload, travel stops and retention, service method, track-tension
measurement, and allowable track/bearing/frame loads. Verify the moving envelope
against the battery, carrier, guards and battery-removal path.

**Owner lower-roller layout:** Four support rollers per track, evenly spaced along
the lower run, as selected for this study. Diameter, width, material, axle/bearing
interfaces and load capacity remain unselected; the layout is not a load or clearance
validation. See the [pod-fit sketch](../../cad/module-01-track-pod-fit.scad).

**Drive drum study:** The 350 mm outside-diameter drum is the track-drive output.
The [HPM5000B planetary-in-drum study](../02-drive-train/propulsion.md#hpm5000b-planetary-in-drum-study)
shows one possible reduction layout only; S01 track engagement geometry and the
drum's sprocket profile remain unverified.

**Owner tensioner concept:** Fabricate the spring take-up using motorcycle fork
and spring hardware; mount each roller at the fork's normal wheel axle position
and clamp the fork to the frame. This is a concept only, not a selected or
qualified fork. Confirm the fork's available travel, spring/preload behavior,
side-load capacity, sealing, stops, retention and service method against the
track loads. The [Cohidrex idler lead](../../bom/sources.md#s26) is listed for Trabber
tracks and is not confirmed to fit S01.

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

[↑ Back to document overview](running-gear.md#document-overview)


## Sourcing

[S01](../../bom/sources.md#s01) · [S02](../../bom/sources.md#s02) · [S03](../../bom/sources.md#s03) · [S06](../../bom/sources.md#s06) · [S26 idler lead](../../bom/sources.md#s26).

Catalog links and price proxies are not approved suppliers or delivered quotes.

[↑ Back to document overview](running-gear.md#document-overview)


## Interfaces with other scopes

- [Propulsion, reductions and brakes](../02-drive-train/propulsion.md)
- [Frame, scissor and spine](frame.md)

[↑ Back to document overview](running-gear.md#document-overview)

## Detailed module costs

<!-- BEGIN GENERATED: details -->
Generated from the [cost ledger](../../bom/chassis-bom.csv).
Quantities are cumulative Stage 2; prices are line totals, not unit prices.
C = calculated reference; A = allowance; I = included; R = reused.
N/A never means an unknown purchase is free.

### Cost: tracks

**01.01 Rubber tracks**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| RUN-001 - Rubber track 200x72x36 (2 each) | €280.00 / A |
| **Module subtotal** | €280.00 |

### Cost: track-hardware

**01.02 Sprockets idlers rollers and tensioners**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| RUN-002 - Track drive sprocket and hub (2 each) | €180.00 / A |
| RUN-003 - Front idler assembly (2 each) | €150.00 / A |
| RUN-004 - Lower support roller (8 each) | €200.00 / A |
| RUN-005 - Upper return guide roller (2 each) | €40.00 / A |
| RUN-006 - Track tension adjuster (2 each) | €90.00 / A |
| **Module subtotal** | €660.00 |

### Cost: track-support

**01.03 Track axles bearings guides and scrapers**

| Item / cumulative quantity | Total / basis (both variants) |
| --- | ---: |
| RUN-007 - Undercarriage axle stock and spacers (2 pod set) | €90.00 / A |
| RUN-008 - Undercarriage sealed bearings and seals (12 each) | €144.00 / A |
| RUN-009 - Track retention guides and scrapers (2 pod set) | €50.00 / A |
| **Module subtotal** | €284.00 |

| Scope total | Total (both variants) |
| --- | ---: |
| **All items owned by this scope** | €1,224.00 |
<!-- END GENERATED: details -->

[↑ Back to document overview](running-gear.md#document-overview)
