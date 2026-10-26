# Documentation Index

[Root agent router](../AGENTS.md) | [Repository README](../README.md)

All tasks start with [project guardrails](agents/project-guardrails.md) and
[documentation guardrails](agents/documentation-guardrails.md), then the
narrowest applicable scope below.

| Scope | Authoritative starting point |
| --- | --- |
| Agent behavior, architecture, safety, cleanup | [Project guardrails](agents/project-guardrails.md) |
| Documentation ownership and adaptation policy | [Documentation guardrails](agents/documentation-guardrails.md) |
| Project documentation skill and linked BOM cost regeneration | [BOM documentation skill](../.github/skills/bom-documentation/SKILL.md) · [Updating BOM costs](engineering/chassis-bom.md#updating-linked-costs) |
| Product direction and current implementation gaps | [Project overview](project/overview.md) |
| Engineering targets, business assumptions, build gates | [Root plan](../plan.md) |
| Flutter UI, BLoCs, use cases, repositories, local checks | [Flutter development](flutter/development.md) |
| App implementation review and proposed module/package improvements | [App improvement plan](flutter/implementation-improvement-plan.md) |
| ESP32/Mega ownership, wire/storage contracts, build prerequisites | [Firmware development](firmware/development.md) |
| Chassis parts, itemized costs and 48 V / 72 V comparison | [Chassis BOM and Cost Breakdown](engineering/chassis-bom.md) · [Itemized CSV](engineering/chassis-bom.csv) |
| Module cost tables: drivetrain, batteries/BMS/chargers, cables, sensors and controls | [Linked module cost breakdown](engineering/chassis-bom.md#material-and-equipment-totals) · [Drive train](engineering/chassis-bom.md#drive-train) · [Batteries and charging](engineering/chassis-bom.md#battery-and-charging) · [Cables and electronics](engineering/chassis-bom.md#power-cables-and-electronics) · [Sensors and controls](engineering/chassis-bom.md#safety-controls-and-sensors) |
| Scoped BOM: running gear, propulsion, frame, width adjustment, batteries, wiring, electronics and workshop | [BOM scope navigation](engineering/chassis-bom.md#bom-by-scope) |
| Drawings, supplier evidence and inspections still required before purchase/build | [Chassis Build and Procurement Checklist](engineering/chassis-build-requirements.md) |
| Width packaging, 40° site target, and preliminary stability/traction calculations | [Width and slope feasibility screen](engineering/width-and-slope-sizing.md) |

There is no Firebase/backend, OTA deployment, or PlatformIO workflow configured
in this repository. Do not infer one from Bee Hive Monitor or installed skills.
Do not create empty documentation scopes for unimplemented features.
