# Engineering BOM Agent Guide

<a id="document-overview"></a>

**Summary:** Use this guide to understand BOM ownership, numbered modules, and
the boundaries for agent changes. Follow the [BOM documentation skill](../../../.github/skills/bom-documentation/SKILL.md)
for the required editing and validation procedure.

**Navigate:** [Authority map](agent-guide.md#authority-map) ·
[Module numbering](agent-guide.md#module-numbering) ·
[Change boundaries](agent-guide.md#change-boundaries) |
[Agent index](agent-index.md) ·
[Chassis BOM](chassis-bom.md) ·
[Cost update procedure](updating-linked-costs.md)

## Authority map

| Information | Source of truth |
| --- | --- |
| Baseline item quantities, scenario prices, basis, source IDs, assumptions | [Cost ledger](chassis-bom.csv) |
| Cost-module ownership, display order, module/submodule numbers and scope links | [Cost module map](cost-modules.csv); scope paths route to the numbered folders in the [module directory](../modules/README.md) |
| Non-material provisions | [Budget allowances](budget-allowances.csv) |
| Supplier evidence and price limits | [Supplier register](sources.md) |
| Candidate propulsion replacements, excluded from baseline totals | [Propulsion alternatives](propulsion-alternatives.csv) |
| Generated module totals and cost tables | [Chassis BOM](chassis-bom.md), [BOM Cost Breakdown](../cost-breakdown.md), and generated scope tables |
| Technical requirements and interfaces | The module folders and linked engineering [scope documents](chassis-bom.md#bom-by-scope) |
| Procurement and release evidence | [Chassis Build and Procurement Checklist](../chassis-build-requirements.md) |

Generated Markdown is a view, not an input. Change the owning CSV and use the
documented generator; do not hand-edit generated regions.

## Module numbering

The `category` and `label` columns in `cost-modules.csv` own visible numbering.
Each module uses a two-digit number; each submodule adds a two-digit sequence
(`MM.SS`). The same identifiers appear in the summary, detailed cost view, and
scope cost tables.

| Module | Submodule range | Module |
| --- | --- | --- |
| 01 | 01.01–01.07 | Structure and running gear |
| 02 | 02.01–02.05 | Drive train |
| 03 | 03.01–03.04 | Width adjustment |
| 04 | 04.01–04.04 | Battery and charging |
| 05 | 05.01–05.08 | Power cables and electronics |
| 06 | 06.01–06.07 | Safety controls and sensors |
| 07 | 07.01–07.06 | Workshop and support |

Each module has its own folder and overview page under
[`docs/engineering/modules/`](../modules/README.md). Scope documents live in
their owning module folder. Module 05's power and wiring requirements and
Module 06's safety controls are separate technical documents; the cost module
map still owns item numbering and exactly-once cost ownership.

These are navigation and cross-reference numbers, not controlled document
numbers, item IDs, or specification-family IDs. Existing document identifiers
such as `MBR-ENG-BOM-001`, ledger item IDs, and `PS##` requirements remain
unchanged. Do not assign a submodule based on a scope filename: one cost module
can span multiple technical scopes, and one scope can own several submodules.
Preserve established numbers when editing labels; assign the next available
submodule within its module when adding a genuinely new cost submodule.

## Change boundaries

- Keep baseline materials, alternatives, budget provisions, supplier evidence,
  and engineering requirements distinct. A candidate is not an approved
  configuration change; an allowance is not a supplier quote.
- Maintain exactly-once item ownership in the cost-module map. Scope links
  identify technical owners and do not duplicate quantities or costs.
- Preserve qualification holds and evidence labels. Passing document checks
  does not qualify parts, release procurement, or authorize machine operation.
- For generator or module-map changes, run the focused BOM generator tests,
  regenerate and freshness-check linked tables, then run the BOM link suite and
  `git diff --check` as documented in the [update procedure](updating-linked-costs.md).

[↑ Back to document overview](agent-guide.md#document-overview)
