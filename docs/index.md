# Documentation index

[Root agent router](../AGENTS.md) | [Repository README](../README.md)

Start with the [project guardrails](agents/project-guardrails.md) and
[documentation guardrails](agents/documentation-guardrails.md), then follow the
audience-specific owner below.

## Engineering documentation

The engineering documentation has three connected categories:

| Audience | Use this category for | Entry point |
| --- | --- | --- |
| **Presentation** | Concise pitch, selected dimensions, public prices and sources; includes the 3D viewer | [Generated pitch](engineering/presentation/README.md) |
| **Engineering** | Technical requirements, detailed source evidence, fit studies, BOM and CAD | [Technical index](engineering/technical/README.md) |
| **Agents** | Repository-specific routing, ownership and maintenance procedures | [Engineering agent guide](engineering/agents/README.md) |

The [engineering hub](engineering/README.md) connects these categories and
documents local viewer setup. Presentation pages are generated from
engineering-owned data; use the [BOM documentation skill](../.github/skills/bom-documentation/SKILL.md)
to update and freshness-check them. Candidate facts and supplier claims are
not qualification or purchase approval.

## Application and firmware

| Scope | Owner |
| --- | --- |
| Product direction, current implementation gaps and build gates | [Project overview](project/overview.md) · [Root plan](../plan.md) |
| Flutter UI, BLoCs, use cases, repositories and local checks | [Flutter development](flutter/development.md) |
| App implementation review and proposed module/package improvements | [App improvement plan](flutter/implementation-improvement-plan.md) |
| ESP32/Mega ownership, wire/storage contracts and build prerequisites | [Firmware development](firmware/development.md) |

There is no Firebase/backend, OTA deployment, or PlatformIO workflow configured
in this repository. Do not infer one from unrelated projects or installed skills.
Do not create empty documentation scopes for unimplemented features.

## Developer tools

[Agent Work Timer](agents/agent-work-timer.md) is a local JetBrains plugin with
explicit task boundaries, timestamped phases and IDE activity reports. It does
not automatically observe Copilot lifecycle events or internal reasoning.
