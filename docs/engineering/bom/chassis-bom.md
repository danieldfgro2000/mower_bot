# Chassis BOM

<a id="document-overview"></a>

**Document:** MBR-ENG-BOM-001 | **Revision:** N | **Revised:** 2026-10-28

**Status:** Costed engineering estimate; **not released for purchase,
fabrication, or operation**.

**Summary:** Estimate for **Stage 1 — bench propulsion prototype** and
**Stage 2 — rolling two-pod chassis** only, using the active 48 V baseline.
The HPM5000B/EZ-A48500/FDB 13 C components are costed; custom reduction and
brake installation remain **unpriced**. Other alternatives are excluded. Scan the module totals, then use
[component routes](chassis-bom.md#bom-by-scope) to open a part's price,
specifications, and fit. Mower integration and autonomy are excluded; release holds remain open.

**Evidence and upkeep:** [Supplier register](sources.md) ·
[Feedback decisions](feedback.md) ·
[Cost update guide](updating-linked-costs.md)

## Estimate at a glance

Module labels open a parts-at-a-glance view with cost, data, and connection
links. The estimate is cumulative
through Stage 2; it is not a per-pod or per-motor price.

<!-- BEGIN GENERATED: overview -->
| Module | 48 V |
| --- | ---: |
| **[01 — Structure](../modules/01-structure-and-running-gear/frame.md) and [01 — Running gear](../modules/01-structure-and-running-gear/running-gear.md)** | €2,213.00 |
| **[02 — Drive train](../modules/02-drive-train/propulsion.md)** | €2,208.12 |
| **[03 — Width adjustment](../modules/03-width-adjustment/width-adjustment.md)** | €407.00 |
| **[04 — Battery and charging](../modules/04-battery-and-charging/batteries.md)** | €2,416.98 |
| **[05 — Power cables](../modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](../modules/05-power-cables-and-electronics/power-distribution.md)** | €1,679.00 |
| **[06 — Safety controls and sensors](../modules/06-safety-controls-and-sensors/safety-controls.md)** | €1,045.00 |
| **[07 — Workshop and support](../modules/07-workshop-and-support/workshop.md)** | €615.00 |
| **All listed materials/equipment** | €10,584.10 |
<!-- END GENERATED: overview -->

### Build budget

This adds non-material allowances and contingency to the module costs.
Materials/equipment includes installed parts, reusable bench equipment, and
support supplies. The
[HPM5000B candidate](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate)
has replaced the former geared-motor reference. The **€1,573.54 materials
reduction is not a like-for-like complete-drive saving**: custom reduction,
brake adaptation/reaction mounting and release-power integration are unpriced.
Generic machining and contingency provisions are not quotes for that missing scope.

<!-- BEGIN GENERATED: budget -->
| Budget line | 48 V |
| --- | ---: |
| Materials/equipment | €10,584.10 |
| Freight/import/brokerage provision | €500.00 |
| Outsourced precision machining provision | €350.00 |
| DIY fabrication/printing energy | €30.00 |
| Owner fabrication labor | N/A - owner supplied |
| **Budget before contingency** | €11,464.10 |
| Uncertainty contingency (20%) | €2,292.82 |
| **Indicative build budget** | €13,756.92 |
<!-- END GENERATED: budget -->

**On this page:** [Find a component](chassis-bom.md#bom-by-scope) ·
[Scope and decisions](chassis-bom.md#scope-and-decisions) ·
[Configuration comparison](chassis-bom.md#propulsionbattery-comparison) ·
[Powered width adjustment](chassis-bom.md#powered-rolling-width-adjustment) ·
[Cost interpretation](chassis-bom.md#material-and-equipment-totals) ·
[Estimate rules](chassis-bom.md#estimate-rules) ·
[Evidence and maintenance](chassis-bom.md#evidence-and-maintenance)

[↑ Back to document overview](chassis-bom.md#chassis-bom)

## BOM by scope

**Find the part, then follow its connection.** These routes open component
details directly; no requirement or source code needs to be memorized.
Shared links do not add quantities or costs.

| Part to inspect | Cost and current technical data | Continue to fitting / connections |
| --- | --- | --- |
| [HPM5000B main candidate](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate) — bare motor costed | [Bare-motor price](../modules/02-drive-train/propulsion.md#hpm5000b-purchase-scope-and-price) · [Supplier specifications](../modules/02-drive-train/propulsion.md#hpm5000b-ratings-and-sourcing-limits) | [Motor-to-track mounting](../modules/02-drive-train/propulsion.md#motor-to-track-mounting) |
| EZ-A48500 controller | [Price, ratings and alternatives](../modules/02-drive-train/propulsion.md#ez-a48500-controller-candidate) | [Compatibility and duty](../modules/02-drive-train/propulsion.md#compatibility-and-duty-limitations) |
| Precima FDB 13 C brake | [€159 supplier offer and specifications](../modules/02-drive-train/propulsion.md#precima-fdb-13-c-holding-brake-candidate) | [HPM shaft/mounting mismatch](../modules/02-drive-train/propulsion.md#fdb-13-c-to-hpm5000b-fitment) |
| Former traction package, excluded | [48 V BLDC planetary package](../modules/02-drive-train/propulsion.md#48-v--approximately-2-kw-per-drive) | [Output shafts and bearings](../modules/02-drive-train/propulsion.md#ps16-output-shafts-and-bearings) · [Mounting plates](../modules/01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) |
| Tracks, drum, idlers and rollers | [Running-gear parts, allowances and data](../modules/01-structure-and-running-gear/running-gear.md#parts-at-a-glance) | [Drum engagement](../modules/01-structure-and-running-gear/running-gear.md#drive-drum-study) · [Spring tensioner](../modules/01-structure-and-running-gear/running-gear.md#spring-tensioner-concept) |
| Frame, pivots, locks and guards | [Frame parts and costs](../modules/01-structure-and-running-gear/frame.md#parts-at-a-glance) | [Motor mounting plates](../modules/01-structure-and-running-gear/frame.md#motor-and-reducer-mounting-plates) · [Screw-to-scissor connection](../modules/03-width-adjustment/width-adjustment.md#ps10-screw-drive-and-supports) |
| Width motor, screw, driver and feedback | [Width-drive parts and costs](../modules/03-width-adjustment/width-adjustment.md#parts-at-a-glance) | [Mechanical drive path](../modules/03-width-adjustment/width-adjustment.md#donor-motor-and-allowance) · [Holding and limits](../modules/03-width-adjustment/width-adjustment.md#width-holding-and-stopping) |
| Battery, BMS, enclosure and charger | [Pack choices, prices and specifications](../modules/04-battery-and-charging/batteries.md#parts-at-a-glance) | [Battery-to-pod fit](../modules/04-battery-and-charging/batteries.md#battery-to-pod-fit) · [Charge connector/interlock](../modules/04-battery-and-charging/batteries.md#ps20-charging-and-charge-interlocks) |
| Power/signal cables and connectors | [Harness parts, costs and required data](../modules/05-power-cables-and-electronics/cables-connectors.md#parts-at-a-glance) | [Crimp tools and dies](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) · [Moving width harness](../modules/03-width-adjustment/width-adjustment.md#ps13-width-harness-and-screw-guard) |
| Fuses, contactors, converters and boxes | [Power-distribution parts and costs](../modules/05-power-cables-and-electronics/power-distribution.md#parts-at-a-glance) | [Controller interface](../modules/02-drive-train/propulsion.md#ps14-traction-motor-and-controller) · [Thermal mounting](../modules/05-power-cables-and-electronics/power-distribution.md#ps27-thermal-paths-and-enclosure-hardware) |
| Stop hardware, control boards and sensors | [Controls/sensors, costs and current intent](../modules/06-safety-controls-and-sensors/safety-controls.md#parts-at-a-glance) | [Brake/stop connection](../modules/02-drive-train/propulsion.md#ps15-mechanical-brakes) · [Measurement tools](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) |
| Workshop tools, fixture and service supplies | [Buy/reuse choices and costs](../modules/07-workshop-and-support/workshop.md#parts-at-a-glance) | [Fixture requirements](../modules/07-workshop-and-support/workshop.md#ps34-bench-fixture-and-controls) · [Frame handling points](../modules/01-structure-and-running-gear/frame.md#ps32-installed-lifting-and-recovery-points) |

For approval evidence, use the
[Chassis Build and Procurement Checklist](../chassis-build-requirements.md).
For dated claims or decision history, use the [supplier register](sources.md)
and [feedback record](feedback.md), not a part's short summary alone.

[↑ Back to document overview](chassis-bom.md#chassis-bom)

## Scope and decisions

The estimate follows
[Stage 1 — bench propulsion prototype](../../../plan.md#stage-1--bench-propulsion-prototype),
where one drive is tested on a bench, then
[Stage 2 — rolling two-pod chassis](../../../plan.md#stage-2--rolling-two-pod-chassis),
where both pods, the scissor frame, and spine are assembled.
Stage 2 quantities are cumulative, not additional to Stage 1. Bench equipment
is retained separately, not installed on the chassis. These stages do not cover
the complete mower product. The [plan](../../../plan.md) remains the product
authority; its 48 V / approximately 2 kW continuous-per-drive baseline has not
changed.

**Included:** the [chassis and workshop scopes](chassis-bom.md#bom-by-scope), from
running gear and frame to power, controls, and workshop support. The
[workshop scope](../modules/07-workshop-and-support/workshop.md) includes the
guarded bench fixture, selected tools, handling, consumables, and initial
spares. The baseline has
no dynamometer or direct torque measurement; torque remains pre-calculated and
unmeasured.

**Excluded scope and resources:**

- **Unpriced required drive integration:** custom reduction, motor/brake
  shaft and reaction-flange adaptation, release-power supply/control and
  any additional independently justified stopping hardware. Existing general
  hardware allowances do not establish coverage of these designs.
- **Mower and later attachments:** Stage 3 — supervised mower integration,
  including the [DAC 9100, mounts and cutting guards](../../../plan.md#71-underbody-dac-9100-mower);
  [conveyor](../../../plan.md#72-washable-conveyor),
  [trailer](../../../plan.md#73-passive-trailer),
  [fruit drum](../../../plan.md#74-front-fruit-drum), and
  [RTK/autonomy equipment and subscriptions](../../../plan.md#82-rtk-teach--repeat).
- **Removed options:** [Dynamometer/direct torque measurement and industrial
  operator remote](../modules/07-workshop-and-support/workshop.md#f10-workshop-equipment-test-method-and-mobile-app-control).
  The four-column cage remains excluded by the [machine architecture](../../../plan.md#4-machine-architecture).
- **Professional and commercial work:** design/risk assessment, software
  development, certification, insurance, field commissioning, workshop rent,
  and a road transport vehicle.
- **Infrastructure and major spares:** major workshop machinery and complete
  spare tracks, motors, or batteries. An existing programming computer and
  normal workshop infrastructure are assumed. The confirmed welder/3D printer,
  reported lathe/mill access, and [reused workshop tools](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools)
  are not new purchases.

[Budget allowances](chassis-bom.md#budget-assumptions) separately cover
outsourced machining, fabrication energy, freight, and uncertainty. No separate
calibration-service allowance is included; [measurement evidence requirements](../modules/07-workshop-and-support/workshop.md#test-method-and-evidence)
still apply.

The [DIY enclosure allowance](../modules/05-power-cables-and-electronics/power-distribution.md#ps25-printed-enclosures-and-cable-glands)
covers electronics and cable covers, **not an
approved printed structural part or traction-battery containment design**.
Polymer temperature/UV/flame performance, thermal paths, fastener retention,
glands, sealing, and electrical protection remain to be reviewed. No IP or
washdown rating is claimed.
[Battery enclosures](../modules/04-battery-and-charging/batteries.md#ps19-battery-enclosures-and-restraints)
remain separately budgeted pending their own mechanical/environmental design.

[↑ Back to document overview](chassis-bom.md#chassis-bom)

## Propulsion/battery comparison

The active estimate uses the 48 V drive and two DC HOUSE 51.2 V / 100 Ah
LiFePO4 pack/charger bundles; modest capacity increases such as 105 Ah remain
acceptable alternatives, not extra purchases.
The [owner's retirement decision](../modules/04-battery-and-charging/batteries.md#f12-48-v-battery-baseline-and-scenario-retirement)
removes the former higher-voltage scenario from active inputs and reports.
This is a budget configuration, not hardware approval; nominal voltage is not compatibility.

| Costed scenario | Drive detail | Battery detail |
| --- | --- | --- |
| 48 V / approximately 2 kW per-drive operating target | [HPM5000B](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate), [EZ-A48500](../modules/02-drive-train/propulsion.md#ez-a48500-controller-candidate) and [FDB 13 C](../modules/02-drive-train/propulsion.md#precima-fdb-13-c-holding-brake-candidate); custom reduction unpriced | [DC HOUSE bundle budget reference](../modules/04-battery-and-charging/batteries.md#48-v--approximately-2-kw-per-drive) · [Priced alternatives](../modules/04-battery-and-charging/batteries.md#battery-alternatives) |

**Former motor/planetary reference, excluded from the baseline:**

<!-- BEGIN GENERATED: alternatives -->
| Alternative (excluded from totals) | Unit reference | Cumulative reference |
| --- | ---: | ---: |
| [ALT-DRV-002: BLDC D110BLD2000 48 V motor with planetary provision](../modules/02-drive-train/propulsion.md#48-v--approximately-2-kw-per-drive) | €1,035.94 | €2,071.88 |
<!-- END GENERATED: alternatives -->

ALT-DRV-002 preserves the former motor/planetary reference, not its controller
or brake and not an additional purchase. HPM5000B was promoted from
ALT-DRV-001 to DRV-001; [F14](../modules/02-drive-train/propulsion.md#f14-hpm5000b-controller-and-brake-cost-baseline)
records the change. The
[custom planetary-in-drum gearbox](../modules/02-drive-train/propulsion.md#hpm5000b-planetary-in-drum-study)
and brake installation remain unpriced. Neither the new motor's advertised
power nor controller's hardware current limits changes the operating target.

**Continue with HPM5000B:** [Price](../modules/02-drive-train/propulsion.md#hpm5000b-purchase-scope-and-price) ·
[Specifications](../modules/02-drive-train/propulsion.md#hpm5000b-ratings-and-sourcing-limits) ·
[Mounting to the track](../modules/02-drive-train/propulsion.md#motor-to-track-mounting).

### Powered rolling width adjustment

For actuator, screw, feedback, holding, and stopping requirements, see
[width-drive concept](../modules/03-width-adjustment/width-adjustment.md#powered-rolling-width-adjustment)
and [named width-adjustment requirements](../modules/03-width-adjustment/width-adjustment.md#specification-and-inspection-requirements).

[↑ Back to document overview](chassis-bom.md#chassis-bom)

## Material and equipment totals

The module summary above is for scanning. For category detail, line totals,
and the installed/bench/support split, use the generated
[BOM Cost Breakdown](../cost-breakdown.md). The [Cost ledger](chassis-bom.csv) is the
authoritative source for quantities, scenario costs, basis codes, and
assumptions. `I` and `R` rows do not add separate purchase costs; unknown
qualification exposure is not treated as free.

**Detail:** [Readiness and cost basis](chassis-bom.md#readiness-snapshot) ·
[Installed, bench and support accounting](chassis-bom.md#installed-bench-and-support-totals) ·
[Stage acquisitions](chassis-bom.md#stage-acquisitions--no-double-counting).

### Readiness snapshot

Price evidence and engineering approval are separate. No line is released for
procurement or manufacture by this package.

<!-- BEGIN GENERATED: readiness -->
| Cost basis: lines / EUR | 48 V |
| --- | ---: |
| Calculated public-price references (C) | 4 / €4,025.10 |
| Engineering allowances (A) | 98 / €6,559.00 |
| Included / no separate purchase (I) | 1 / N/A |
| Reused inventory (R) | 8 / N/A |
| **Total (111 lines)** | €10,584.10 |
<!-- END GENERATED: readiness -->

Every current cost line maps to a primary owner within the
[39 requirement families](../chassis-build-requirements.md#2-confirm-item-family-specifications).
The [calculated-torque evidence family](../modules/07-workshop-and-support/workshop.md#ps35-calculated-torque-and-test-evidence)
has no equipment purchase. All families remain on hold pending component and
design qualification. This package
does not contain released cut lists, harness drawings, approved supplier lists,
numeric inspection limits, or signed first-article records.

<a id="purchase-totals"></a>

### Installed, bench, and support totals

The [purchase totals in BOM Cost Breakdown](../cost-breakdown.md#purchase-totals)
separate installed-machine materials, reusable bench equipment, and loose
handling/consumables/support. The [width-drive donor motor](../modules/03-width-adjustment/width-adjustment.md#ps09-reused-wiper-motor)
has N/A purchase cost because it is already owned, not because a replacement
would be free. Battery totals include enclosures and the
conditional tax reserve; power distribution includes protection and
converters; bench equipment includes the guarded fixture and instruments.
Consumables/support includes initial spares and PPE.
[Transport straps and service supports](../modules/07-workshop-and-support/workshop.md#ps33-transport-straps-and-service-supports)
are reused inventory with no new purchase cost; slings and shackles are excluded.

### Stage acquisitions — no double-counting

<!-- BEGIN GENERATED: phases -->
| Acquisition stage | 48 V |
| --- | ---: |
| Stage 1 — bench propulsion prototype | €4,463.55 |
| Stage 2 — rolling two-pod chassis (additional purchases only) | €6,120.55 |
| **Stages 1–2 cumulative** | €10,584.10 |
<!-- END GENERATED: phases -->

This assumes one [instrumented, guarded bench fixture](../modules/07-workshop-and-support/workshop.md#ps34-bench-fixture-and-controls)
is reused, with no dynamometer or direct torque measurement. **Stage 1** includes fixture
materials and separate physical stopping provisions; later safety work does
not permit deferring essential safety. **Stage 2** has no separate industrial
remote allowance because the owner intends to use the mobile app for normal
commands. The app/network and the
[general E-stop proposal](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control)
are not yet verified safety behavior.

[↑ Back to document overview](chassis-bom.md#chassis-bom)

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
  deferred until Stage 2. The
  [HPM5000B bare motor](../modules/02-drive-train/propulsion.md#hpm5000b-purchase-scope-and-price)
  does **not** include planetary reduction; the custom reduction is unpriced.
  Retired external-drive rows are not additional purchases.
  The [reused width motor (WID-001)](../modules/03-width-adjustment/width-adjustment.md#ps09-reused-wiper-motor)
  retains an installed quantity although its purchase cost is `N/A`.
- Source IDs resolve to the [named supplier register](sources.md#source-id-lookup). A category,
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
  is **21%**. USD motor/controller references add 21% after FX conversion;
  the EUR159 brake excluding tax uses `159 × 1.21`, without USD conversion.
  Allowances are intended as tax-inclusive cash provisions; no VAT recovery
  is assumed. Import duty, freight VAT, and actual seller tax treatment require
  checkout/RFQ.
- The [DC HOUSE EU/non-DE bundle](../modules/04-battery-and-charging/batteries.md#s30-dc-house-100-ah-charger-bundle)
  displays €849.99 with an 18 A charger. Destination VAT inclusion is unclear;
  the ledger uses `849.99 × 1.21 = €1,028.49` per bundle, rounded half-up,
  as a **conditional 21% tax-reserved provision**, not proof of a net price.
  Replace that reserve with confirmed destination treatment rather than taxing
  an inclusive price twice. BAT-005 is included in BAT-001 (`I / N/A`).
  The German solar-use 0%-VAT offer is not an entitlement for this mower.
  Romania shipment, two-pack freight and actual tax remain unconfirmed.
  The retained GBS alternative explicitly includes 19% VAT and therefore uses
  `/1.19 × 1.21` for comparison instead; it does not enter baseline totals.
- The **20% contingency** is a separate budget reserve, not a statistical
  confidence interval or a guarantee that design changes or quotations fit it.

### Budget assumptions

The [build-budget table](chassis-bom.md#build-budget) adds the
[non-material allowances](budget-allowances.csv). These provisions are not
material prices:

- **Materials/equipment:** sum of the [cost ledger](chassis-bom.csv).
- **Freight/import/brokerage:** an allowance, not a landed quote or statutory
  duty calculation; pack transport and Romania delivery must be quoted.
- **Owner fabrication labor:** no purchased labor applies because the owner
  performs fabrication. Effort and engineering qualification are not valued.
- **Outsourced precision machining:** retained provision for shaft/hub/bore or
  other work that cannot be made with the owner's reported lathe/mill access;
  off-the-shelf gears are preferred where possible. Exact parts and any quote remain open.
- **DIY fabrication/printing energy:** provisional electricity allowance,
  not materials or purchased tools.
- **Calibration evidence:** no separate service allowance is included; use
  supplier calibration data where provided and verify end-to-end sensor scaling,
  channel mapping, and measurements. This is not a claim that the instruments
  are calibrated or suitable.
- **Budget before contingency:** sum of the preceding provisions.
- **Uncertainty contingency:** 20% of that subtotal.
- **Indicative build budget:** still excludes professional design,
  certification, and commissioning.

Do not present the indicative budget as a quoted complete-machine price. Do not
compare the historical €5,000 six-component basket with a full chassis and
independent safety as though their scopes match. Reused equipment has no new
purchase cost, but its condition, capacity, calibration, and suitability remain
to be checked. The [selected test method](../modules/07-workshop-and-support/workshop.md#test-method-and-evidence)
does not measure output torque; it
cannot establish torque capability or replace the open engineering and safety
gates.

[↑ Back to document overview](chassis-bom.md#chassis-bom)

## Evidence and maintenance

**Detail:** [Cost updates](chassis-bom.md#updating-linked-costs) ·
[Supplier evidence](chassis-bom.md#supplier-register) ·
[Feedback and qualification](chassis-bom.md#feedback-and-qualification-loops).

### Updating linked costs

Use the [cost update guide](updating-linked-costs.md) to edit the owning
CSVs, regenerate linked tables, and verify freshness and references. Edit
inputs, not generated tables. A cost update does not authorize a hardware
selection, purchase, fabrication, or operation.

### Supplier register

Dated supplier evidence lives at the end of each module page; the
[source lookup](sources.md#source-id-lookup) maps every ID to its page, and
[Sources](sources.md) keeps sourcing weights and shared catalogs. Catalog
leads are not component qualification.

### Feedback and qualification loops

See [feedback and qualification loops](feedback.md) for dated decisions,
required inputs, closure evidence, and authorization boundaries.

[↑ Back to document overview](chassis-bom.md#chassis-bom)
