# Engineering BOM Agent Index

<a id="document-overview"></a>

**Summary:** Route agents to the authoritative engineering BOM inputs,
procedures, and module scopes. Each numbered module has its own folder and
human-first entry page. This index does not replace repository
guardrails or the BOM maintenance skill.

**Start here:** [Engineering BOM agent guide](agent-guide.md) ·
[Numbered module directory](../modules/README.md) ·
[Documentation index](../../index.md) ·
[BOM documentation skill](../../../.github/skills/bom-documentation/SKILL.md)

## Task routing

| Task | Start with | Authoritative owner |
| --- | --- | --- |
| Understand module numbers and document boundaries | [Agent guide](agent-guide.md) | [Cost module map](cost-modules.csv) |
| Change quantities, prices, or cost basis | [Cost update procedure](updating-linked-costs.md) | [Cost ledger](chassis-bom.csv) |
| Change module ownership, numbering, or scope mapping | [Agent guide](agent-guide.md#module-numbering) | [Cost module map](cost-modules.csv) |
| Update supplier evidence | [Supplier register](sources.md) | [Cost ledger source IDs](chassis-bom.csv) |
| Assess a propulsion candidate | [Propulsion scope](../modules/02-drive-train/propulsion.md) | [Propulsion alternatives](propulsion-alternatives.csv) |
| Review requirements or release holds | [Chassis Build and Procurement Checklist](../chassis-build-requirements.md) | Checklist hold points |
| Validate generated costs and document references | [Cost update procedure](updating-linked-costs.md#regenerate-and-verify) | BOM generator and link checker |

## Module scopes

| Number | Module | Scope documents |
| --- | --- | --- |
| 01 | Structure and running gear | [Module folder](../modules/01-structure-and-running-gear/README.md) · [Frame](../modules/01-structure-and-running-gear/frame.md) · [Running gear](../modules/01-structure-and-running-gear/running-gear.md) |
| 02 | Drive train | [Module folder](../modules/02-drive-train/README.md) · [Propulsion](../modules/02-drive-train/propulsion.md) |
| 03 | Width adjustment | [Module folder](../modules/03-width-adjustment/README.md) · [Width adjustment](../modules/03-width-adjustment/width-adjustment.md) |
| 04 | Battery and charging | [Module folder](../modules/04-battery-and-charging/README.md) · [Batteries](../modules/04-battery-and-charging/batteries.md) |
| 05 | Power cables and electronics | [Module folder](../modules/05-power-cables-and-electronics/README.md) · [Cables and connectors](../modules/05-power-cables-and-electronics/cables-connectors.md) · [Power distribution](../modules/05-power-cables-and-electronics/power-distribution.md) |
| 06 | Safety controls and sensors | [Module folder](../modules/06-safety-controls-and-sensors/README.md) · [Safety controls](../modules/06-safety-controls-and-sensors/safety-controls.md) |
| 07 | Workshop and support | [Module folder](../modules/07-workshop-and-support/README.md) · [Workshop](../modules/07-workshop-and-support/workshop.md) |

[↑ Back to document overview](agent-index.md#document-overview)
