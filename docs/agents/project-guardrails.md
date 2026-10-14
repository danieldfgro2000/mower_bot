# Project Agent Guardrails

## Product authority and status

[plan.md](../../plan.md) owns the intended product and build gates.
[Project overview](../project/overview.md) separates that intent from the current
Flutter/ESP32/Mega prototype. Read both before changing machine architecture,
operating modes, safety behavior, or autonomy.

- Preserve the two self-contained tracked pods, variable-width scissor frame,
  longitudinal implement spine, and first DAC 9100 underbody mower direction.
  Do not reintroduce the excluded four-column cage.
- Treat battery, mass, motor, torque, speed, slope, runtime, and business figures
  according to their evidence labels in the plan. Supplier claims and sizing
  estimates are not measured capability or approved operating limits.
- Prioritize supervised operation, safety, serviceability, and reliability.
  Do not silently promote timed steering playback to RTK Teach & Repeat.
- Do not claim production readiness, legal compliance, or certified safety from
  passing software tests or from the plan's "validated project decisions."

## Physical safety and operational authority

These are requirements for changes, not claims that all safeguards exist today.

- Safety must not depend solely on Flutter, Wi-Fi, the ESP32, navigation, or
  normal motor software. The plan requires an independently testable safe-state
  path for propulsion and implements.
- Never bypass, weaken, or hide emergency-stop, heartbeat, watchdog, interlock,
  homing, limit, or fault behavior to make a feature work. Stop and seek an
  explicit design decision if the requested behavior conflicts with safety.
- Never automatically arm, resume motion, restart an implement, or replay a
  route after reconnection, reboot, recovery, or emergency stop. Require an
  explicit operator action and the applicable safety gates.
- Do not queue or automatically retry stale motion/start/playback commands.
  Reconnecting a transport is not authorization to repeat physical actions.
- A sent command or connected socket is not evidence that the machine executed
  the action or stopped. Keep requested, acknowledged, and observed state
  distinct; do not present missing/stale telemetry as a verified safe state.
- Camera, SD, network, and telemetry work must not starve safety processing.
  Trace failure handling through every participating controller.
- Uploads, OTA publication, serial monitor starts/restarts, device resets,
  live control/playback, destructive SD operations, and field tests require
  explicit user authorization for that operation and target. Opening a serial
  port can reset hardware; it is not a harmless documentation check.
- Purchases, cloud provisioning, releases, and changes to live infrastructure
  are also user-controlled. Documentation and local build approval do not
  authorize these actions.

## Architecture and dependencies

Use the existing Flutter, BLoC, Equatable, GetIt, repository/use-case, and
stream-based telemetry patterns. [Flutter development](../flutter/development.md)
owns the concrete module map.

- Keep feature presentation/domain code under `lib/features/`; shared transport,
  DTOs, repository implementations, platform adapters, and DI currently live in
  `lib/core/`. Do not relocate the whole app to match a template.
- Presentation calls use cases; business policy belongs in domain/use cases.
  Domain abstractions should not depend on UI or concrete transport classes.
  Data implementations depend on domain contracts and map DTOs into domain
  models. Runtime call flow is not permission for inward layers to import data.
- Register dependencies centrally in
  [injection_container.dart](../../lib/core/di/injection_container.dart).
  Preserve named clients and shared-versus-factory lifecycles. Do not construct
  networking or repositories in widgets.
- Use immutable state, focused BLoCs, and explicit stream/timer disposal.
  Keep JSON, persistence, retry machinery, and platform APIs out of widgets.
- Follow the actual dependency manifest, not Bee Hive Monitor's package list.
  Do not introduce Firebase, MQTT, Dio, Hive/Isar, Freezed, or a new state
  framework without a concrete requirement.
- Do not vendor or override packages merely to suppress upstream warnings.
  A necessary override must be reproducible, committed where appropriate, and
  documented with its reason, validation, upstream reference, and removal gate.

## Change execution and cleanup

- Inspect the owning code and tests first. Make the smallest complete change
  across affected consumers, DI, routing, firmware, and documentation.
- Prefer KISS, DRY, single responsibility, clear naming, and existing helpers.
  Avoid speculative frameworks, duplicate abstractions, and unrelated cleanup.
- Keep new handwritten Dart implementation files at or below 100 lines of code;
  split by responsibility and layer. Do not grow oversized existing files
  unnecessarily or mechanically split unrelated code. Generated files and test
  fixtures are not a reason to distort implementation structure.
- Every non-trivial code change includes a scoped cleanup pass: remove replaced
  routes, widgets, helpers, DI entries, assets/strings, tests, and obsolete docs
  when their replacement and lack of consumers are established.
- Pre-production status is not permission to break an installed controller or
  saved path format. Establish firmware/library consumers and migration needs
  before removing protocol compatibility. Ask if device versions are unknown.
- Preserve unrelated user changes. Do not commit, amend history, replace the
  plan, or modify another repository as a side effect of the task.
- Default to work in the current agent session. Delegate only with explicit
  user approval of the scope and model; keep deliverables bounded.

## Errors, configuration, and UI

- Reuse the existing `lib/core/error/` facilities and the owning BLoC's error
  surface rather than adding another error framework. Avoid silent catches,
  success-shaped fallbacks, and unreported validation failures.
- Keep diagnostic logs useful and redacted. Do not expose raw secrets or
  credential-bearing payloads in UI, documentation, logs, or commits.
- Derive endpoints, ports, pins, timing, units, and thresholds from the exact
  owning code/configuration. Mark unknown values as required input; never
  invent credentials, board profiles, safe limits, or deployment settings.
- The current local prototype uses plain WebSocket/HTTP. Do not describe it as
  authenticated or encrypted, or expose it to public networks as-is. A secured
  remote-control design is a separate cross-layer task.
- Keep controls responsive, readable, accessible, and usable with constrained
  layouts and text scaling. Emergency controls must remain available and clear.
  Reuse local UI conventions; localization infrastructure is not currently
  configured, so do not reference nonexistent localization helpers.

## Validation and handoff

- Use a short test-driven loop: identify the behavior and affected layers, add
  focused regression coverage, implement, validate, and perform scoped cleanup.
- Run relevant local tests and static analysis for code changes. Expand to the
  full Flutter suite for shared transport, DI, or cross-feature behavior changes.
  Commands and firmware prerequisites are in the scoped development docs.
- Test failure/disconnection, stale data, cancellation, repeated entry, and
  resource lifecycle cases, not just successful command submission.
- For safety-sensitive changes, define the expected safe-state sequence and
  measurable acceptance evidence before implementation. Automated checks do
  not replace independently observed hardware validation.
- Explain blocked checks and pre-existing failures honestly. Fix regressions
  caused by the change; do not turn an unrelated failure into an unapproved
  refactor or claim unperformed hardware validation.
- Prose-only changes need link/reference inspection, not app builds or tests.
  Update the owning docs and report meaningful limitations without inventing
  tool results, model credits, measurements, or completion evidence.
- Use available, applicable skills. Documentation work routes to
  `documentation-maintenance`; Flutter work to `flutter-feature-development`
  and appropriate testing/layout skills; firmware work to
  `arduino-esp32-firmware` / `arduino-development`. A skill never authorizes
  hardware operation or imports Bee Hive-specific deployment workflows.
