# Engineering BOM Agent Guide

<a id="document-overview"></a>

**Summary:** Use this guide to understand BOM ownership, numbered modules, and
the boundaries for agent changes. Follow the [BOM documentation skill](../../../.github/skills/bom-documentation/SKILL.md)
for the required editing and validation procedure.

**On this page:** [Authority map](agent-guide.md#authority-map) ·
[Module numbering](agent-guide.md#module-numbering) ·
[Change boundaries](agent-guide.md#change-boundaries)

**Related documents:**
[Agent index](agent-index.md) ·
[Chassis BOM](chassis-bom.md) ·
[Cost update procedure](updating-linked-costs.md)

## Authority map

| Information | Source of truth |
| --- | --- |
| Baseline item quantities, scenario prices, basis, source IDs, assumptions | [Cost ledger](chassis-bom.csv) |
| Cost-module ownership, display order, module/submodule numbers and scope links | [Cost module map](cost-modules.csv); scope paths route to the numbered folders in the [module directory](../modules/README.md) |
| Non-material provisions | [Budget allowances](budget-allowances.csv) |
| Supplier evidence and price limits | Single-scope evidence: the owning module page's **Supplier evidence** section. Weights, lookup and shared catalogs: [Sources](sources.md) |
| Candidate propulsion replacements, excluded from baseline totals | [Propulsion alternatives and technical-reference links](propulsion-alternatives.csv) |
| Generated module totals and cost tables | [Chassis BOM](chassis-bom.md), [BOM Cost Breakdown](../cost-breakdown.md), and generated scope tables |
| Technical requirements and interfaces | [Module directory](../modules/README.md) and [named requirement families](../chassis-build-requirements.md#2-confirm-item-family-specifications) |
| Procurement and release evidence | [Supplier request packages](../chassis-build-requirements.md#4-prepare-procurement-work-packages) and [release holds](../chassis-build-requirements.md#5-close-release-hold-points) |
| Human-readable headings and stable navigation | [Navigation maintenance rules](updating-linked-costs.md#navigation-labels-and-stable-references) |
| Scan-to-part and part-to-mounting reading paths | [Component navigation contract](updating-linked-costs.md#component-reading-paths); each technical owner keeps its local part links |

Generated Markdown is a view, not an input. Change the owning CSV and use the
documented generator; do not hand-edit generated regions.

[↑ Back to document overview](agent-guide.md#engineering-bom-agent-guide)

## Module numbering

The `category` and `label` columns in `cost-modules.csv` own visible numbering.
Each module uses a two-digit number; each submodule adds a two-digit sequence
(`MM.SS`). The same identifiers appear in the summary, detailed cost view, and
scope cost tables.

| Module | Submodule cost detail |
| --- | --- |
| 01 — Structure and running gear: [frame](../modules/01-structure-and-running-gear/frame.md) · [running gear](../modules/01-structure-and-running-gear/running-gear.md) | [01.01–01.07 Structure and running-gear costs](../cost-breakdown.md#01--structure-and-running-gear) |
| [02 — Drive train](../modules/02-drive-train/propulsion.md) | [02.01–02.05 Drive-train costs](../cost-breakdown.md#02--drive-train) |
| [03 — Width adjustment](../modules/03-width-adjustment/width-adjustment.md) | [03.01–03.04 Width-adjustment costs](../cost-breakdown.md#03--width-adjustment) |
| [04 — Battery and charging](../modules/04-battery-and-charging/batteries.md) | [04.01–04.04 Battery and charging costs](../cost-breakdown.md#04--battery-and-charging) |
| 05 — Power cables and electronics: [cables and connectors](../modules/05-power-cables-and-electronics/cables-connectors.md) · [power distribution](../modules/05-power-cables-and-electronics/power-distribution.md) | [05.01–05.08 Wiring and power-distribution costs](../cost-breakdown.md#05--power-cables-and-electronics) |
| [06 — Safety controls and sensors](../modules/06-safety-controls-and-sensors/safety-controls.md) | [06.01, 06.03–06.07 Safety and sensing costs](../cost-breakdown.md#06--safety-controls-and-sensors) |
| [07 — Workshop and support](../modules/07-workshop-and-support/workshop.md) | [07.01–07.02, 07.04–07.06 Workshop and support costs](../cost-breakdown.md#07--workshop-and-support) |

Each module has its own folder under
[`docs/engineering/modules/`](../modules/README.md), listed in the single
module directory. Scope documents live in their owning module folder. Module 05's power and wiring requirements and
Module 06's safety controls are separate technical documents; the cost module
map still owns item numbering and exactly-once cost ownership.

These are navigation and cross-reference numbers, not controlled document
numbers, item IDs, or specification-family IDs. Existing document identifiers
such as `MBR-ENG-BOM-001`, ledger item IDs, and `PS##` requirements remain
unchanged. Do not assign a submodule based on a scope filename: one cost module
can span multiple technical scopes, and one scope can own several submodules.
Preserve established numbers when editing labels; assign the next available
submodule within its module when adding a genuinely new cost submodule.
The gaps are the retired
[industrial remote (06.02)](../modules/06-safety-controls-and-sensors/safety-controls.md#decision-records)
and [dynamometer/torque measurement (07.03)](../modules/07-workshop-and-support/workshop.md#decision-records);
do not reuse those numbers for unrelated scope.

[↑ Back to document overview](agent-guide.md#engineering-bom-agent-guide)

## Change boundaries

- Keep baseline materials, alternatives, budget provisions, supplier evidence,
  and engineering requirements distinct. A candidate is not an approved
  configuration change; an allowance is not a supplier quote.
- Maintain exactly-once item ownership in the cost-module map. Scope links
  identify technical owners and do not duplicate quantities or costs.
- Organize human entry points around parts and current choices, not a wall of
  specification IDs. A reader inspecting a motor must be able to open its price,
  data, and track/frame attachment from that detail; a generic link back to a
  module index is not sufficient. Distinguish missing mounting data from a
  released design and do not invent dimensions to fill a navigation gap.
- Preserve qualification holds and evidence labels. Passing document checks
  does not qualify parts, release procurement, or authorize machine operation.
- For generator or module-map changes, run the focused BOM generator tests,
  regenerate and freshness-check linked tables, then run the BOM link suite and
  `git diff --check` as documented in the [update procedure](updating-linked-costs.md).

[↑ Back to document overview](agent-guide.md#engineering-bom-agent-guide)
