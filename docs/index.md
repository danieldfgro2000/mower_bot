# Documentation Index

[Root agent router](../AGENTS.md) | [Repository README](../README.md)

All tasks start with [project guardrails](agents/project-guardrails.md) and
[documentation guardrails](agents/documentation-guardrails.md), then the
narrowest applicable scope below.

| Scope | Authoritative starting point |
| --- | --- |
| Agent behavior, architecture, safety, cleanup | [Project guardrails](agents/project-guardrails.md) |
| Documentation ownership and adaptation policy | [Documentation guardrails](agents/documentation-guardrails.md) |
| Product direction and current implementation gaps | [Project overview](project/overview.md) |
| Engineering targets, business assumptions, build gates | [Root plan](../plan.md) |
| Flutter UI, BLoCs, use cases, repositories, local checks | [Flutter development](flutter/development.md) |
| ESP32/Mega ownership, wire/storage contracts, build prerequisites | [Firmware development](firmware/development.md) |

There is no Firebase/backend, OTA deployment, or PlatformIO workflow configured
in this repository. Do not infer one from Bee Hive Monitor or installed skills.
Do not create empty documentation scopes for unimplemented features.
