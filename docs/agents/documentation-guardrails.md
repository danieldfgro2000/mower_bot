# Documentation Guardrails

## Ownership

| Topic | Owner |
| --- | --- |
| Agent entry point | [AGENTS.md](../../AGENTS.md), kept as a compact router |
| Human entry point | [README.md](../../README.md) |
| Product, engineering/business assumptions, open decisions, build gates | [plan.md](../../plan.md) |
| Documentation navigation | [docs/index.md](../index.md) |
| Agent behavior and safety constraints | [Project guardrails](project-guardrails.md) |
| Documentation policy and reuse provenance | This document |
| Current implementation versus product direction | [Project overview](../project/overview.md) |
| Flutter architecture, feature ownership, tests | [Flutter development](../flutter/development.md) |
| App review findings and proposed module/package migration | [App improvement plan](../flutter/implementation-improvement-plan.md) |
| Firmware, app/device protocol, path storage, build prerequisites | [Firmware development](../firmware/development.md) |

Maintain one authoritative owner per topic and link from other scopes. Split a
topic into a dedicated document only when its size or independent ownership
justifies it; update the index at the same time.

## Placement and updates

- Preserve the existing root `README.md` and `plan.md`; do not move them to
  reproduce another repository's layout. Keep `AGENTS.md` discoverable at root.
- Use lower-case kebab-case for new topic documents under the relevant `docs/`
  scope. Do not create competing `agents.md` / `AGENTS.md` files.
- Update documentation in the same change as behavior, protocol, configuration,
  navigation, or operational guidance. Cross-layer changes update the contract
  owner and link affected consumers rather than copying separate specifications.
- Improvement plans must link to the
  [mandatory test-driven workflow](project-guardrails.md#mandatory-test-driven-development)
  and define test-first gates for each implementation phase. Record actual
  per-slice test evidence in the owning implementation document; keep proposed
  acceptance tests visibly separate from executed results.
- Keep current behavior, intended requirements, unverified assumptions, and
  historical evidence visibly separate. Source code establishes implementation;
  the plan establishes intent. Document discrepancies rather than silently
  changing one to make the other appear complete.
- Preserve the plan's evidence labels. "Validated" project direction does not
  certify component ratings or machine safety; supplier listings remain claims.
- Do not rewrite or replace the plan during unrelated implementation work.
  Material changes to architecture, operating envelope, or stage gates require
  an explicit decision and corresponding plan update.
- When moving/renaming a document, update relative links, anchors, navigation,
  and inbound references in the same change. Archive only genuinely historical
  material; do not invent an archive directory for current guidance.

## Configuration, safety, and verification

- Link concrete setup values to their exact owning configuration or code.
  Comments, sample CI matrices, nearby devices, and another project are not
  proof of an installed board, endpoint, library version, or safe operating limit.
- Use explicit placeholders such as `<VERIFIED_FQBN>` and `<PORT>` for unknown
  inputs and explain who must confirm them. Use repository-relative paths, not
  contributor-specific absolute paths.
- Never copy credentials, tokens, private configuration, device/customer
  identifiers, or historical credit/model records from the reference project.
  Document required secret names only when verified from their consumers.
- Distinguish a local build from upload, monitoring, provisioning, or operating
  hardware. Inspect side-effecting commands instead of executing them to check
  documentation. Follow the operational boundary in the project guardrails.
- Check changed links/anchors, referenced files, command working directories,
  and flags. No documentation checker is currently configured; inspect directly
  without adding a toolchain or running application tests for prose-only work.

## Bee Hive Monitor adaptation

The initial guidance was adapted on 2026-10-14 from Bee Hive Monitor's root
`agents.md`, `docs/index.md`, `docs/agents/project-guardrails.md`,
`docs/agents/documentation-guardrails.md`, and its Flutter, firmware, and
operations documentation. Those files were read as references, not modified.
This repository's documents are self-contained; they do not require a sibling
checkout or automatically inherit future Bee Hive Monitor changes.

Retained: mandatory guardrail loading, narrow documentation routing,
BLoC/GetIt and repository/use-case boundaries, small focused source files,
scoped cleanup, dependency-override discipline, test-driven changes, exact-source
configuration, explicit failures, and user-controlled live/hardware actions.

Adapted: MowerBot retains its shared `lib/core/data/` layout, existing packages,
root plan, and Arduino sketches. Dependency direction is described in terms of
domain contracts rather than importing concrete data code into domain.
Compatibility removal is gated on actual firmware/storage consumers.

Not imported: beehive features, Firebase/Firestore, GSM/power schedules, weather,
subscriptions, OTA scripts, PlatformIO environments, local skill copies,
absolute machine paths, or historical implementation thumbprints. Offline
monitoring advice to queue/retry commands is explicitly unsuitable for mower
motion. Existing plain local networking is documented as a limitation, not
silently relabeled as HTTPS-only. Unrelated source-project failures and package
preferences do not authorize expanding a MowerBot task.
