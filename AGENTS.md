# Agent Documentation Router

Before investigating, planning, editing, testing, reviewing, or documenting any
request in this repository, read:

1. [Documentation index](docs/index.md)
2. [Project guardrails](docs/agents/project-guardrails.md)
3. [Documentation guardrails](docs/agents/documentation-guardrails.md)

Then load only the scoped document needed for the task. For product, hardware,
safety, or autonomy decisions, also read the
[project overview](docs/project/overview.md) and the relevant sections of
[plan.md](plan.md).

For documentation or BOM changes, load the project skill
[bom-documentation](.github/skills/bom-documentation/SKILL.md). If the client
does not list it, read that file directly. BOM edits must regenerate linked
cost tables and pass the skill's freshness check before handoff.
For engineering BOM-specific ownership and module routing, use the
[BOM agent index](docs/engineering/agents/agent-index.md) and
[agent guide](docs/engineering/agents/agent-guide.md).

All implementation slices in the
[app improvement plan](docs/flutter/implementation-improvement-plan.md) must
follow the [mandatory test-driven workflow](docs/agents/project-guardrails.md#mandatory-test-driven-development).
Write and run the relevant tests before changing implementation; do not defer
coverage until after the refactor.

The plan describes the intended machine, not completed implementation or
certified safety. Existing firmware is a prototype; documentation or code
changes do not authorize operating, uploading to, or deploying the machine.
