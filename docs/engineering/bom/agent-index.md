# Engineering BOM Agent Index

<a id="document-overview"></a>

**Summary:** Find the owner for a BOM change, then open the relevant technical
scope. This router does not replace repository guardrails or the BOM skill.

**On this page:** [Task routing](agent-index.md#task-routing) ·
[Module scopes](agent-index.md#module-scopes)

**Related documents:** [Engineering BOM agent guide](agent-guide.md) ·
[Numbered module directory](../modules/README.md) ·
[Documentation index](../../index.md) ·
[BOM documentation skill](../../../.github/skills/bom-documentation/SKILL.md)

## Task routing

| Task | Start with | Authoritative owner |
| --- | --- | --- |
| Understand module numbers and document boundaries | [Agent guide](agent-guide.md) | [Cost module map](cost-modules.csv) |
| Change quantities, prices, or cost basis | [Cost update procedure](updating-linked-costs.md) | [Cost ledger](chassis-bom.csv) |
| Change module ownership, numbering, or scope mapping | [Agent guide](agent-guide.md#module-numbering) | [Cost module map](cost-modules.csv) |
| Update supplier evidence | Owning module page's **Supplier evidence** section; shared catalogs and weights in [Sources](sources.md) | [Cost ledger source IDs](chassis-bom.csv); IDs listed in the [source lookup](sources.md#source-id-lookup) |
| Assess a propulsion candidate | [Propulsion scope](../modules/02-drive-train/propulsion.md) | [Propulsion alternatives](propulsion-alternatives.csv) |
| Trace a component from price/data to physical integration | [Component reading paths](updating-linked-costs.md#component-reading-paths) | [Motor-to-track interface example](../modules/02-drive-train/propulsion.md#motor-to-track-mounting); the adjoining scopes own their attachment details |
| Review requirements or release holds | [Named requirement families](../chassis-build-requirements.md#2-confirm-item-family-specifications) | [Purchase/build holds](../chassis-build-requirements.md#5-close-release-hold-points) |
| Improve document navigation | [Component-first reading paths](updating-linked-costs.md#component-reading-paths) | Part scan tables and local price/specification/connection links; generated headings follow the [module map](cost-modules.csv) |
| Validate generated costs and document references | [Cost regeneration](updating-linked-costs.md#regenerate-and-verify) | [Reference checks](updating-linked-costs.md#reference-checks) |

[↑ Back to document overview](agent-index.md#engineering-bom-agent-index)

## Module scopes

| Module | Authoritative technical scopes (self-contained, including evidence, decisions and holds) |
| --- | --- |
| 01 — Structure and running gear | [Frame, scissor and spine](../modules/01-structure-and-running-gear/frame.md) · [Tracks and running gear](../modules/01-structure-and-running-gear/running-gear.md) |
| [02 — Drive train](../modules/02-drive-train/propulsion.md) | [Motors, reductions and brakes](../modules/02-drive-train/propulsion.md) |
| [03 — Width adjustment](../modules/03-width-adjustment/width-adjustment.md) | [Width mechanism, feedback and holding](../modules/03-width-adjustment/width-adjustment.md) |
| [04 — Battery and charging](../modules/04-battery-and-charging/batteries.md) | [Packs, enclosures and charging](../modules/04-battery-and-charging/batteries.md) |
| 05 — Power cables and electronics | [Cables and connectors](../modules/05-power-cables-and-electronics/cables-connectors.md) · [Power distribution](../modules/05-power-cables-and-electronics/power-distribution.md) |
| [06 — Safety controls and sensors](../modules/06-safety-controls-and-sensors/safety-controls.md) | [Independent stopping, controls and sensors](../modules/06-safety-controls-and-sensors/safety-controls.md) |
| [07 — Workshop and support](../modules/07-workshop-and-support/workshop.md) | [Bench fixture, workshop tools and service supplies](../modules/07-workshop-and-support/workshop.md) |

[↑ Back to document overview](agent-index.md#engineering-bom-agent-index)
