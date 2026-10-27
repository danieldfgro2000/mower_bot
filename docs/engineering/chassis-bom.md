# Chassis BOM

<a id="document-overview"></a>

**Document:** MBR-ENG-BOM-001 | **Revision:** L | **Revised:** 2026-10-26

**Status:** Costed engineering estimate; **not released for purchase,
fabrication, or operation**.

**Summary:** This estimate covers **Stage 1 — bench propulsion prototype** and
**Stage 2 — rolling two-pod chassis**. The 48 V and 72 V columns are alternative
configurations, not additive purchases. **Stage 3 — supervised mower
integration** and later autonomy are excluded. The summary below shows module
costs and the indicative build budget; [BOM Cost Breakdown](cost-breakdown.md)
and the [Cost ledger](chassis-bom.csv) hold the line-level detail. Module links
open technical scopes. Use the
[Chassis Build and Procurement Checklist](chassis-build-requirements.md) for
evidence, inspections, and release holds.

**Evidence and upkeep:** [Supplier register](bom/sources.md) ·
[Feedback decisions](bom/feedback.md) ·
[Cost update guide](bom/updating-linked-costs.md)

## Estimate at a glance

Module labels link to their engineering scope. The estimate is cumulative
through Stage 2; it is not a per-pod or per-motor price.

<!-- BEGIN GENERATED: overview -->
| Module | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **[01 — Structure](bom/frame.md) and [01 — Running gear](bom/running-gear.md)** | €2,213.00 | Same as 48 V |
| **[02 — Drive train](bom/propulsion.md)** | €3,781.66 | €3,520.00 |
| **[03 — Width adjustment](bom/width-adjustment.md)** | €407.00 | Same as 48 V |
| **[04 — Battery and charging](bom/batteries.md)** | €3,148.16 | €5,698.48 |
| **[05 — Power cables](bom/cables-connectors.md) and [05 — Electronics](bom/electronics.md)** | €1,679.00 | Same as 48 V |
| **[06 — Safety controls and sensors](bom/electronics.md)** | €2,580.00 | Same as 48 V |
| **[07 — Workshop and support](bom/workshop.md)** | €4,514.00 | Same as 48 V |
| **All listed materials/equipment** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: overview -->

### Build budget

This adds non-material allowances and contingency to the module costs.
Materials/equipment includes installed parts, reusable bench equipment, and
support supplies. The HPM5000B candidate is excluded; it has not replaced the
costed planetary drive.

<!-- BEGIN GENERATED: budget -->
| Budget line | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| Materials/equipment | €18,322.82 | €20,611.48 |
| Freight/import/brokerage provision | €500.00 | €700.00 |
| Outsourced precision machining provision | €350.00 | €650.00 |
| DIY fabrication/printing energy | €30.00 | Same as 48 V |
| Instrument calibration/setup service | €250.00 | Same as 48 V |
| Owner fabrication labor | N/A - owner supplied | Same as 48 V |
| **Budget before contingency** | €19,452.82 | €22,241.48 |
| Uncertainty contingency (20%) | €3,890.56 | €4,448.30 |
| **Indicative build budget** | €23,343.38 | €26,689.78 |
<!-- END GENERATED: budget -->

