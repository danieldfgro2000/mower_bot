# Engineering BOM Agent Index

<a id="document-overview"></a>

**Summary:** Route agents to the authoritative engineering BOM inputs,
procedures, and module scopes. This index does not replace repository
guardrails or the BOM maintenance skill.

**Start here:** [Engineering BOM agent guide](agent-guide.md) ·
[Documentation index](../../index.md) ·
[BOM documentation skill](../../../.github/skills/bom-documentation/SKILL.md)

## Task routing

| Task | Start with | Authoritative owner |
| --- | --- | --- |
| Understand module numbers and document boundaries | [Agent guide](agent-guide.md) | [Cost module map](cost-modules.csv) |
| Change quantities, prices, or cost basis | [Cost update procedure](updating-linked-costs.md) | [Cost ledger](../chassis-bom.csv) |
| Change module ownership, numbering, or scope mapping | [Agent guide](agent-guide.md#module-numbering) | [Cost module map](cost-modules.csv) |
| Update supplier evidence | [Supplier register](sources.md) | [Cost ledger source IDs](../chassis-bom.csv) |
| Assess a propulsion candidate | [Propulsion scope](propulsion.md) | [Propulsion alternatives](propulsion-alternatives.csv) |
| Review requirements or release holds | [Chassis Build and Procurement Checklist](../chassis-build-requirements.md) | Checklist hold points |
| Validate generated costs and document references | [Cost update procedure](updating-linked-costs.md#regenerate-and-verify) | BOM generator and link checker |

## Module scopes

| Number | Module | Scope documents |
| --- | --- | --- |
| 01 | Structure and running gear | [Frame](frame.md) · [Running gear](running-gear.md) |
| 02 | Drive train | [Propulsion](propulsion.md) |
| 03 | Width adjustment | [Width adjustment](width-adjustment.md) |
| 04 | Battery and charging | [Batteries](batteries.md) |
| 05 | Power cables and electronics | [Cables and connectors](cables-connectors.md) · [Electronics](electronics.md) |
| 06 | Safety controls and sensors | [Electronics](electronics.md) |
| 07 | Workshop and support | [Workshop](workshop.md) |

[↑ Back to document overview](agent-index.md#document-overview)
