# Chassis BOM and Cost Breakdown

**Document:** MBR-ENG-BOM-001 | **Revision:** L | **Revised:** 2026-10-26

**Status:** costed engineering estimate; **not released for purchase, fabrication, or operation**.

**Start here:** this document answers **what the chassis needs and what it
costs**. It covers the tracked chassis, batteries, controls and the equipment
needed to build and check it; the mower implement and autonomy are excluded.
The companion [Chassis Build and Procurement Checklist](chassis-build-requirements.md)
answers **what drawings, supplier information and inspections are still needed
before buying or building**. It is a checklist, not a product/software release.

**On this page:** [Module summary](chassis-bom.md#module-cost-summary) ·
[BOM scopes](chassis-bom.md#bom-by-scope) · [Estimate rules](chassis-bom.md#estimate-rules) ·
[Configuration comparison](chassis-bom.md#propulsionbattery-comparison)

**BOM documents:** [Cost breakdown](cost-breakdown.md) ·
[Build checklist](chassis-build-requirements.md) ·
[Supplier evidence](bom/sources.md) · [Feedback and qualification loops](bom/feedback.md) ·
[Update linked costs](bom/updating-linked-costs.md)

**Cost data:** [Itemized quantity and cost ledger (CSV)](chassis-bom.csv)

## Module cost summary

These are estimated cumulative Stage 1-2 costs for each major module. The
48 V and 72 V columns are alternative chassis configurations, not amounts to
add together. Follow a module link in the detailed tables below for its
itemized parts and assumptions.

<!-- BEGIN GENERATED: overview -->
| Module | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **Structure and running gear** | €2,213.00 | €2,213.00 |
| **Drive train** | €3,781.66 | €3,520.00 |
| **Width adjustment** | €407.00 | €407.00 |
| **Battery and charging** | €3,148.16 | €5,698.48 |
| **Power cables and electronics** | €1,679.00 | €1,679.00 |
| **Safety controls and sensors** | €2,580.00 | €2,580.00 |
| **Workshop and support** | €4,514.00 | €4,514.00 |
| **All listed materials/equipment** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: overview -->

### Build budget

The following adds non-material allowances and contingency to the module costs.
The materials/equipment row includes installed parts, reusable bench equipment
and support supplies. The HPM5000B candidate is excluded from these baseline
totals; it has not replaced the costed planetary drive.

<!-- BEGIN GENERATED: budget -->
| Budget line | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| Materials/equipment | €18,322.82 | €20,611.48 |
| Freight/import/brokerage provision | €500.00 | €700.00 |
| Outsourced precision machining provision | €350.00 | €650.00 |
| DIY fabrication/printing energy | €30.00 | €30.00 |
| Instrument calibration/setup service | €250.00 | €250.00 |
| Owner fabrication labor | N/A - owner supplied | N/A - owner supplied |
| **Budget before contingency** | €19,452.82 | €22,241.48 |
| Uncertainty contingency (20%) | €3,890.56 | €4,448.30 |
| **Indicative build budget** | €23,343.38 | €26,689.78 |
<!-- END GENERATED: budget -->

[Installed parts / bench / support split](chassis-bom.md#purchase-totals) ·
[Budget assumptions and exclusions](chassis-bom.md#budget-assumptions)

**Cost tables on this page:** [Drive train](chassis-bom.md#drive-train) ·
[Batteries, BMS and chargers](chassis-bom.md#battery-and-charging) ·
[Cables and power electronics](chassis-bom.md#power-cables-and-electronics) ·
[Sensors, safety and controls](chassis-bom.md#safety-controls-and-sensors) ·
[Frame and tracks](chassis-bom.md#structure-and-running-gear) ·
[Width adjustment](chassis-bom.md#width-adjustment) ·
[Workshop](chassis-bom.md#workshop-and-support) · [Overall totals](chassis-bom.md#purchase-totals).
Each module row links directly to its itemized cost table.

**Detailed BOM:** [129 itemized material/equipment rows in CSV](chassis-bom.csv).
The CSV owns item quantities and scenario-specific unit/extended costs; this
document owns the estimate rules, scope, and cost roll-up. Linked scope documents
own technical detail; shared registers own source evidence and feedback decisions.
The [build and procurement checklist](chassis-build-requirements.md)
maps every line to technical specification and inspection deliverables, defines
released-part records and RFQ packages, and identifies production release holds.
It does not turn this estimate into a released manufacturing BOM.

**Revision L change:** separated same-page navigation from document links and
moved cost maintenance into [its own guide](bom/updating-linked-costs.md).
This remains the main BOM entry point. Quantities, prices, requirements,
calculation rules and totals are unchanged.

Technical details are presented as labeled sections; tables are reserved for
compact numerical comparisons. The CSV remains the full line-item ledger.

## BOM by scope

Each scope lists its cost-line IDs, sourcing references, specifications,
inspection evidence and interfaces. Shared items have one primary scope;
links to another scope do not add quantities or costs.

- [Tracks and running gear](bom/running-gear.md): tracks, sprockets, rollers,
  tensioners, axles, bearings and guides.
  [Itemized costs](bom/running-gear.md#detailed-module-costs) ·
  [Specifications](bom/running-gear.md#specification-and-inspection-requirements).
- [Drive train: propulsion, reductions and brakes](bom/propulsion.md): 48 V / 72 V drive
  comparison, motors, matched controllers, shafts and transmission; includes the
  [HPM5000B alternative cost record](bom/propulsion-alternatives.csv).
  [Itemized costs](bom/propulsion.md#detailed-module-costs) ·
  [Specifications](bom/propulsion.md#specification-and-inspection-requirements).
- [Frame, scissor and spine](bom/frame.md): stock, weldments, pivots, width
  holding, guards, fasteners, coatings and installed lifting/recovery points.
  [Itemized costs](bom/frame.md#detailed-module-costs) ·
  [Specifications](bom/frame.md#specification-and-inspection-requirements).
- [Powered width adjustment](bom/width-adjustment.md): reused motor, screw,
  local power/driver, feedback, limits, actuator harness and guard.
  [Itemized costs](bom/width-adjustment.md#detailed-module-costs) ·
  [Specifications](bom/width-adjustment.md#specification-and-inspection-requirements).
- [Batteries and charging](bom/batteries.md): pack alternatives, BMS, battery
  enclosures/restraints, chargers and charging interlocks.
  [Itemized costs](bom/batteries.md#detailed-module-costs) ·
  [Specifications](bom/batteries.md#specification-and-inspection-requirements).
- [Cables, connectors and harnesses](bom/cables-connectors.md): high-current
  and signal wiring, lugs, complete mating connectors, shielding and routing.
  [Itemized costs](bom/cables-connectors.md#detailed-module-costs) ·
  [Specifications](bom/cables-connectors.md#specification-and-inspection-requirements).
- [Electronics, power distribution and safety](bom/electronics.md): switchgear,
  supplies, printed electronics enclosures, independent stop hardware,
  control boards, sensors and logging.
  [Itemized costs](bom/electronics.md#detailed-module-costs) ·
  [Specifications](bom/electronics.md#specification-and-inspection-requirements).
- [Workshop, bench equipment and service supplies](bom/workshop.md): loose
  handling gear, test fixture/dynamometer, tools, consumables, spares and PPE.
  [Itemized costs](bom/workshop.md#detailed-module-costs) ·
  [Specifications](bom/workshop.md#specification-and-inspection-requirements).

Shared references: [Supplier sources](bom/sources.md) ·
[Feedback and qualification loops](bom/feedback.md) ·
[Build and procurement checklist](chassis-build-requirements.md) ·
[Updating linked costs](bom/updating-linked-costs.md) (input files, regeneration
and reference checks).

### Readiness snapshot

Price evidence and engineering approval are separate. None of the lines is
released for procurement or manufacture by this package.

<!-- BEGIN GENERATED: readiness -->
| Cost basis: lines / EUR | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| Calculated public-price references (C) | 4 / €6,009.82 | N/A - no lines |
| Engineering allowances (A) | 119 / €12,313.00 | 128 / €20,611.48 |
| Included / no separate purchase (I) | 5 / N/A | N/A - no lines |
| Reused inventory (R) | 1 / N/A | 1 / N/A |
| **Total (129 lines)** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: readiness -->

All 129 lines map to **39 specification families** across the scope documents. They define
what must be purchased/made, what evidence must accompany it, and what must be
inspected; all are on hold pending actual component and design qualification.
The package does not yet contain released cut lists, harness drawings, approved
supplier lists, numeric inspection limits, or signed first-article records.

## Scope and decisions

One Stage 1 one-drive bench setup followed by one Stage 2 two-pod rolling
chassis. Stage 2 quantities are **cumulative**, not additional to Stage 1.
These are build phases from the plan, not document versions: **Stage 1 means
testing one drive on a bench; Stage 2 means assembling the two-pod rolling
chassis**. The cost tables cover both phases, not the complete mower product.
Bench equipment is retained separately, not installed on the chassis.
The [plan](../../plan.md) remains the product authority; its 48 V / approximately
2 kW continuous-per-drive baseline has **not** been changed.

See [dated feedback decisions](bom/feedback.md#feedback-decisions) for F01–F08.

**Included:** running gear, pod/scissor/spine materials, width locks, guards,
propulsion and brake provisions, batteries/BMS, chargers, protection, wiring,
independent safety provisions, operator remote, logging/sensors, handling,
bench load/measurement equipment, initial consumables, and support materials.

**Excluded:** DAC 9100 mower and Stage 3 mount/cutting guards, conveyor, trailer,
fruit drum, RTK/autonomy equipment and subscriptions, road transport vehicle,
workshop rent, insurance, certification, professional design/risk assessment,
software development, field commissioning, major workshop machinery, and a
complete spare track/motor/battery. An existing programming computer and normal
workshop infrastructure are assumed available. The confirmed welder and 3D
printer are not priced as new purchases. No four-column cage is included.
Outsourced machining, fabrication energy, calibration, freight, and uncertainty
are shown separately below rather than hidden in the material BOM.

The DIY enclosure allowance covers electronics and cable covers, **not an
approved printed structural part or traction-battery containment design**.
Polymer temperature/UV/flame performance, thermal paths, fastener retention,
glands, sealing, and electrical protection remain to be reviewed. No IP or
washdown rating is claimed. Battery enclosures remain separately budgeted
pending their own mechanical/environmental design.

## Estimate rules

- Numeric CSV amounts are **EUR cash-budget estimates** to two decimals. This is a
  calculation format, not a claim of cent-level accuracy or landed quotations.
- **C — calculated reference:** derived from a public price with disclosed
  currency/tax assumptions. **A — allowance:** a provisional engineering budget,
  **not a supplier price**. **I — included / no separate purchase:** the function
  is budgeted in another line; the separate item does not apply in that scenario.
  **R — reused:** confirmed owner-reported inventory; no new purchase applies,
  but capability/condition still require qualification.
- **N/A is not a price or an unknown estimate.** In CSV cost columns it is
  permitted only for `I` or `R`, with a reason in the assumption field.
  Unit and extended cost must both be `N/A` for that scenario. Exclude these
  entries from cash-cost sums; do not substitute a guessed price. Required
  purchases still have numeric `C` or `A` estimates. Unpriced design/qualification
  exposures remain disclosed separately, not hidden as `N/A`.
- Quantities remain numeric: Stage 1 quantity `0` means acquisition is deferred
  until Stage 2. DRV-007–011 quantities apply only to the 72 V external reduction;
  their 48 V costs are `N/A` because DRV-001 budgets planetary reduction.
  WID-001 retains an installed quantity even though its purchase cost is `N/A`.
- Source IDs resolve to the [source register](chassis-bom.md#source-register). A category,
  manufacturer page, or price proxy is a sourcing lead, not an exact qualified
  SKU or proof that the allowance can buy it. Most rows are allowances.
- Quantities, steel mass, bearing count, cable lengths, and bought assemblies
  are provisional. They are **not** dimensions, conductor sizes, load ratings,
  or a fabrication/harness cut list. A quoted roller/gearbox kit may include
  bearings, shafts, or brakes budgeted separately; remove those overlapping
  allowances at quotation, not by assuming they are included now.
- [ECB reference, 2026-10-26](https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml):
  **€1 = US$1.1188 = RON 5.3473**. USD amounts use `USD / 1.1188`.
  Bank/card spreads are not supplier prices and remain an uncertainty.
- [Romanian standard VAT reference](https://europa.eu/youreurope/business/finance-and-tax/vat/vat-rules-rates/index_en.htm):
  **21%**. USD motor/controller/brake references add 21% for planning. Allowances
  are intended as tax-inclusive cash provisions. No VAT recovery is assumed.
  Import duty, freight VAT, and actual seller tax treatment require checkout/RFQ.
- Elker's €1,019.90 displayed price has an unconfirmed tax basis in the retrieved
  content. BAT-001 conservatively adds a **conditional 21% reserve**, producing
  €1,234.08 per pack. If that price already includes applicable VAT, remove the
  reserve: **€428.36 reduction for two packs**. Do not add VAT again to this row.
- The TZI €1,735 listing uses conditional **0% VAT** for eligible solar
  installations; do not apply that exemption to this machine. The 72 V battery
  allowance includes 21%, but is an extrapolation, not a quoted product.
- A **20% budget contingency** is shown separately. It is neither a statistical
  confidence interval nor a guarantee that design changes or quotations fit it.

## Propulsion/battery comparison

See [propulsion, reductions and brakes](bom/propulsion.md) and
[batteries and charging](bom/batteries.md) for the two scenario alternatives.

<!-- BEGIN GENERATED: alternatives -->
| Alternative (excluded from totals) | Unit reference | Cumulative reference |
| --- | ---: | ---: |
| [ALT-DRV-001: Golden Motor HPM5000B bare motor 48 V advertised 5 kW](bom/propulsion-alternatives.csv) | €482.36 | €964.72 |
<!-- END GENERATED: alternatives -->

References exclude freight, duty and brokerage; see the
[supplier and integration details](bom/propulsion.md#hpm5000b-sourced-alternative--not-added-to-baseline-totals).
This is a possible replacement for DRV-001, not an additive purchase or an
approved change from the approximately 2 kW-per-drive baseline.
The main 48 V column still costs the former planetary package; it is not a
re-costed HPM5000B/two-stage-chain package.

## Powered rolling width adjustment

See [powered width adjustment](bom/width-adjustment.md) for actuator,
screw, feedback, holding and stopping requirements.

<a name="cost-breakdown"></a>

## Material and equipment totals

Every CSV line has a quantity, unit, numeric cost estimate or explained `N/A`
for each scenario, source ID, and qualification/assumption note. `I` and `R`
rows do not add a separate purchase cost. No unpriced/TBD cost is treated as free.
Each module links to its detailed cost table. These are cumulative two-pod
Stage 1-2 purchase costs, not costs per motor or per pod. Module rows partition
the ledger; do not add subtotals to their own constituent rows.

<!-- BEGIN GENERATED: modules -->
### Structure and running gear

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Rubber tracks](bom/running-gear.md#cost-tracks) | €280.00 | €280.00 |
| [Sprockets idlers rollers and tensioners](bom/running-gear.md#cost-track-hardware) | €660.00 | €660.00 |
| [Track axles bearings guides and scrapers](bom/running-gear.md#cost-track-support) | €284.00 | €284.00 |
| [Frame stock and mounting plates](bom/frame.md#cost-frame-stock) | €413.00 | €413.00 |
| [Scissor pivots locks and hard stops](bom/frame.md#cost-frame-pivots) | €196.00 | €196.00 |
| [Guards fasteners coatings and labels](bom/frame.md#cost-frame-finish) | €280.00 | €280.00 |
| [Installed lifting and recovery points](bom/frame.md#cost-handling-points) | €100.00 | €100.00 |
| **Structure and running gear subtotal** | €2,213.00 | €2,213.00 |

### Drive train

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Traction motors and included planetary where applicable](bom/propulsion.md#cost-motors) | €2,071.88 | €1,300.00 |
| [Traction motor controllers](bom/propulsion.md#cost-motor-controllers) | €1,023.24 | €1,000.00 |
| [Mechanical holding brakes](bom/propulsion.md#cost-brakes) | €446.54 | €500.00 |
| [Output hubs shafts and bearings](bom/propulsion.md#cost-output-support) | €210.00 | €210.00 |
| [External chain reduction and keys](bom/propulsion.md#cost-chain-reduction) | €30.00 | €510.00 |
| **Drive train subtotal** | €3,781.66 | €3,520.00 |

### Width adjustment

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Width motor screw bearings mounts and guard](bom/width-adjustment.md#cost-width-mechanics) | €155.00 | €155.00 |
| [Width converter driver and protected enable](bom/width-adjustment.md#cost-width-power) | €155.00 | €155.00 |
| [Width encoder limits current and reference sensors](bom/width-adjustment.md#cost-width-sensors) | €77.00 | €77.00 |
| [Width actuator harness and strain relief](bom/width-adjustment.md#cost-width-harness) | €20.00 | €20.00 |
| **Width adjustment subtotal** | €407.00 | €407.00 |

### Battery and charging

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Battery packs with integrated BMS](bom/batteries.md#cost-packs) | €2,468.16 | €4,898.48 |
| [BMS: included in pack; not separately priced](bom/batteries.md#cost-packs) | N/A - included | N/A - included |
| [Battery enclosures restraints and insulation](bom/batteries.md#cost-battery-housing) | €270.00 | €270.00 |
| [Matched battery chargers](bom/batteries.md#cost-chargers) | €320.00 | €440.00 |
| [Charge connectors fuse holders and interlock harness](bom/batteries.md#cost-charge-harness) | €90.00 | €90.00 |
| **Battery and charging subtotal** | €3,148.16 | €5,698.48 |

### Power cables and electronics

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [High-current cable](bom/cables-connectors.md#cost-power-cables) | €90.00 | €90.00 |
| [Power lugs connectors and terminal insulation](bom/cables-connectors.md#cost-power-connectors) | €168.00 | €168.00 |
| [Control and communications cables](bom/cables-connectors.md#cost-signal-cables) | €85.00 | €85.00 |
| [Signal connectors conduit clips and labels](bom/cables-connectors.md#cost-signal-connectors) | €95.00 | €95.00 |
| [Main fuses disconnects contactors and feedback](bom/electronics.md#cost-switchgear) | €710.00 | €710.00 |
| [Precharge discharge and voltage-test hardware](bom/electronics.md#cost-precharge) | €90.00 | €90.00 |
| [Control DC/DC logic supplies and branch protection](bom/electronics.md#cost-control-supplies) | €260.00 | €260.00 |
| [Electronics enclosures glands cooling and mounting](bom/electronics.md#cost-enclosures) | €181.00 | €181.00 |
| **Power cables and electronics subtotal** | €1,679.00 | €1,679.00 |

### Safety controls and sensors

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Independent safety relay E-stops and reset controls](bom/electronics.md#cost-stop-controls) | €415.00 | €415.00 |
| [Industrial operator remote and stop provision](bom/electronics.md#cost-remote) | €1,500.00 | €1,500.00 |
| [Local control boards communications and service display](bom/electronics.md#cost-control-boards) | €120.00 | €120.00 |
| [Status beacon and buzzer](bom/electronics.md#cost-status) | €30.00 | €30.00 |
| [Tilt sensing and pod or guard interlocks](bom/electronics.md#cost-tilt-interlocks) | €200.00 | €200.00 |
| [Drive current voltage temperature and speed sensors](bom/electronics.md#cost-drive-sensors) | €240.00 | €240.00 |
| [Data logger storage and reader](bom/electronics.md#cost-logging) | €75.00 | €75.00 |
| **Safety controls and sensors subtotal** | €2,580.00 | €2,580.00 |

### Workshop and support

| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| [Loose slings straps shackles and service supports](bom/workshop.md#cost-loose-handling) | €224.00 | €224.00 |
| [Bench fixture guards and pendant](bom/workshop.md#cost-bench-fixture) | €170.00 | €170.00 |
| [Dynamometer torque measurement and adapters](bom/workshop.md#cost-dynamometer) | €3,050.00 | €3,050.00 |
| [Meters instruments hand tools and crimp tooling](bom/workshop.md#cost-bench-tools) | €500.00 | €500.00 |
| [Fabrication consumables and initial spares](bom/workshop.md#cost-consumables) | €245.00 | €245.00 |
| [PPE barriers charging surface fire and cleaning supplies](bom/workshop.md#cost-ppe-support) | €325.00 | €325.00 |
| **Workshop and support subtotal** | €4,514.00 | €4,514.00 |

### Purchase totals

| Accounting scope | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| **Installed-machine materials** | €13,808.82 | €16,097.48 |
| **Reusable bench equipment** | €3,720.00 | €3,720.00 |
| **Loose handling / consumables / support** | €794.00 | €794.00 |
| **All listed materials/equipment** | €18,322.82 | €20,611.48 |
| Above €5,000 materials/equipment target | €13,322.82 | €15,611.48 |
<!-- END GENERATED: modules -->

Width adjustment includes the reused donor motor; its purchase cost is N/A
because it is already owned, not because a replacement motor would be free.
The battery group includes enclosures and the conditional tax reserve.
Power distribution includes protection and converters; bench equipment includes
the load fixture and instruments. Consumables/support includes initial spares
and PPE. The €224 of loose slings, straps, shackles and service supports is
now in support, rather than installed-machine material. This classification
correction changes neither the purchase total nor stage acquisitions.

### Stage phasing — no double-counting

<!-- BEGIN GENERATED: phases -->
| Acquisition phase | 48 V / 2 kW | 72 V / 4 kW |
| --- | ---: | ---: |
| Stage 1: one-drive bench | €9,240.91 | €10,385.24 |
| Stage 2: additional purchases only | €9,081.91 | €10,226.24 |
| **Cumulative Stage 1-2** | €18,322.82 | €20,611.48 |
<!-- END GENERATED: phases -->

This assumes one instrumented bench setup is reused, not a dynamometer per
pod. Stage 1 includes protection and physical stopping provisions; Stage 4
does not permit deferring essential safety. The Stage 2 industrial remote is
not priced into the maintained-action bench pendant.

### Broader build-budget allowances — not material prices

The generated [build-budget table is at the top of this document](chassis-bom.md#build-budget).
Its allowances and exclusions are explained below.

#### Budget assumptions

**Materials/equipment above:** CSV sum

**Freight/import/brokerage provision:** Allowance, not a landed quote or statutory duty
calculation; pack transport and Romania delivery must be quoted

**User frame/enclosure fabrication labor:** No purchased labor applies because the
user performs fabrication. Excluded from cash sums; effort and engineering
qualification are not valued by this estimate.

**Outsourced precision machining provision:** Shaft/hub/bore or other precision work not
confirmed as DIY; 72 V allows additional reduction work; obtain quote

**DIY fabrication/printing energy:** Provisional electricity allowance, not material or
purchased tools

**Instrument calibration/setup service:** Allowance; not a completed calibration

**Budget before contingency:** Sum of the above

**Uncertainty contingency, 20% of preceding subtotal:** Separate provisional budget
reserve

**Indicative build budget including listed provisions:** Still excludes professional
design, certification, and commissioning stated under scope

Do not present this last row as a quoted complete-machine price. Conversely,
do not compare the €5,000 six-component historical basket with a full chassis,
independent safety, and newly purchased dynamometer as though their scopes match.
Reusing all bench equipment would remove €3,720 of listed acquisitions, but
only once suitable equipment and access are confirmed; it does not remove
the need to perform the planned measurements.

## Updating linked costs

To maintain this estimate, use the
[Updating linked costs guide](bom/updating-linked-costs.md). It identifies the
owning CSVs, regeneration commands, reference checks and repair procedure.
Edit inputs rather than generated tables; no cost update authorizes a hardware
selection, purchase or operation.

## Source register

See the [shared supplier source register](bom/sources.md). Source IDs in the
CSV resolve there; catalog leads are not component qualification.

## Feedback and qualification loops

See [feedback and qualification loops](bom/feedback.md) for dated decisions,
required inputs, closure evidence and authorization boundaries.