**Find:** [Scope and decisions](chassis-bom.md#scope-and-decisions) ·
[Configuration comparison](chassis-bom.md#propulsionbattery-comparison) ·
[BOM scope directory](chassis-bom.md#bom-by-scope) ·
[Cost interpretation](chassis-bom.md#material-and-equipment-totals) ·
[Estimate rules](chassis-bom.md#estimate-rules) ·
[Evidence and maintenance](chassis-bom.md#evidence-and-maintenance)

[↑ Back to document overview](chassis-bom.md#document-overview)

## Scope and decisions

The estimate follows two build stages: **Stage 1 — bench propulsion
prototype**, where one drive is tested on a bench, then **Stage 2 — rolling
two-pod chassis**, where both pods, the scissor frame, and spine are assembled.
Stage 2 quantities are cumulative, not additional to Stage 1. Bench equipment
is retained separately, not installed on the chassis. These stages do not cover
the complete mower product. The [plan](../../plan.md) remains the product
authority; its 48 V / approximately 2 kW continuous-per-drive baseline has not
changed.

**Included:** running gear; pod, scissor, and spine materials; width locks and
guards; propulsion and brake provisions; batteries/BMS and chargers;
protection and wiring; independent safety provisions; operator remote,
logging, and sensors; handling; bench load/measurement equipment; initial
consumables and support materials.

**Excluded:** **Stage 3 — supervised mower integration**, including the DAC
9100 mower and its mount/cutting guards; conveyor, trailer, fruit drum,
RTK/autonomy equipment and subscriptions; road transport vehicle; workshop
rent; insurance; certification; professional design/risk assessment; software
development; field commissioning; major workshop machinery; and a complete
spare track, motor, or battery. An existing programming computer and normal
workshop infrastructure are assumed available. The confirmed welder and 3D
printer are not priced as new purchases. The four-column cage is excluded.
Outsourced machining, fabrication energy, calibration, freight, and uncertainty
are shown separately rather than hidden in the material BOM.

The DIY enclosure allowance covers electronics and cable covers, **not an
approved printed structural part or traction-battery containment design**.
Polymer temperature/UV/flame performance, thermal paths, fastener retention,
glands, sealing, and electrical protection remain to be reviewed. No IP or
washdown rating is claimed. Battery enclosures remain separately budgeted
pending their own mechanical/environmental design.

[↑ Back to document overview](chassis-bom.md#document-overview)

## Propulsion/battery comparison

The 48 V and 72 V estimates are alternatives, not a selected configuration.
See [propulsion, reductions and brakes](bom/propulsion.md) and
[batteries and charging](bom/batteries.md) for their technical requirements.

<!-- BEGIN GENERATED: alternatives -->
| Alternative (excluded from totals) | Unit reference | Cumulative reference |
| --- | ---: | ---: |
| [ALT-DRV-001: Golden Motor HPM5000B bare motor 48 V advertised 5 kW](bom/propulsion-alternatives.csv) | €482.36 | €964.72 |
<!-- END GENERATED: alternatives -->

This candidate could replace DRV-001; it is not an additive purchase or an
approved change from the approximately 2 kW-per-drive baseline. The estimate
still costs the baseline planetary package, not an HPM5000B/custom
planetary-in-drum package; the latter's gearbox is unpriced. References exclude
freight, duty, and brokerage; see the
[supplier and integration details](bom/propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals).

### Powered rolling width adjustment

For actuator, screw, feedback, holding, and stopping requirements, see
[powered width adjustment](bom/width-adjustment.md).

[↑ Back to document overview](chassis-bom.md#document-overview)

## BOM by scope

Each scope owns its cost-line IDs, specifications, inspection evidence, and
interfaces. Shared items have one primary owner; cross-links do not add
quantities or costs. Use the module links in the estimate table for the scope
overview, or open its specification section directly:

| Scope | Covers | Requirements and inspection |
| --- | --- | --- |
| [01.01–01.03 Tracks and running gear](bom/running-gear.md) | Tracks, sprockets, rollers, tensioners, axles, bearings, and guides | [Specification](bom/running-gear.md#specification-and-inspection-requirements) |
| [01.04–01.07 Frame, scissor, and spine](bom/frame.md) | Stock, weldments, pivots, width holding, guards, and lifting points | [Specification](bom/frame.md#specification-and-inspection-requirements) |
| [02.01–02.05 Drive train](bom/propulsion.md) | Motors, matched controllers, reductions, shafts, and brakes | [Specification](bom/propulsion.md#specification-and-inspection-requirements) |
| [03.01–03.04 Powered width adjustment](bom/width-adjustment.md) | Motor, screw, driver, feedback, limits, and guard | [Specification](bom/width-adjustment.md#specification-and-inspection-requirements) |
| [04.01–04.04 Batteries and charging](bom/batteries.md) | Pack alternatives, BMS, enclosures, chargers, and interlocks | [Specification](bom/batteries.md#specification-and-inspection-requirements) |
| [05.01–05.04 Cables, connectors, and harnesses](bom/cables-connectors.md) | Power and signal wiring, mating connectors, shielding, and routing | [Specification](bom/cables-connectors.md#specification-and-inspection-requirements) |
| [05.05–05.08 Electronics and distribution](bom/electronics.md) | Switchgear, supplies, enclosures, and power distribution | [Specification](bom/electronics.md#specification-and-inspection-requirements) |
| [06.01–06.07 Safety controls and sensors](bom/electronics.md) | Independent stop hardware, operator control, sensors, and logging | [Specification](bom/electronics.md#specification-and-inspection-requirements) |
| [07.01–07.06 Workshop and support](bom/workshop.md) | Bench equipment, tools, handling gear, consumables, spares, and PPE | [Specification](bom/workshop.md#specification-and-inspection-requirements) |

Shared references: [Supplier register](bom/sources.md) ·
[Feedback and qualification loops](bom/feedback.md) ·
[Chassis Build and Procurement Checklist](chassis-build-requirements.md) ·
[Cost update guide](bom/updating-linked-costs.md).

[↑ Back to document overview](chassis-bom.md#document-overview)

## Material and equipment totals

The module summary above is for scanning. For category detail, line totals,
and the installed/bench/support split, use the generated
[BOM Cost Breakdown](cost-breakdown.md). The [Cost ledger](chassis-bom.csv) is the
authoritative source for quantities, scenario costs, basis codes, and
assumptions. `I` and `R` rows do not add separate purchase costs; unknown
qualification exposure is not treated as free.

### Readiness snapshot

Price evidence and engineering approval are separate. No line is released for
procurement or manufacture by this package.

<!-- BEGIN GENERATED: readiness -->
| Cost basis: lines / EUR | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| Calculated public-price references (C) | 4 / €6,009.82 | N/A - no lines |
| Engineering allowances (A) | 119 / €12,313.00 | 128 / €20,611.48 |
| Included / no separate purchase (I) | 5 / N/A | N/A - no lines |
| Reused inventory (R) | 1 / N/A | Same as 48 V |
| **Total (129 lines)** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: readiness -->

All 129 lines map to **39 specification families** across the scope documents.
All remain on hold pending component and design qualification. This package
does not contain released cut lists, harness drawings, approved supplier lists,
numeric inspection limits, or signed first-article records.

<a id="purchase-totals"></a>

### Installed, bench, and support totals

The [purchase totals in BOM Cost Breakdown](cost-breakdown.md#purchase-totals)
separate installed-machine materials, reusable bench equipment, and loose
handling/consumables/support. The width-adjustment estimate includes a reused
donor motor: its purchase cost is N/A because it is already owned, not because
a replacement would be free. Battery totals include enclosures and the
conditional tax reserve; power distribution includes protection and
converters; bench equipment includes the load fixture and instruments.
Consumables/support includes initial spares and PPE. The €224 of loose slings,
straps, shackles, and service supports is classified as support; this changes
neither the purchase total nor stage acquisitions.

### Stage acquisitions — no double-counting

<!-- BEGIN GENERATED: phases -->
| Acquisition stage | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| Stage 1 — bench propulsion prototype | €9,240.91 | €10,385.24 |
| Stage 2 — rolling two-pod chassis (additional purchases only) | €9,081.91 | €10,226.24 |
| **Stages 1–2 cumulative** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: phases -->

This assumes one instrumented bench setup is reused, not a dynamometer per
pod. **Stage 1** includes protection and physical stopping provisions; later
safety work does not permit deferring essential safety. **Stage 2** includes
the industrial remote, which is not priced into the maintained-action bench
pendant.

[↑ Back to document overview](chassis-bom.md#document-overview)

## Estimate rules

- Numeric CSV amounts are **EUR cash-budget estimates** to two decimals. This
  calculation format does not claim cent-level accuracy or landed quotations.
- **C — calculated reference:** derived from a public price with disclosed
  currency/tax assumptions. **A — allowance:** a provisional engineering
  budget, **not a supplier price**. **I — included / no separate purchase:**
  the function is budgeted in another line; the separate item does not apply
  in that scenario. **R — reused:** owner-reported inventory; no new purchase
  applies, but capability and condition still require qualification.
- **N/A is not a price or an unknown estimate.** In CSV cost columns it is
  permitted only for `I` or `R`, with a reason in the assumption field. Unit
  and extended cost must both be `N/A` for that scenario. Exclude these entries
  from cash-cost sums; do not substitute a guessed price. Required purchases
  still have numeric `C` or `A` estimates. Unpriced design/qualification
  exposures remain disclosed separately.
- Quantities remain numeric: Stage 1 quantity `0` means acquisition is
  deferred until Stage 2. DRV-007–011 quantities apply only to the 72 V external
  reduction; their 48 V costs are `N/A` because DRV-001 budgets planetary
  reduction. WID-001 retains an installed quantity although its purchase cost
  is `N/A`.
- Source IDs resolve to the [Supplier register](bom/sources.md). A category,
  manufacturer page, or price proxy is a sourcing lead, not an exact qualified
  SKU or proof that an allowance can buy it. Most rows are allowances.
- Quantities, steel mass, bearing count, cable lengths, and bought assemblies
  are provisional. They are **not** dimensions, conductor sizes, load ratings,
  or a fabrication/harness cut list. A quoted roller/gearbox kit may include
  bearings, shafts, or brakes budgeted separately; remove overlapping
  allowances at quotation, not by assuming they are included now.
- The [ECB reference, 2026-10-26](https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml)
  is **€1 = US$1.1188 = RON 5.3473**; USD amounts use `USD / 1.1188`.
  Bank/card spreads are uncertainty, not supplier prices.
- The [Romanian standard VAT reference](https://europa.eu/youreurope/business/finance-and-tax/vat/vat-rules-rates/index_en.htm)
  is **21%**. USD motor/controller/brake references add 21% for planning.
  Allowances are intended as tax-inclusive cash provisions; no VAT recovery
  is assumed. Import duty, freight VAT, and actual seller tax treatment require
  checkout/RFQ.
- Elker's €1,019.90 displayed price has an unconfirmed tax basis in retrieved
  content. BAT-001 conservatively adds a **conditional 21% reserve**, producing
  €1,234.08 per pack. If applicable VAT is already included, remove that
  reserve: **€428.36 reduction for two packs**. Do not add VAT again to this row.
- The TZI €1,735 listing uses conditional **0% VAT** for eligible solar
  installations; do not apply that exemption to this machine. The 72 V battery
  allowance includes 21% but is an extrapolation, not a quoted product.
- The **20% contingency** is a separate budget reserve, not a statistical
  confidence interval or a guarantee that design changes or quotations fit it.

### Budget assumptions

The build-budget table is at the top. Its provisions are not material prices:

- **Materials/equipment:** sum of the Cost ledger.
- **Freight/import/brokerage:** an allowance, not a landed quote or statutory
  duty calculation; pack transport and Romania delivery must be quoted.
- **Owner fabrication labor:** no purchased labor applies because the owner
  performs fabrication. Effort and engineering qualification are not valued.
- **Outsourced precision machining:** provision for shaft/hub/bore or other
  precision work not confirmed as DIY; the 72 V scenario allows additional
  reduction work. Obtain a quote.
- **DIY fabrication/printing energy:** provisional electricity allowance,
  not materials or purchased tools.
- **Instrument calibration/setup:** allowance, not completed calibration.
- **Budget before contingency:** sum of the preceding provisions.
- **Uncertainty contingency:** 20% of that subtotal.
- **Indicative build budget:** still excludes professional design,
  certification, and commissioning.

Do not present the indicative budget as a quoted complete-machine price. Do not
compare the historical €5,000 six-component basket with a full chassis,
independent safety, and newly purchased dynamometer as though their scopes
match. Reusing all bench equipment would remove €3,720 of listed acquisitions
only if suitable equipment and access are confirmed; measurements are still
required.

[↑ Back to document overview](chassis-bom.md#document-overview)

## Evidence and maintenance

### Updating linked costs

Use the [cost update guide](bom/updating-linked-costs.md) to edit the owning
CSVs, regenerate linked tables, and verify freshness and references. Edit
inputs, not generated tables. A cost update does not authorize a hardware
selection, purchase, fabrication, or operation.

### Supplier register

Use the [Supplier register](bom/sources.md) for source IDs and
dated evidence. Catalog leads are not component qualification.

### Feedback and qualification loops

See [feedback and qualification loops](bom/feedback.md) for dated decisions,
required inputs, closure evidence, and authorization boundaries.

[↑ Back to document overview](chassis-bom.md#document-overview)
