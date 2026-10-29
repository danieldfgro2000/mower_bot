# BOM feedback and qualification loops

<a id="document-overview"></a>

**Status:** DRAFT / HOLD; engineering estimate and unqualified requirements.
No procurement, fabrication, energizing or operation is authorized.

**Summary:** Index of every dated decision (F) and qualification loop (L).
Module-specific records now sit in the **Decision records** section of their
owning page, beside that part's price, specifications and fit. Only the
cross-module budget decision (F02) and supplier-convergence loop (L6) remain
here. A dated record is not approval.

**On this page:** [Where each decision lives](feedback.md#feedback-decisions) ·
[Where each qualification loop lives](feedback.md#feedback-and-qualification-loops)

**Related documents:**
[Chassis BOM](chassis-bom.md) ·
[Cost ledger](chassis-bom.csv) ·
[Supplier register](sources.md#source-id-lookup) ·
[Chassis Build and Procurement Checklist](../chassis-build-requirements.md)

## Feedback decisions

Read each date and correction together. Current requirements live in the
linked engineering scopes, not in an earlier proposal. Each decision link
opens the record on its owning page.

| Decision record | Current component / working view |
| --- | --- |
| [Propulsion comparison (F01)](../modules/02-drive-train/propulsion.md#f01-propulsion) | [Motor choices, prices and specifications](../modules/02-drive-train/propulsion.md#parts-at-a-glance) |
| [Budget target (F02)](feedback.md#f02-budget) | [Estimate rules and scope](chassis-bom.md#estimate-rules) |
| [Existing inventory and fabrication (F03)](../modules/07-workshop-and-support/workshop.md#f03-existing-inventory-and-fabrication) | [Workshop buy/reuse choices](../modules/07-workshop-and-support/workshop.md#parts-at-a-glance) |
| [Rolling adjustment and donor motor (F04)](../modules/03-width-adjustment/width-adjustment.md#f04-adjustment-mode-and-actuator) | [Motor data and mechanical drive path](../modules/03-width-adjustment/width-adjustment.md#donor-motor-and-allowance) |
| [Worm-only holding and position proposal (F05)](../modules/03-width-adjustment/width-adjustment.md#f05-holding-and-position-proposal) | [Unresolved holding and stopping](../modules/03-width-adjustment/width-adjustment.md#width-holding-and-stopping) |
| [Packaging and site targets (F06)](../width-and-slope-sizing.md#f06-packaging-and-site-targets) | [Width and slope inputs](../width-and-slope-sizing.md#inputs-and-unresolved-definitions) |
| [Slope orientation and reduced speed (F07)](../width-and-slope-sizing.md#f07-slope-orientation-and-speed) | [Reduced-speed implications](../width-and-slope-sizing.md#effect-of-accepting-reduced-speed) |
| [Bare motor and HPM5000B sourcing (F08)](../modules/02-drive-train/propulsion.md#f08-bare-motor-two-stage-chains-and-hpm5000b-sourcing) | [HPM5000B price and exclusions](../modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate) · [Later in-drum study](../modules/02-drive-train/propulsion.md#hpm5000b-planetary-in-drum-study) |
| [Rear motor position (F09)](../modules/02-drive-train/propulsion.md#f09-rear-traction-motor-position) | [Motor/drum layout and mounting interfaces](../modules/02-drive-train/propulsion.md#motor-to-track-mounting) |
| [Workshop, test method and app control (F10)](../modules/07-workshop-and-support/workshop.md#f10-workshop-equipment-test-method-and-mobile-app-control) | [Tool-by-tool price/reuse table](../modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools) · [Independent stop requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| [Motor braking and stationary hold (F11)](../modules/02-drive-train/propulsion.md#f11-motor-braking-and-stationary-hold) | [Braking direction](../modules/02-drive-train/propulsion.md#owner-braking-direction-2026-10-27) |
| [48 V baseline and scenario retirement (F12)](../modules/04-battery-and-charging/batteries.md#f12-48-v-battery-baseline-and-scenario-retirement) | [Active cost configuration](chassis-bom.md#propulsionbattery-comparison) |
| [Value battery shortlist and charger bundles (F13)](../modules/04-battery-and-charging/batteries.md#f13-value-battery-shortlist-and-bundled-chargers) | [DC HOUSE first choice and priced alternatives](../modules/04-battery-and-charging/batteries.md#battery-alternatives) |
| [HPM5000B, controller and brake baseline (F14)](../modules/02-drive-train/propulsion.md#f14-hpm5000b-controller-and-brake-cost-baseline) | [Current component references](../modules/02-drive-train/propulsion.md#parts-at-a-glance) · [Brake fitment](../modules/02-drive-train/propulsion.md#fdb-13-c-to-hpm5000b-fitment) |


### F02: budget

**Decision recorded on 2026-10-26:** €5,000 is a target estimate, not a hard upper
limit; include every material estimate and a total.

**Effect on estimate:** Replace blank costs with explicit allowances; show overruns
rather than omit necessary systems.


[↑ Back to document overview](feedback.md#bom-feedback-and-qualification-loops)


## Feedback and qualification loops

Each loop records **input → proposed revision → user review → BOM/total update**.
A decision can close an estimating assumption; only evidence can close a
component qualification. A failed check reopens downstream selections and costs.

| Qualification loop | Evidence owner |
| --- | --- |
| [Inventory and cost scope (L1)](../modules/07-workshop-and-support/workshop.md#l1-inventory-and-cost-scope) | [Workshop tools and qualification](../modules/07-workshop-and-support/workshop.md#specification-and-inspection-requirements) |
| [Drive operating points (L2)](../modules/02-drive-train/propulsion.md#l2-drive-operating-points) | [Drive compatibility and duty](../modules/02-drive-train/propulsion.md#compatibility-and-duty-limitations) |
| [Energy and battery (L3)](../modules/04-battery-and-charging/batteries.md#l3-energy-and-battery) | [Packs and BMS requirements](../modules/04-battery-and-charging/batteries.md#ps18-battery-packs-and-bms) |
| [Running gear and structure (L4)](../modules/01-structure-and-running-gear/running-gear.md#l4-running-gear-and-structure) | [Running-gear requirements](../modules/01-structure-and-running-gear/running-gear.md#specification-and-inspection-requirements) · [Frame requirements](../modules/01-structure-and-running-gear/frame.md#specification-and-inspection-requirements) · [Width-adjustment requirements](../modules/03-width-adjustment/width-adjustment.md#specification-and-inspection-requirements) |
| [Stopping and electrical safety (L5)](../modules/06-safety-controls-and-sensors/safety-controls.md#l5-stopping-and-electrical-safety) | [Independent stop requirements](../modules/06-safety-controls-and-sensors/safety-controls.md#ps28-independent-stopping-and-normal-control) |
| [Supplier and price convergence (L6)](feedback.md#l6-supplierprice-convergence) | [Supplier request packages](../chassis-build-requirements.md#4-prepare-procurement-work-packages) · [Cost-update procedure](updating-linked-costs.md) |


### L6: supplier/price convergence

**Inputs needed / next feedback:** Exact MPN/options, quantity, VAT, freight/customs,
stock/lead time, warranty/returns

**What changes:** Replace C/A with actual matched quotations; remove bundle duplicates
and recalculate stage and scenario totals

**Closure evidence:** Itemized delivered offers and procurement approval; remaining
unknowns stay identified

No supplier contact, order, fabrication, upload, energizing, or field test has
been authorized by these feedback decisions. No component, braking arrangement,
controller topology, or operating envelope is approved by this estimate.

[↑ Back to document overview](feedback.md#bom-feedback-and-qualification-loops)
