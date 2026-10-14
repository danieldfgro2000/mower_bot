# Flutter Development

## Architecture and ownership

Read [project guardrails](../agents/project-guardrails.md) first. The package
manifest is [pubspec.yaml](../../pubspec.yaml); use its SDK constraint and
existing dependencies rather than installing Bee Hive Monitor's stack.

The current organization is feature-first presentation/domain with shared data
infrastructure, not a separate data directory inside every feature:

The [implementation review and improvement plan](implementation-improvement-plan.md)
proposes a staged ownership/module migration. It is not the current architecture
or approval to reorganize the app during unrelated work.

| Scope | Owner and important consumers |
| --- | --- |
| Startup and DI | [`main.dart`](../../lib/main.dart), [`injection_container.dart`](../../lib/core/di/injection_container.dart) |
| Navigation/lifecycle | [`app_router.dart`](../../lib/app_router.dart), [`app_shell.dart`](../../lib/shell/app_shell.dart); stateful indexed-stack branches |
| Connection | [`features/connection`](../../lib/features/connection), [`core/platform`](../../lib/core/platform), [`connection_repository_impl.dart`](../../lib/core/data/repo/connection_repository_impl.dart) |
| Manual control and camera | [`features/control`](../../lib/features/control), [`control_repository_impl.dart`](../../lib/core/data/repo/control_repository_impl.dart) |
| Path management | [`features/paths`](../../lib/features/paths), [`path_repository_remote_impl.dart`](../../lib/core/data/repo/path_repository_remote_impl.dart) |
| Telemetry | [`features/telemetry`](../../lib/features/telemetry), [`telemetry_repository_impl.dart`](../../lib/core/data/repo/telemetry_repository_impl.dart), [`core/data/dto`](../../lib/core/data/dto) |
| Transport and errors | [`core/data/network`](../../lib/core/data/network), [`core/error`](../../lib/core/error) |

GetIt registers named `IWebSocketClient` instances `ctrl` and `binary`.
`TelemetryBloc` is shared; connection, control, and path BLoCs are registered as
factories. Preserve actual ownership and disposal rather than creating duplicate
listeners when a tab becomes active again.

`PathRepositoryRemote` is the selected path repository; the abstraction
`PathRepository` currently lives in
[`core/data/repo/path_repository_impl.dart`](../../lib/core/data/repo/path_repository_impl.dart).
This placement and some transport/presentation coupling are existing debt, not
precedent for adding new domain-to-implementation dependencies.

## Cross-layer behavior

The [firmware guide](../firmware/development.md) owns the current message and SD
contracts. Changes must trace UI event -> BLoC -> use case -> repository ->
message envelope -> ESP32 handler -> Mega handler/telemetry where applicable.
Update both sides and relevant tests together; do not rename wire keys solely
to match Dart naming.

- Preserve explicit disconnected, unreachable, error, and stale-data states.
  Reconnect only the transport, not a remembered motion/start/playback action.
- Distinguish requested state from device acknowledgment and telemetry. Current
  UI updates after command submission are not proof of physical completion.
- Test stream cancellation, repeated tab entry, manual disconnect, retry
  exhaustion, malformed messages, failed path operations, and stop behavior.
- Keep platform Wi-Fi joining, permission rationales, reachability, and settings
  behavior behind existing adapters. Android/iOS behavior differs; do not add
  permissions or relax platform networking policy without a concrete need.
- Reuse the current BLoC/error surfaces and DTO mappers. Do not introduce silent
  catch/default behavior for new safety-relevant fields. Missing values must
  not become measured zero or a verified stopped state.
- Strings are currently inline; no ARB/localization or widget-preview system
  is configured. Use the existing patterns unless introducing that capability
  is part of the task.

## Local validation

Follow the
[mandatory test-driven workflow](../agents/project-guardrails.md#mandatory-test-driven-development):
run the new regression test red before implementing changed behavior, or run
characterization tests green before a behavior-preserving move. Repeat the
focused tests through green/refactor, then broaden validation for the affected
scope. The commands below are used throughout that loop, not just after coding.

Run commands from the repository root with Flutter/Dart on `PATH`.
For a fresh checkout or changed dependencies, resolve the manifest with
`flutter pub get`; do not upgrade dependencies merely to perform a docs task.

For a control change, this existing targeted selection is a starting point:

```sh
flutter test test/features/control test/core/data/repo/control_repository_impl_test.dart
flutter analyze
```

Choose equivalent existing paths for other scopes. Shared network, DTO, DI,
or cross-feature changes require the full relevant suite:

```sh
flutter test
flutter analyze
```

Tests use `flutter_test`, `bloc_test`, and `mocktail`; reuse
[`test_helpers`](../../test/test_helpers/) and network fakes. Do not add Mockito
generation simply because a generic testing skill recommends it.

Coverage is optional unless requested or needed for the task:

```sh
zsh tool/coverage.sh
```

That script runs `flutter test --coverage`, then
[`coverage_summary.py`](../../tool/coverage_summary.py), writing
`coverage/summary.txt`; it requires `zsh` and `python3`. Do not claim a coverage
threshold that the repository has not established.

For prose-only changes, inspect links and referenced commands; do not run these
application checks. Running the app against a mower or automating its controls
requires the explicit operational approval in the project guardrails.
