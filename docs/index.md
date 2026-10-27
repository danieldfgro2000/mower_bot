# Documentation Index

[Root agent router](../AGENTS.md) | [Repository README](../README.md)

All tasks start with [project guardrails](agents/project-guardrails.md) and
[documentation guardrails](agents/documentation-guardrails.md), then the
narrowest applicable scope below.

## Chassis engineering reading path

1. Start with the [Chassis BOM](engineering/chassis-bom.md) for what is in the
   estimate, what it costs, and what is explicitly excluded.
2. Use the [Chassis Build and Procurement Checklist](engineering/chassis-build-requirements.md)
   to follow the evidence and release holds before any purchase or build.
3. Open the linked [BOM scope](engineering/chassis-bom.md#bom-by-scope) for a
   part family's requirements, cost detail, and inspection evidence. Use the
   [supplier register](engineering/bom/sources.md) and
   [feedback decisions](engineering/bom/feedback.md) for sourcing context and
   dated decisions.
4. For a cost change, follow [Updating linked costs](engineering/bom/updating-linked-costs.md);
   do not edit generated tables directly.

On a scope page, start with its summary, then follow the design or requirements
through supplier evidence, interfaces, and itemized costs. Use the opening
navigation links to jump to a topic or its estimate context; section-end
**Back to document overview** links return to the summary so you can choose
another route.

| Scope | Authoritative starting point |
| --- | --- |
| Agent behavior, architecture, safety, cleanup | [Project guardrails](agents/project-guardrails.md) |
| Documentation ownership and adaptation policy | [Documentation guardrails](agents/documentation-guardrails.md) |
| BOM maintenance: inputs, cost regeneration and reference checks | [Updating linked costs](engineering/bom/updating-linked-costs.md) · [BOM documentation skill](../.github/skills/bom-documentation/SKILL.md) |
| Product direction and current implementation gaps | [Project overview](project/overview.md) |
| Engineering targets, business assumptions, build gates | [Root plan](../plan.md) |
| Flutter UI, BLoCs, use cases, repositories, local checks | [Flutter development](flutter/development.md) |
| App implementation review and proposed module/package improvements | [App improvement plan](flutter/implementation-improvement-plan.md) |
| ESP32/Mega ownership, wire/storage contracts, build prerequisites | [Firmware development](firmware/development.md) |
| Chassis cost summary and 48 V / 72 V comparison | [Chassis BOM](engineering/chassis-bom.md) · [BOM Cost Breakdown](engineering/cost-breakdown.md) · [Cost ledger](engineering/chassis-bom.csv) |
| Module cost tables and detailed requirements | [BOM Cost Breakdown](engineering/cost-breakdown.md) · [Drive train](engineering/bom/propulsion.md) · [Batteries and charging](engineering/bom/batteries.md) · [Cables](engineering/bom/cables-connectors.md) · [Electronics and safety](engineering/bom/electronics.md) |
| Scoped BOM: running gear, propulsion, frame, width adjustment, batteries, wiring, electronics and workshop | [Scope directory in Chassis BOM](engineering/chassis-bom.md#bom-by-scope) |
| Drawings, supplier evidence and inspections still required before purchase/build | [Chassis Build and Procurement Checklist](engineering/chassis-build-requirements.md) |
| Width packaging, 40° site target, and preliminary stability/traction calculations | [Width and slope feasibility screen](engineering/width-and-slope-sizing.md) |

There is no Firebase/backend, OTA deployment, or PlatformIO workflow configured
in this repository. Do not infer one from Bee Hive Monitor or installed skills.
Do not create empty documentation scopes for unimplemented features.
