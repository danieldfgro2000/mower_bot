# Documentation Index

[Root agent router](../AGENTS.md) | [Repository README](../README.md)

All tasks start with [project guardrails](agents/project-guardrails.md) and
[documentation guardrails](agents/documentation-guardrails.md), then the
narrowest applicable scope below.

## Chassis engineering reading path

1. Start with the [Chassis BOM](engineering/bom/chassis-bom.md) for what is in the
   estimate, or jump straight to its [component routes](engineering/bom/chassis-bom.md#bom-by-scope).
2. Choose a part in **Parts at a glance**, then open its price, specifications,
   or mounting/connection link. For example:
   [HPM5000B](engineering/modules/02-drive-train/propulsion.md#hpm5000b-main-motor-candidate)
   → [price](engineering/modules/02-drive-train/propulsion.md#hpm5000b-purchase-scope-and-price)
   / [specifications](engineering/modules/02-drive-train/propulsion.md#hpm5000b-ratings-and-sourcing-limits)
   → [motor-to-track mounting](engineering/modules/02-drive-train/propulsion.md#motor-to-track-mounting).
3. Use **Part links** or **Continue** in the detail to move to the adjoining
   component without returning to an index. Each module page also holds
   its own supplier evidence, decision records and release holds; the
   [source lookup](engineering/bom/sources.md#source-id-lookup) and
   [feedback index](engineering/bom/feedback.md) list every record by ID.
4. Before any purchase or build, use the
   [Chassis Build and Procurement Checklist](engineering/chassis-build-requirements.md)
   for the required evidence and release holds; browsing is not authorization.
5. For a cost change, follow [Updating linked costs](engineering/bom/updating-linked-costs.md);
   do not edit generated tables directly.

Cost-item names link to their purchasing and inspection requirements, with
component links at that destination. References use descriptive names such as
[Workshop tools (PS36)](engineering/modules/07-workshop-and-support/workshop.md#ps36-instruments-and-workshop-tools),
not codes alone. **Back to document overview** remains an optional reset, not
the required route between a part's cost, data, and fit.

| Scope | Authoritative starting point |
| --- | --- |
| Agent behavior, architecture, safety, cleanup | [Project guardrails](agents/project-guardrails.md) |
| Documentation ownership and adaptation policy | [Documentation guardrails](agents/documentation-guardrails.md) |
| BOM maintenance: inputs, cost regeneration and reference checks | [Updating linked costs](engineering/bom/updating-linked-costs.md) · [BOM documentation skill](../.github/skills/bom-documentation/SKILL.md) |
| Agent routing and ownership for engineering BOM work | [Engineering BOM Agent Index](engineering/bom/agent-index.md) · [Engineering BOM Agent Guide](engineering/bom/agent-guide.md) |
| Product direction and current implementation gaps | [Project overview](project/overview.md) |
| Engineering targets, business assumptions, build gates | [Root plan](../plan.md) |
| Flutter UI, BLoCs, use cases, repositories, local checks | [Flutter development](flutter/development.md) |
| App implementation review and proposed module/package improvements | [App improvement plan](flutter/implementation-improvement-plan.md) |
| ESP32/Mega ownership, wire/storage contracts, build prerequisites | [Firmware development](firmware/development.md) |
| Chassis cost summary and active 48 V baseline | [Chassis BOM](engineering/bom/chassis-bom.md) · [BOM Cost Breakdown](engineering/cost-breakdown.md) · [Cost ledger](engineering/bom/chassis-bom.csv) |
| Numbered engineering modules and their technical scopes | [Module directory](engineering/modules/README.md) |
| Module cost tables and detailed requirements | [BOM Cost Breakdown](engineering/cost-breakdown.md) · [Drive train](engineering/modules/02-drive-train/propulsion.md) · [Batteries and charging](engineering/modules/04-battery-and-charging/batteries.md) · [Cables](engineering/modules/05-power-cables-and-electronics/cables-connectors.md) · [Power distribution](engineering/modules/05-power-cables-and-electronics/power-distribution.md) · [Safety controls](engineering/modules/06-safety-controls-and-sensors/safety-controls.md) |
| Scoped BOM: running gear, propulsion, frame, width adjustment, batteries, wiring, electronics and workshop | [Scope directory in Chassis BOM](engineering/bom/chassis-bom.md#bom-by-scope) |
| Drawings, supplier evidence and inspections still required before purchase/build | [Chassis Build and Procurement Checklist](engineering/chassis-build-requirements.md) |
| Width packaging, 40° site target, and preliminary stability/traction calculations | [Width and slope feasibility screen](engineering/width-and-slope-sizing.md) |

There is no Firebase/backend, OTA deployment, or PlatformIO workflow configured
in this repository. Do not infer one from Bee Hive Monitor or installed skills.
Do not create empty documentation scopes for unimplemented features.
