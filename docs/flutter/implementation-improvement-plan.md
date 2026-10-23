# App Implementation Review and Improvement Plan

**Reviewed:** 2026-10-14, revision `874d932`, clean working tree before review.
**Status:** implementation complete for the approved application-code scope.
Firmware-dependent acknowledgments/status mapping and later product expansion
remain explicitly deferred until verified contracts and separate approval.
Final validation passed 238 tests; static analysis reports 12 existing
non-blocking diagnostics.
**Scope:** Flutter package/module separation, dependency ownership, state and
resource lifecycle, operator behavior, and representative existing tests.

This began as a source-inspection review and is not a hardware or security
certification. The executed evidence below records app-level tests and static
analysis; it does not claim real-device or firmware verification. Findings
distinguish directly observed code from questions requiring firmware evidence.
[plan.md](../../plan.md) remains the product/build authority; this document
does not change its stage gates.

## Recommendation

Keep one Flutter application package initially, but turn its informal folder
structure into **explicit, enforceable modules with clear ownership**.
Retain BLoC, GetIt, repositories, and use cases. Do not replace them with
ChangeNotifier/MVVM or introduce a workspace merely to follow a template.

The principal problem is not a missing `packages/` directory. Domain and
transport code import presentation types, `core` contains feature implementations
and widgets, and connection, telemetry, camera, and recording lifecycles overlap.
Moving that graph into multiple pub packages would preserve the coupling and
make cycles harder to manage.

First stabilize command outcomes and session lifecycles, then move code by its
actual owner in small changes. A pure-Dart protocol package is a reasonable
later extraction, once its contract is verified and independently useful.

## Current implementation assessment

There is one [pubspec.yaml](../../pubspec.yaml), 87 Dart implementation files,
and 40 `*_test.dart` files. There are no local Dart packages or pub workspace.
Feature folders are logical modules only; the compiler does not enforce their
boundaries. These counts describe the reviewed snapshot, not quality targets.

Useful foundations to preserve:

- Four recognizable feature areas: connection, control, paths, and telemetry.
- Repository/use-case interfaces, constructor injection, centralized GetIt
  registration, Equatable state/models, and a WebSocket abstraction.
- Stateful navigation branches and platform-specific connection handling.
- Existing DTO, repository, BLoC, platform, widget, and local socket tests.

The operator app supports a steering/actuator prototype, camera WebView, and
timed path recording/playback. It does not yet implement the tracked-pod,
RTK, or independent safety architecture in the product plan.

### Findings and priorities

P0 means address before relying on the affected operator indication/control;
P1 means foundational correctness or architecture work; P2 means consolidation
after those foundations. These are implementation priorities, not quantified
hardware-risk ratings. Source line references belong to the reviewed revision.

| ID | Priority | Evidence | Improvement |
| --- | --- | --- | --- |
| R1 | P1 | `ConnectionStatus` lives in [presentation state](../../lib/features/connection/presentation/bloc/connection_state.dart), line 4, but is imported by [the domain repository](../../lib/features/connection/domain/repositories/connection_repository.dart), its status use case, and both WebSocket layers. | Move transport/session state into a framework-independent device contract; keep UI scan/form state in presentation. A lower layer must not import a screen's state. |
| R2 | P1 | [PathRepository](../../lib/core/data/repo/path_repository_impl.dart) shares a data-named file with `MockPathRepository`; all five path use cases import it. Feature repositories/DTOs live under `core/data`, while [core/platform/wifi_scan.dart](../../lib/core/platform/wifi_scan.dart) contains connection widgets. | Put abstractions in owning domain modules, feature implementations in feature data modules, and widgets in presentation. Keep only genuinely shared infrastructure in `core`. |
| R3 | P1 | [ConnectionBloc](../../lib/features/connection/presentation/bloc/connection_bloc.dart), lines 26 and 94-95, directly drives `TelemetryBloc`. It also calls `WiFiScan.instance` at lines 330/369. Control owns camera, telemetry observation, and path recording. | Replace BLoC-to-BLoC orchestration with application-level session ownership; inject scanning/platform ports and separate operator subflows. |
| R4 | P1 | [TelemetryRepositoryImpl](../../lib/core/data/repo/telemetry_repository_impl.dart), lines 26-44, adds an untracked socket listener on every start. [TelemetryBloc](../../lib/features/telemetry/presentation/bloc/telemetry_bloc.dart), lines 30-50, overwrites subscription handles without canceling prior starts; `close()` cancels only one of its two handles. [PathRepositoryRemote](../../lib/core/data/repo/path_repository_remote_impl.dart), line 18, also retains an untracked diagnostic listener. | Give each resource one owner; make start/stop idempotent and teardown awaitable. Reconnection/re-entry must not multiply parsing, events, or diagnostics. |
| R5 | P0 | [SendDriveCommandUseCase](../../lib/features/control/domain/usecases/send_drive_command_use_case.dart), lines 8-10, returns connection status, not acknowledgment. [ControlBloc](../../lib/features/control/presentation/bloc/control_bloc.dart), lines 104-127, marks stop/recording state after submission. [PathBloc](../../lib/features/paths/presentation/bloc/paths_bloc.dart) marks playback active after a method that can be a disconnected no-op. | Distinguish request/submission, acknowledgment, and fresh observed state. Surface failure/unknown status; never label a locally sent stop as a physically confirmed stop. |
| R6 | P1 | [WebSocketAdapter](../../lib/core/data/network/websocket_adapter.dart), lines 172-219: established-stream closure only reports disconnected; retry scheduling is limited to opening failures. `Future.delayed(..., onReconnect)` has no cancellation/recheck at execution. | Specify one reconnect policy with a cancellable timer/session generation; disconnect/dispose/endpoint changes invalidate pending attempts. Never replay motion commands. |
| R7 | P1 | [ConnectionBloc](../../lib/features/connection/presentation/bloc/connection_bloc.dart), line 188, passes an SSID to a service whose parameter is an IP/host. Lines 404-432 treat the null result of a successful void operation as failure and await a future global exception; [safeExecute](../../lib/core/error/exception_handler.dart), lines 99-116, instead rethrows errors by default. | Introduce a typed endpoint and a single scan/join/probe/connect workflow. Return explicit operation results rather than inferring failure from null or a global broadcast. |
| R8 | P1 | [TelemetryBloc](../../lib/features/telemetry/presentation/bloc/telemetry_bloc.dart), lines 30-50, starts an unawaited future whose error callback emits later; stream error callbacks construct but do not emit error states. It divides `ageMs` by 60000 while retaining the millisecond field name. | Await handler-owned work, deliver later stream errors through events, preserve units, and model value/freshness/error together instead of mutually replacing telemetry and status. |
| R9 | P1 | [DI](../../lib/core/di/injection_container.dart), lines 54-56, registers a config that default-constructed clients do not consume. No disposal callbacks are registered. [main.dart](../../lib/main.dart), line 33, supplies a singleton BLoC through `.value` without an application teardown owner. | Make configuration and lifecycle wiring real and testable. Central composition may import implementations, but reusable `core` should not own application composition. |
| R10 | P1 | [Connection state](../../lib/features/connection/presentation/bloc/connection_state.dart), line 89, includes the AP password in its diff map; [MowerBlocObserver](../../lib/mower_bloc_observer.dart) prints changed diff values in debug mode. | Remove credentials from diagnostic projections and avoid hardcoded credentials in reusable state defaults. Add a redaction regression without copying secret values into fixtures or docs. |
| R11 | P2 | [ControlState.copyWith](../../lib/features/control/presentation/bloc/control_state.dart), lines 53-73, cannot clear nullable fields. [ControlPage](../../lib/features/control/presentation/pages/control_page.dart) combines drive controls, recording dialogs, and joystick composition; Cancel currently falls back to a generated save name. | Support explicit clearing; split widgets/controllers by behavior and decide cancel/save/discard semantics explicitly. Preserve current routes while correcting approved UX behavior. |

### Additional evidence and limits

The status payload needs verification, not an assumed rewrite.
[TelemetryRepositoryImpl](../../lib/core/data/repo/telemetry_repository_impl.dart)
passes `data.telemetry` into
[MowerStatusMapper](../../lib/core/data/dto/mower_status_dto.dart), which itself
expects `uptimeMs`, `wifi`, `ws`, and nested `telemetry`.
The [repository test](../../test/core/data/repo/telemetry_repository_impl_test.dart),
lines 55-90, manufactures that double nesting. This proves internal consistency
with the test, not consistency with the external Mower library's real `status`
producer. Obtain a sanitized producer fixture and the library revision first.

There are two different `TelemetryAgeModel` definitions under connection and
telemetry, differing in age nullability. DTO-plus-extension and separate mapper
paths also duplicate conversion logic. Consolidate to one owner per concept;
missing data must remain distinguishable from measured zero or confirmed false.

The test suite is a starting point, not evidence of a clean baseline:
[injection_container_test.dart](../../test/core/di/injection_container_test.dart)
expects `dev` to use `MockPathRepository`, but DI currently selects
`PathRepositoryRemote` for both environments. The
[remote path tests](../../test/core/data/repo/path_repository_remote_impl_test.dart)
explicitly expect disconnected operations to succeed as no-ops and timeouts to
return empty lists. Those expectations must change with approved error semantics,
not be preserved as desired behavior.

`core/error/error.dart` exports UI, global singleton handling, results, and
exceptions together. The global interceptor is tested but not initialized by
`bootstrap()`. Reuse the useful error vocabulary, split UI/reporting from pure
failure/result types, and choose one ownership model instead of adding another
parallel framework. Do not enable the existing global interceptor blindly.

An import/export reachability check from `main.dart` found seven candidate files
outside the live graph, including `TelemetryPage`, `DriftChart`, a second age
model, a connection status tile, and platform permission helpers. Three files
are empty: `exceptions.dart`, `failures.dart`, and `control_command_model.dart`.
Twenty-five files exceed 100 physical lines, notably ConnectionBloc (492) and
ControlPage (356). These are ownership/cleanup signals, not automatic deletion
or mechanical splitting instructions. Telemetry is still consumed elsewhere
even though its standalone page is not routed.

## Target module separation

The following is a **proposed end state inside the existing package**, not the
current directory map. Move by responsibility in approved slices, rather than
creating empty folders or changing all imports at once.

```text
lib/
  main.dart
  app/
    bootstrap.dart
    di/                         # single composition root, registrations by module
    session/                    # cross-feature lifecycle coordination
    routing/                    # existing routes and branch activation
    shell/                      # operator screen composition
  core/
    result/                     # small pure-Dart failure/result vocabulary
    diagnostics/                # redaction and logging interfaces
    presentation/               # only proven shared UI/error widgets
  device/
    domain/                     # endpoint, connection, health/freshness contracts
    data/
      transport/                # socket adapter/client, cancellation and retry
      protocol/                 # envelopes, codecs, typed inbound dispatch
      session/                  # one connection/session and resource owner
  features/
    connection/
      domain/                   # connection workflow and platform ports
      data/                     # scan/join/permissions/settings adapters
      presentation/             # form, scan UI, ConnectionBloc
    control/
      domain/                   # typed requests, observed state, use cases
      data/                     # control repository and device mapping
      presentation/             # drive/stop/steering UI and ControlBloc
    paths/
      domain/                   # PathRepository, identity, operation state
      data/                     # remote repository, response mapping
      presentation/             # list and recording UI/state
    telemetry/
      domain/                   # samples, repository, observation use cases
      data/                     # DTOs, one mapping path, repository
      presentation/             # telemetry state and visible diagnostics
    camera/
      domain/                   # source/availability contract if needed
      data/                     # endpoint derivation if needed
      presentation/             # WebView-specific state and lifecycle
```

Do not create every illustrated file/layer automatically. Camera separation
means independent lifecycle/ownership, not three pass-through classes for one
widget. Similarly, avoid a second transport abstraction duplicating
`IWebSocketClient` without replacing its existing role.

### Ownership and import rules

| Module | Owns | Allowed dependencies |
| --- | --- | --- |
| `app` | Composition, navigation, session coordination, feature assembly | Public feature APIs; concrete implementations only where composing DI |
| `core` | Domain-neutral reusable results/diagnostics and explicitly separated shared UI | Dart; Flutter only in presentation adapters; no feature or device imports |
| `device/domain` | Shared endpoint, connection state, device health/freshness, narrow session contracts | Pure Dart and small utility packages; no widgets, BLoCs, GetIt, plugins, or concrete transport |
| `device/data` | Socket lifetime, protocol validation/encoding, inbound dispatch | Device contracts and core; no feature presentation or application imports |
| Feature domain | Feature behavior and repository/platform ports | Core pure contracts, device domain; another feature's public domain only for an explicit, acyclic consumer relationship |
| Feature data | Repository implementations, feature mapping, platform services | Its own domain and narrow device API; platform packages only here or in genuinely UI-bound adapters |
| Feature presentation | UI/BLoC and display mapping | Its own domain and shared presentation helpers; no networking, DTO parsing, or another feature's BLoC |

Control observing telemetry's public domain stream is a legitimate dependency;
connection invoking telemetry's presentation BLoC is not. Share one device
freshness/connection vocabulary rather than copying it into each feature.

The device session should decode/dispatch inbound messages once and expose
narrow typed streams. Feature repositories own feature operation state; the
session does not become a generic event bus or a god repository. Keep the
existing wire envelope and keys in codecs, not in presentation event handlers.

The application coordinator owns cross-feature start/stop sequencing, not UI
state. A camera reconnect must not issue control commands. Path recording can
appear on the operator screen without belonging to ControlBloc: compose a paths
recording component beside drive and camera components at the app boundary.

Every socket, retry timer, parser subscription, repository subscription, BLoC,
and router must have exactly one teardown owner. DI aliases must not dispose the
same object twice. Session replacement invalidates pending requests and callbacks.

### Physical package decision

| Option | Assessment |
| --- | --- |
| Keep current folders unchanged | Lowest immediate churn but does not address the observed dependency inversions |
| Explicit modules in one pub package | **Recommended first:** low tooling overhead and easy incremental migration; add executable boundary checks |
| One pub package per UI feature | Not justified yet: shared session, app composition, and domain dependencies need repair first; adds manifests and dependency coordination |
| Separate global `presentation`, `domain`, and `data` pub packages | Avoid: organizes by technical layer rather than business ownership and encourages oversized shared modules |
| Extract a pure-Dart `mower_protocol` later | Best initial package candidate if a simulator, another client, or independently versioned contract benefits; contains codecs/protocol types and fixtures, not Flutter/UI/plugin dependencies |
| Extract a `mower_device_client` later | Consider only after session ownership and the protocol are stable; Wi-Fi onboarding/platform UI stays outside |

Extraction gates: an acyclic public API; no `package:mower_bot` imports from the
candidate; no GetIt/global application state; independent tests; a real reuse
or independent-validation benefit; and explicit firmware compatibility policy.
Do not introduce Melos, package-per-layer, or dependency injection generation
just to move files. A Dart package cannot be directly imported into Arduino C++;
cross-language compatibility still needs shared schema/fixtures or verified
producer/consumer contract tests.

## Phased execution plan

### Mandatory test-first gates

Every implementation slice in every phase follows the
[mandatory test-driven workflow](../agents/project-guardrails.md#mandatory-test-driven-development).
The [acceptance matrix](#acceptance-matrix-for-implementation) supplies test
requirements to implement **before** the corresponding code change, not a
post-refactor checklist.

| Phase | Required evidence before implementation |
| --- | --- |
| 0: baseline and decisions | Run the existing relevant tests, classify baseline failures, and select the first slice's intended assertions; resolve ambiguous behavior before encoding it |
| 1: behavior/lifecycle fixes | Write and run failing regressions for the selected command, subscription, retry, connection, or redaction behavior before fixing it |
| 2: module boundaries | Run behavior/contract characterization tests green; add a boundary test that fails on the current forbidden dependency before moving its owner |
| 3: operator state/UI | Write failing BLoC/widget tests for approved behavior changes; run existing behavior tests green before splitting components |
| 4: cleanup/dependencies | Establish passing tests for retained consumers and observable behavior before deletion; retain those assertions through cleanup and check affected builds after dependency changes |
| 5: package extraction/expansion | Run portable contract tests against the current implementation before extraction; write failing tests first for any separately approved new capability |

Each slice's completion evidence must identify its test/acceptance requirement,
the observed red failure or green characterization baseline, the passing result
after implementation/refactoring, and broader checks or blockers. No phase is
complete with tests merely listed, deferred, or written only after its code.
Keep evidence in this plan or the nearest owning implementation document;
do not invent test results or add a separate tracking file for every slice.

### Phase 0 - Establish an executable baseline and decisions

Record current analysis/test results and the DI environment mismatch. Decide
whether `dev` intentionally uses simulation or real hardware; the enum currently
does not switch implementations. Do not silently introduce a simulator or
delete a production-used test double based on its name.

Select focused regression cases for R4-R8 and R10, plus sanitized protocol
fixtures; write and run the first chosen slice's tests before its implementation.
Retain useful happy-path tests while labeling expectations that will
intentionally change. Resolve the external Mower library revision and real
status/acknowledgment shapes before asserting firmware compatibility.

**Exit:** reproducible baseline with failures accounted for; affected contracts,
behavior changes, and current hardware/library assumptions documented.

### Phase 1 - Stabilize behavior before broad file moves

Use separate, reviewable changes for these responsibilities:

1. Correct command/result semantics (R5): typed request/outcome boundaries;
   explicit disconnected, rejected, timeout, and unknown results; path UI errors;
   no optimistic physical-stop claim. Use existing `pathEvent` results where
   their identity is sufficient. If no request IDs exist, serialize ambiguous
   operations or explicitly require a firmware protocol change; do not invent
   acknowledgments. Never auto-retry motion/start/playback.
2. Fix session lifetime (R4/R6/R8/R9): awaitable teardown, one retained listener
   per owner, idempotent telemetry start/stop, asynchronous errors as events,
   cancellable retries, and stale-session callback rejection.
3. Correct connection workflow (R7): distinguish SSID from host/port, inject the
   scanner, make scan cancel actually invalidate work, and replace the null/global
   error wait with an explicit result. Verify Android join and iOS manual paths.
4. Redact diagnostics (R10) and define stop-versus-pending-steering behavior.
   The current steering debounce can outlive another event; a stop must invalidate
   queued normal commands, not wait behind them. Rate/angle limits require
   verified hardware policy, not guessed constants.

**Exit:** disconnected operations fail visibly; repeated starts/reconnects do
not duplicate events; disconnect during backoff cannot reconnect later; no late
emits after close; operator state never equates submission with confirmed safety.
Firmware-dependent safety guarantees remain separately gated, not "fixed" by UI.

#### Executed slice evidence

**2026-10-14 - R4 telemetry repository repeated-start ownership**

- Scope and acceptance: calling `startTelemetry()` twice on one repository must
  retain one socket listener, so one telemetry socket message produces exactly
  one repository event. Wire mapping, reconnect policy, and teardown behavior
  were intentionally unchanged in this slice.
- Baseline: `flutter test
  test/core/data/repo/telemetry_repository_impl_test.dart
  test/features/telemetry/presentation/bloc/telemetry_bloc_test.dart --reporter
  compact` passed all 9 existing tests before implementation.
- Red: the new `two starts emit one telemetry event per socket message` test
  failed before the fix because one message produced 2 events instead of 1.
- Green/refactor: the repository retains one message subscription; the focused
  regression passed, and `flutter test
  test/core/data/repo/telemetry_repository_impl_test.dart
  test/features/telemetry --reporter compact` passed all 16 tests.
- Broader validation: `flutter test --no-pub --reporter compact` retained the
  known Phase 0 DI baseline failure where `dev` expects `MockPathRepository` but
  resolves `PathRepositoryRemote`; no other test failed. `flutter analyze
  --no-pub` reported 20 existing diagnostics outside the changed files, so the
  repository-wide analysis baseline remains non-green.

**2026-10-14 - R4 telemetry stop and teardown ownership**

- Scope and acceptance: stopping telemetry must await cancellation of the
  repository's socket listener, allow one clean later restart, and be invoked
  by both `StopTelemetry` and `TelemetryBloc.close()`. The composition root must
  resolve the stop use case and the updated BLoC.
- Baseline: `flutter test --no-pub
  test/core/data/repo/telemetry_repository_impl_test.dart
  test/features/telemetry --reporter compact` passed all 16 tests before this
  slice.
- Red: the repository test received a telemetry event after stop; the BLoC stop
  and close tests observed no stop-use-case calls; and the DI regression failed
  because `StopTelemetryStreamUseCase` was not registered.
- Green/refactor: `stopTelemetry()` now clears and awaits its owned socket
  subscription before restart. The BLoC awaits repository stop, cancels both
  observation subscriptions, and reuses that teardown during close. The
  focused repository/use-case/BLoC selection passed all 16 tests, and the
  telemetry plus connection-consumer selection passed all 28 tests.
- Broader validation: the new focused DI regression and changed-file analysis
  passed. The full suite passed 187 tests and retained only the known dev-DI
  mismatch; repository-wide analysis retained the same 20 unrelated
  diagnostics.

**2026-10-14 - R4 serialized telemetry BLoC lifecycle**

- Scope and acceptance: repeated `StartTelemetry` events must retain one
  repository start and one observer set. A `StopTelemetry` event received while
  start is pending must execute afterward and prevent later telemetry events.
- Baseline: the telemetry BLoC and event tests passed all 8 existing tests
  before this slice.
- Red: repeated starts called the start and observation use cases twice. With a
  deliberately pending start, stop ran too early and a later telemetry sample
  still emitted `TelemetryLoaded`.
- Green/refactor: start and stop now share one sequential lifecycle event
  handler, and an already-started BLoC ignores duplicate starts. The focused
  BLoC/event selection passed all 10 tests; the telemetry and connection
  consumer selection passed all 30 tests; changed-file analysis passed.
- Broader validation: the full suite passed 189 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 20
  unrelated diagnostics.
- Dependency consequence: `bloc_concurrency` now has an active production
  consumer for sequential telemetry lifecycle handling and is no longer an
  unused-dependency removal candidate.

**2026-10-14 - R8 asynchronous telemetry stream errors**

- Scope and acceptance: asynchronous errors from both telemetry observation
  streams must produce visible `TelemetryError` states with enough context to
  identify the failing stream; callbacks must not emit through an expired
  handler.
- Baseline: the telemetry BLoC and event tests passed all 10 existing tests
  before this slice.
- Red: telemetry-data and status-stream error tests emitted only
  `TelemetryLoading`; each callback constructed an unused `TelemetryError`.
- Green/refactor: both callbacks now dispatch a typed internal failure event
  guarded against a closed BLoC, and the event handler emits the error state.
  The focused BLoC/event selection passed all 13 tests; the telemetry and
  connection consumer selection passed all 33 tests; changed-file analysis
  passed.
- Broader validation: the full suite passed 192 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 20
  unrelated diagnostics.

**2026-10-14 - R8 telemetry age unit preservation**

- Scope and acceptance: a status-stream `ageMs` value must remain milliseconds,
  including valid zero; absent age continues to use the existing `-1` UI
  sentinel in this slice.
- Baseline: the telemetry BLoC tests passed all 9 existing tests before this
  slice.
- Red: `120000 ms` was emitted as `2`, while valid `0 ms` was collapsed to
  `-1`.
- Green/refactor: the BLoC now forwards the nullable domain age directly,
  substituting `-1` only when absent. The focused BLoC selection passed all 10
  tests; the telemetry and connection consumer selection passed all 34 tests;
  changed-file analysis passed.
- Broader validation: the full suite passed 193 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 20
  unrelated diagnostics.

**2026-10-14 - R8 absent telemetry age semantics**

- Scope and acceptance: an absent domain `ageMs` must remain distinct from
  measured zero through the telemetry event/state boundary and render as
  unavailable; present values must be labeled in milliseconds. Malformed and
  stale classifications remain separate future work.
- Baseline: the telemetry BLoC and event tests passed all 14 existing tests
  before this slice.
- Red: the BLoC regression received `-1` instead of `null`; widget regressions
  found neither `Age: Unavailable` nor the expected millisecond label because
  the page rendered nullable/present values as minutes.
- Green/refactor: telemetry status events and states now carry nullable
  `ageMs`, the BLoC preserves the domain value, and the page renders absent age
  as unavailable and present age in milliseconds. The focused BLoC, event, and
  widget selection passed all 17 tests; the full affected telemetry and
  connection-consumer selection passed all 37 tests; changed-file analysis
  passed.
- Broader validation: the full suite passed 196 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 20
  unrelated diagnostics.

**2026-10-14 - R10 connection-state diagnostic redaction**

- Scope and acceptance: AP credentials stored in connection state must not
  appear in its diagnostic diff projection or `MowerBlocObserver` output.
  Synthetic markers were used in tests. Credential configuration/defaults and
  arbitrary error-payload redaction remain separate decisions.
- Baseline: the connection-state and shared diff utility tests passed all 7
  existing tests before this slice.
- Red: the state regression found the credential field in `toDiffMap()`, and
  captured observer output contained the synthetic next-credential marker.
- Green/refactor: the diagnostic projection no longer contains `apPassword`;
  connection state, equality, copying, and join behavior remain unchanged. The
  focused state/diff/observer selection passed all 8 tests, and the affected
  connection/diagnostics selection passed all 30 tests.
- Broader validation: targeted analysis retained only the known pre-existing
  `unnecessary_this` diagnostic in the touched state file. The full suite
  passed 197 tests and retained only the known dev-DI mismatch;
  repository-wide analysis retained the same 20 unrelated diagnostics.

**2026-10-14 - R6 cancellable reconnect backoff**

- Scope and acceptance: a pending reconnect callback must be invalidated by
  manual close, adapter disposal, or a replacement open/endpoint. Retry limits,
  backoff calculation, command replay, and reconnect after an established
  stream closes were intentionally unchanged in this slice.
- Baseline: the WebSocket adapter unit tests passed all 5 existing tests before
  this slice.
- Red: each of the three new regressions observed one stale reconnect callback
  after its invalidation boundary.
- Green/refactor: the adapter now owns one reconnect timer and its completion;
  canceling it also completes the waiting open operation. A new open replaces
  any prior timer, while close and dispose cancel it. The focused adapter suite
  passed all 8 tests, and the affected transport/repository selection passed
  all 25 tests.
- Broader validation: targeted analysis retained only the two known
  pre-existing diagnostics in the affected files. The full suite passed 200
  tests and retained only the known dev-DI mismatch; repository-wide analysis
  retained the same 20 unrelated diagnostics.

**2026-10-14 - R6 established-stream reconnect and stale-session rejection**

- Scope and acceptance: unexpected closure of the active established socket
  must enter the existing bounded reconnect policy; manual closure must not
  reconnect, and closure from a replaced socket must not affect the active
  session. No command is queued or replayed by this transport behavior.
- Baseline: the WebSocket adapter suite passed all 8 existing tests before this
  slice.
- Red: remote closure emitted disconnected but invoked no reconnect callback;
  closing a replaced socket also cleared the replacement adapter session.
  The manual-close characterization already passed with no reconnect.
- Green/refactor: each open now has a generation, closure is handled once for
  only the current generation, and stale asynchronous probe/connect/closure
  results are ignored. Active remote closure schedules the owned reconnect
  timer, while manual close and disposal remain suppressing boundaries. The
  focused adapter suite passed all 11 tests, and the affected
  transport/repository selection passed all 28 tests.
- Broader validation: targeted analysis retained only the known adapter
  `avoid_print` diagnostic. The full suite passed 203 tests and retained only
  the known dev-DI mismatch. Repository-wide analysis reported 19 existing
  diagnostics; the former unnecessary `dart:async` import is now used by the
  new asynchronous session fixture.

**2026-10-14 - R4 path diagnostic-listener ownership**

- Scope and acceptance: `PathRepositoryRemote` must retain ownership of its
  passive diagnostic message listener, expose awaitable teardown, and release
  that listener when the repository singleton is disposed.
- Baseline: the remote path repository suite passed all 5 existing tests before
  this slice.
- Red: the executable lifecycle regression failed with `NoSuchMethodError`
  because the repository had no disposal boundary and its constructor listener
  could only be released by closing the shared WebSocket client.
- Green/refactor: `PathRepository` now exposes `dispose()`;
  `PathRepositoryRemote` retains and cancels its diagnostic subscription, the
  mock implementation provides a no-op boundary, and GetIt disposes the lazy
  singleton through that contract. The focused remote suite passed all 6 tests,
  and the affected path repository/use-case/BLoC selection passed all 17 tests.
- Broader validation: production DI registrations and reset teardown passed;
  the DI file retained only the known dev repository mismatch. Changed-file
  analysis retained the 5 existing `avoid_print` diagnostics in the mock
  repository. The full suite passed 204 tests with only the known dev-DI
  failure, and repository-wide analysis retained the same 19 diagnostics.

**2026-10-14 - R8 composite telemetry state**

- Scope and acceptance: later freshness or asynchronous stream-error events
  must retain the latest telemetry value, and the telemetry page must render
  value, freshness, and errors together rather than replacing one with another.
  Startup failure remains a separate pre-stream error state.
- Baseline: the telemetry BLoC and page selection passed all 13 existing tests
  before this slice.
- Red: after telemetry, freshness, and a status-stream error were dispatched,
  the freshness state had no wheel value and the error state retained neither
  value nor freshness. After introducing the composite state, the page's
  executable widget regressions fell through to `Unknown state` until rendering
  was updated.
- Green/refactor: `TelemetryActive` now carries the latest optional telemetry,
  nullable freshness, and per-stream errors. Successful data/status events
  clear only their own stream's error. The page composes all available fields,
  including absent age and millisecond labels. The focused BLoC/page selection
  passed all 15 tests, the full telemetry feature passed all 23 tests, and
  changed-file analysis passed with no diagnostics.
- Broader validation: the full suite passed 206 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**2026-10-14 - R7 AP reachability endpoint correctness**

- Scope and acceptance: AP-mode reachability must probe the configured mower
  host and port; the discovered/configured SSID is only a Wi-Fi identity and
  must never be used as a TCP host.
- Baseline: the connection BLoC suite passed all 9 existing tests before this
  slice.
- Red: the endpoint regression expected `192.168.4.1:85`, but the recorded
  reachability call used `MowerBot-AP:85`.
- Green/refactor: both AP reachability paths now forward `state.ip` and
  `state.port`, retaining the established AP defaults only when those values
  are absent. The focused BLoC suite passed all 10 tests, changed-file analysis
  passed, and the affected connection/repository/reachability selection passed
  all 33 tests.
- Broader validation: the full suite passed 207 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**2026-10-14 - R7 injectable and cancellable Wi-Fi scanning**

- Scope and acceptance: the connection BLoC must use an injected scan port
  rather than the plugin singleton, and the timeout event used by the UI's
  cancel action must invalidate and await active polling before later results
  can start more work.
- Baseline: the connection BLoC suite passed all 10 existing tests. Replacing
  direct plugin calls with a DI-registered `WifiScanner` preserved that baseline
  and passed changed-file analysis before cancellation behavior changed.
- Red: with the first injected result deliberately held pending, canceling the
  scan and then completing that result allowed a second poll; the regression
  observed 2 result calls instead of 1.
- Green/refactor: timeout/cancel now advances the scan generation and awaits
  timer/subscription cleanup, while a replacement scan awaits prior cleanup
  before starting. The injected seam also covers plugin start failure. The
  focused BLoC suite passed all 12 tests and changed-file analysis passed.
- Broader validation: the full suite passed 209 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**2026-10-14 - R7 explicit WebSocket connection result**

- Scope and acceptance: a synchronous or asynchronous failure from connection
  setup must leave `connecting`, emit a mapped visible error, and complete
  without inferring failure from a nullable `void` result or waiting for the
  process-wide exception stream.
- Baseline: the connection BLoC suite passed all 12 existing tests before this
  behavior changed.
- Red: a connect use case throwing a typed network exception escaped the BLoC
  handler through `safeExecute`; no error state was emitted and the regression
  ended disconnected.
- Green/refactor: connection setup now returns `Result<bool>` with an explicit
  `Success`/`Failure` branch. The failure branch maps the contained exception
  directly, while the success branch starts status verification. The focused
  BLoC suite passed all 13 tests and changed-file analysis passed.
- Broader validation: the full suite passed 210 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**2026-10-14 - R5 typed control-command submission**

- Scope and acceptance: control commands must distinguish local socket
  submission from disconnection/invalid/unknown delivery, and successful run or
  emergency-stop submission must not overwrite telemetry-confirmed physical
  state. Firmware acknowledgment was not inferred or added.
- Baseline: the WebSocket client, control repository/use-case, and control BLoC
  selection passed all 10 existing tests before this slice.
- Red: successful `RunCommand` changed `isMowerRunning` to true locally, while
  successful `EmergencyStop` changed both physical-state flags to false before
  any confirming telemetry.
- Green/refactor: WebSocket `send` now reports whether it accepted a message on
  an active channel. The repository/use case returns a typed
  `CommandSubmissionResult`, the BLoC exposes submission/disconnection/unknown
  feedback, and physical flags are changed only by telemetry. The control page
  labels successful requests as submitted and awaiting confirmation. The
  affected transport/control/path selection passed all 22 tests; changed-file
  analysis retained only 4 existing `avoid_print` diagnostics.
- Broader validation: the full suite passed 212 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**2026-10-14 - R5 typed path-command submission**

- Scope and acceptance: play, stop, and delete operations must report local
  submission/disconnection/invalid/unknown outcomes; submission alone must not
  mark playback active, stopped, or deleted. Recording semantics were excluded
  because cancel/save/discard behavior requires the documented UX decision.
- Baseline: path repository, use-case, and BLoC tests passed all 17 existing
  tests before this slice.
- Red: successful play immediately set `activePath`, and successful stop
  immediately cleared it, despite neither operation observing a mower result.
- Green/refactor: path repository methods now return
  `CommandSubmissionResult`; the BLoC preserves confirmed list/active state and
  exposes pending or failure feedback inline. Delete no longer reloads and
  implies completion immediately after submission. The focused selection
  passed all 19 tests; changed-file analysis retained only 5 existing
  `avoid_print` diagnostics in the mock repository.
- Broader validation: the full suite passed 214 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.
- Remaining protocol gate: `pathEvent` acknowledgment identity and playback
  status semantics must be verified before pending requests can become
  confirmed active/stopped/deleted state.

**2026-10-14 - R10 stop invalidates pending steering**

- Scope and acceptance: emergency stop, drive-stop, run-stop, and BLoC teardown
  must invalidate any steering command still inside the local debounce window;
  no delayed normal command may be submitted after that boundary.
- Baseline: the control BLoC suite passed all 5 existing tests before this
  slice.
- Red: scheduling steer, waiting 20 ms, then submitting emergency stop still
  invoked the steering use case after the 100 ms debounce.
- Green/refactor: `ControlBloc` now owns one steering timer and generation.
  Stop boundaries cancel and invalidate it before sending their own command,
  and close performs the same cleanup. The focused suite passed all 6 tests;
  changed-file analysis retained only the existing `avoid_print` diagnostic.
  The now-unused direct `stream_transform` dependency was removed without
  retaining unrelated package-tool lockfile or analyzer rewrites.
- Broader validation: the full suite passed 215 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**2026-10-14 - R9 composition-root disposal ownership**

- Scope and acceptance: resetting the application scope must await teardown of
  the shared telemetry BLoC, telemetry and connection repositories, and both
  concrete WebSocket clients; their owned subscriptions, controllers, and
  adapter resources must no longer outlive the scope.
- Baseline: the focused composition-root test showed that GetIt reset left the
  telemetry BLoC open and did not close the five observed repository/client
  streams.
- Red: after `GetIt.I.reset()`, `telemetryBloc.isClosed` remained false.
- Green/refactor: GetIt registrations now own disposal callbacks in dependency
  order. Repository contracts expose awaitable disposal, repository teardown
  cancels owned subscriptions and closes controllers, and WebSocket client
  disposal now awaits its subscription, controllers, and adapter. The
  composition-root regression and all affected lifecycle suites passed;
  changed-file analysis retained only the existing connection-repository
  `avoid_print` diagnostic.
- Broader validation: the full suite passed 216 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**2026-10-14 - R9 effective WebSocket configuration injection**

- Scope and acceptance: replacing the registered `WebSocketConfig` before
  concrete client creation must reach both clients' actual adapters.
- Baseline: DI registered `WebSocketConfig`, but both concrete clients
  default-constructed adapters and ignored that registration.
- Red: after replacing the lazy config with a non-default instance, the
  resolved control client exposed a different default config.
- Green/refactor: both concrete clients accept configuration when constructing
  their adapters, expose the effective immutable config, and DI passes the
  registered instance to control and binary clients. The focused DI regression
  passed.
- Broader validation: the final full suite passed 238 tests; repository-wide
  analysis reported 12 existing diagnostics.

### Phase 2 - Repair dependency direction and move by owner

First establish passing wire/behavior characterization tests and write a small
local import-boundary test in the existing test setup. Resolve package and
relative imports plus exports so a barrel cannot hide a violation. Observe
the current dependency violations fail before moving `ConnectionStatus` into a
neutral shared device contract and `PathRepository` into paths/domain. Preserve
wire behavior and update all consumers/test imports in each move without
weakening behavioral assertions.

Then extract the pure error/result API from the UI/global-error barrel, unify
device health/freshness types, and move feature-specific repositories/DTOs from
`core/data` to their feature. Move scan widgets out of platform code. Relocate
application DI/routing/shell ownership into `app`, with one top-level registration
entry point rather than competing service locators.

Introduce the narrow shared device session around existing transport behavior.
Replace connection-to-telemetry BLoC coupling with application coordination.
Extend the boundary tests before each additional ownership change, keeping
previously corrected boundaries and behavioral tests green.

**Executed 2026-10-14 - domain import boundary and contract ownership**

- Scope and acceptance: feature domain code must not import concrete `core/data`
  implementations or presentation code; connection status and path repository
  abstractions must be owned by their domains without changing wire behavior.
- Baseline: focused path, connection, and WebSocket behavior tests passed before
  the move.
- Red: the new local boundary test reported seven violations: five path use
  cases importing the data implementation module and two connection domain
  files importing presentation state.
- Green/refactor: `PathRepository` moved to paths/domain and
  `ConnectionStatus` moved to connection/domain. Data implementations,
  composition wiring, consumers, and tests now import the owning contract.
  The boundary test and 32 affected behavior tests passed.
- Broader validation: the full suite passed 217 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics. The boundary test remains executable regression coverage.

**Executed 2026-10-14 - feature-owned data implementations**

- Scope and acceptance: feature-specific repositories, DTOs, and their mirrored
  tests must live under the owning feature rather than generic `core/data`;
  transport primitives remain shared and behavior must not change.
- Baseline: all 46 moved implementation/DTO tests and the first architecture
  boundary passed before the move.
- Red: the extended ownership boundary reported ten misplaced Dart files under
  `core/data/dto` and `core/data/repo`.
- Green/refactor: connection, control, paths, and telemetry repositories moved
  to feature data directories; telemetry DTOs moved with telemetry ingestion;
  composition and test imports now target those owners. Both architecture
  boundaries and all 47 moved-data tests passed.
- Broader validation: the full suite passed 218 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**Executed 2026-10-14 - application-owned session coordination**

- Scope and acceptance: connection presentation must not import or command
  telemetry presentation; control-channel status must retain the existing
  start-on-connected/stop-otherwise telemetry behavior at the application
  boundary.
- Baseline: all connection BLoC tests passed while the connection BLoC still
  accepted a shared `TelemetryBloc` and dispatched telemetry events from its
  repository-status listener.
- Red: the cross-feature presentation boundary reported both telemetry imports,
  and the new coordinator behavior test observed no start/stop callbacks.
- Green/refactor: a pure app-owned `DeviceSessionCoordinator` maps connection
  status to telemetry lifecycle callbacks. The app root listens to connection
  state and dispatches telemetry events; connection BLoC and DI no longer know
  about `TelemetryBloc`. The coordinator, all three architecture boundaries,
  and all 13 connection BLoC tests passed.
- Broader validation: the full suite passed 220 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**Executed 2026-10-14 - neutral shared device health models**

- Scope and acceptance: transport, connection, and telemetry must share one
  neutral connection-status/device-health contract and one nullable freshness
  model; duplicate telemetry-age declarations must not survive.
- Baseline: affected telemetry, connection, transport, and coordinator tests
  passed with two separate `TelemetryAgeModel` declarations under different
  features.
- Red: the extended architecture test found both freshness declarations.
- Green/refactor: connection status, mower status, Wi-Fi status, WebSocket
  status, and nullable telemetry age now live under `core/device/model`.
  Connection, telemetry, transport, DTOs, and tests import that neutral
  contract; the duplicate model was removed. All affected suites and four
  architecture boundaries passed.
- Broader validation: the full suite passed 221 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**Executed 2026-10-14 - application-owned composition and navigation**

- Scope and acceptance: composition root, routing, and shell must live under
  `lib/app`; feature widgets must not resolve dependencies from the service
  locator.
- Baseline: connection page and DI lifecycle tests passed while DI lived under
  core, router/shell lived at unrelated roots, and `ConnectionPage` resolved its
  rationale store through global `sl`.
- Red: the app-ownership boundary reported all three legacy paths.
- Green/refactor: DI, router, shell, and mirrored DI tests moved under `app`.
  App routing injects `PermissionRationaleStore` into `ConnectionPage`, removing
  feature-level service-locator access. All five architecture boundaries,
  connection-page widget tests, app coordinator tests, and the moved DI
  lifecycle regression passed; changed-file analysis was clean.
- Broader validation: the full suite passed 222 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**Executed 2026-10-14 - pure error barrel and presentation-owned scan UI**

- Scope and acceptance: the shared error barrel must not export Flutter/global
  UI concerns, and platform service directories must not own feature widgets.
- Baseline: error and connection widget suites passed while `error.dart`
  exported `error_ui.dart` and `global_error_interceptor.dart`, and Wi-Fi scan
  widgets lived in `core/platform`.
- Red: two architecture regressions identified both mixed ownership violations.
- Green/refactor: the error barrel now exports only non-UI error/result APIs;
  the global interceptor imports its UI notifier explicitly. Wi-Fi scan widgets
  and mirrored tests moved under connection presentation. The import-boundary
  detector also rejects a deliberately invalid fixture. All eight
  architecture boundaries plus affected error and connection widget suites
  passed.
- Broader validation: the full suite passed 224 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**Exit:** zero domain/transport imports of presentation; zero domain imports of
concrete data implementations; zero cross-feature BLoC dependencies; feature
implementations no longer live in generic core; DI reset disposes owned resources
exactly once; boundary checks fail on an intentionally invalid import fixture.

Keep mechanical moves and behavioral changes in separate commits/change sets.
Do not preserve duplicate old/new implementations or permanent forwarding
barrels merely to make the migration appear complete.

### Phase 3 - Give operator subflows independent state

Separate drive/stop, camera availability, path recording, and path-list state.
Compose them on the existing operator route; do not make a navigation redesign a
prerequisite. Keep nullable clearing explicit and retain last telemetry alongside
freshness/error instead of replacing it with unrelated status variants.

Resolve save/cancel/discard semantics before changing the recording dialog.
Move limits/conversions out of widgets; distinguish commanded and observed
steering. Remove the stale page-local steering source once one owner is selected.
Camera URL changes must update the existing WebView, and unavailable/disconnected
state must be representable without retaining an old URL.

**Executed 2026-10-14 - explicit camera clearing and steering ownership**

- Scope and acceptance: camera unavailability must clear an old endpoint,
  endpoint replacement must recreate the WebView request, and commanded steering
  must not reuse a stale page-local value or overwrite observed wheel angle.
- Baseline: focused control tests passed while nullable `copyWith` preserved an
  old camera URL and the drive button always resubmitted its page-local zero.
- Red: explicit camera clearing retained `http://old-camera`; a steering input
  left the new commanded-angle state at zero.
- Green/refactor: control state exposes explicit nullable clear flags; camera
  refresh clears unavailable URLs and tracks availability, and the WebView key
  follows the endpoint. Control BLoC now owns commanded steering while telemetry
  remains the observed angle; the page-local steering source was removed. All
  nine focused control state/BLoC tests passed.
- Broader validation: the full suite passed 228 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 19
  diagnostics.

**Executed 2026-10-14 - independent camera availability state**

- Scope and acceptance: camera endpoint/availability refreshes must not rebuild
  or mutate drive/stop/recording state, and connection changes must refresh
  camera availability independently.
- Baseline: camera URL and availability were fields/events in `ControlBloc`;
  telemetry updates also triggered camera refreshes.
- Red: the new camera owner observed no endpoint after refresh.
- Green/refactor: `CameraCubit` now exclusively owns replacement, unavailable,
  and cleared camera state. App connection coordination, control-tab entry, and
  app resume refresh that cubit; the WebView consumes only camera state.
  Camera fields/events/use-case wiring were removed from `ControlBloc`.
  Camera and control focused suites passed.
- Broader validation: the full suite passed 227 tests and retained only the
  known dev-DI mismatch; repository-wide analysis improved from 19 to 18
  diagnostics after removing the control BLoC debug print.

**Executed 2026-10-14 - bounded camera listeners and responsive STOP**

- Scope and acceptance: stateful-shell control-tab re-entry must retain one
  app-lifecycle camera observer, and emergency STOP must remain visible and
  tappable without layout overflow on a narrow, large-text surface.
- Baseline: focused camera/control suites passed, but no widget regression
  exercised stateful-shell retention or constrained control layouts.
- Red: a 220x180 surface at 2x text scale overflowed the bottom control row by
  26 pixels. The first listener fixture was corrected to use the app's
  stateful-shell retention rather than route replacement, then demonstrated
  one lifecycle refresh after three tab re-entry cycles.
- Green/refactor: bottom control padding and STOP dimensions now derive from
  the available width and height, and the STOP label scales down within its
  bounded icon while retaining its text/semantics. The listener and responsive
  widget regressions both pass.
- Broader validation: the full suite passed 231 tests and retained only the
  known dev-DI mismatch; repository-wide analysis improved from 18 to 17
  diagnostics after removing the camera lifecycle debug print.

**Executed 2026-10-14 - independent recording state and explicit cancel**

- Scope and acceptance: recording must not live in drive state; start, save,
  and discard must expose local submission failure without claiming firmware
  confirmation. Cancel must stop and discard, while empty Save must keep the
  dialog open with validation.
- Baseline: `ControlBloc` optimistically set recording state after `Future<void>`
  calls, and Cancel generated a filename and silently saved. The approved
  semantics are discard on explicit Cancel and validation on empty Save.
- Red: the widget regression observed Cancel calling stop with an autogenerated
  name instead of the discard sentinel. A second regression required the empty
  Save dialog to remain visible with an inline error, and an exception
  regression showed a start failure left the new owner pending.
- Green/refactor: `RecordingCubit` now independently owns start/stop pending,
  recording-requested, failure, discard, and last-saved state. Repository and
  use-case recording methods return `CommandSubmissionResult`; the existing
  empty `fileName` discard wire format is preserved. `ControlBloc` and
  `ControlState` no longer own recording. The recording widget subtree handles
  its own animation/dialog rebuilds, explicit Cancel discards, empty Save
  validates in place, and all labels describe submission as awaiting device
  status rather than physical confirmation.
- Broader validation: 51 focused architecture, control, path, use-case, and
  widget tests passed. The full suite passed 244 tests and retained only the
  known dev-DI mismatch; repository-wide analysis retained the same 17
  diagnostics.

**Exit:** recording changes do not rebuild unrelated drive/video state; tab
re-entry does not attach another listener; camera endpoint replacement works;
STOP remains reachable with large text and narrow/landscape layouts; cancel
behavior is explicit and tested.

### Phase 4 - Consolidate inactive code and dependencies

Review the seven unreachable candidates and empty files; move test-only
implementations into test support unless a deliberately selected simulation mode
needs them. Decide whether the standalone telemetry screen is a planned operator
surface or obsolete; do not add a route just to justify keeping it.

Audit direct dependencies against code, tests, assets, generators, and native
registration. `bloc_concurrency` is retained for serialized telemetry lifecycle
handling. `http`, `flutter_joystick`, `json_annotation`, and the JSON generation
tooling have no observed active imports/annotations in the reviewed app. They
are removal candidates, not automatic deletions. `fl_chart` is used by the
currently unrouted chart; launcher/splash tooling has manifest configuration
and must not be removed solely for lacking Dart imports.

**Executed 2026-10-14 - decision-free inactive code and dependency cleanup**

- Scope and acceptance: remove only unreachable/empty modules with no consumer
  or documented purpose and direct dependencies with no source, test, asset,
  generator, manifest, or native-registration use. Preserve the unresolved
  telemetry page/chart, dev simulation repository, `fl_chart`, and configured
  launcher/splash tooling.
- Baseline: six legacy files existed without consumers, and `http`,
  `flutter_joystick`, `json_annotation`, `build_runner`, and
  `json_serializable` remained direct entries without active usage.
- Red: architecture regressions listed all six files and all five manifest
  entries as retained cleanup violations.
- Green/refactor: the unused connection model, control-command placeholder,
  connection status tile, permission helper, and two empty legacy error files
  were removed. The error barrel dropped their compatibility exports, and the
  five unused direct dependency/tool entries were removed. Dependency
  resolution removed their now-unneeded transitive graph; unrelated analyzer
  rewrites and test-package upgrades were restored.
- Broader validation: all ten architecture checks and both new control-page
  widget regressions passed. The full suite passed 231 tests and retained only
  the known dev-DI mismatch; repository-wide analysis reported 17 existing
  diagnostics.

**Executed 2026-10-14 - approved inactive-surface and simulation removal**

- Decisions: the application uses the real remote path repository; the unused
  dev/prod switch is not retained when it selects no different behavior. The
  standalone telemetry page/chart is obsolete rather than a future routed
  operator surface.
- Red: the existing dev-DI regression expected `MockPathRepository`, while
  architecture cleanup regressions found the selected-obsolete telemetry page
  and drift chart.
- Green/refactor: the dev DI regression now asserts `PathRepositoryRemote`.
  The production mock repository, its orphan `PathModel`, and their tests were
  removed. The unrouted telemetry page/chart and mirrored widget tests were
  removed, and `fl_chart` was removed from the manifest and lockfile.
- Broader validation: all 11 architecture boundaries passed. The final full
  suite passed all 238 tests, and repository-wide analysis improved from 17 to
  12 existing diagnostics after the simulation repository was removed.

**Exit:** retained dependencies and modules have a named consumer or documented
purpose; generated/native dependency changes are reproducible; cleanup preserves
platform behavior and does not remove safety-related code without replacement.

### Phase 5 - Reassess extraction and product expansion

Only after Phases 1-3 stabilize the contract should a protocol/client package be
extracted using the gates above. Separate package extraction from changes to
wire format, controller topology, or saved paths.

Tracked differential drive, device capabilities, qualified RTK routes, geofence,
and independent safety are subsequent product work under the root plan. Preserve
an adapter for the verified current steering protocol until an explicit firmware
migration is approved. Do not fabricate RTK metadata for `ms,angle` recordings.

**Executed 2026-10-14 - extraction and operational-policy reassessment**

- No concrete second Dart/Flutter consumer exists, so protocol/client code
  remains in the application package and no package/tooling split is added.
- No verified firmware acknowledgment/status contract is available. Drive,
  recording, and path state therefore remains explicitly local-submission or
  requested state awaiting telemetry/device status; no acknowledgments or
  response matching are fabricated.
- Backgrounding retains the existing connection and telemetry session and sends
  no automatic motion, stop, reconnect, or replay command. Camera availability
  refreshes on resume under the bounded lifecycle observer regression.
- Product expansion remains outside this implementation plan until verified
  contracts and separately approved product work exist.

## Acceptance matrix for implementation

Existing Flutter test tools and fakes were used with injected
platform/clock/socket seams where necessary. Each applicable app-observable
test was implemented before its behavior change, following the test-first gates
above. Firmware producer fixtures, acknowledgments, and response matching remain
inapplicable until those contracts are verified:

| Area | Required observable result |
| --- | --- |
| Architecture | Forbidden imports/exports fail boundary checks; proposed standalone contracts have no Flutter or app dependency |
| DI/configuration | A non-default injected retry config reaches the actual adapter; intended dev/prod implementation choice is asserted |
| Connection | Probe receives the exact selected host and port, never SSID; successful void work cannot wait for a global error; canceled scans cannot later auto-connect |
| Transport | Remote close follows the chosen policy; manual disconnect/dispose/endpoint change during backoff/open invalidates pending work; no stale client events |
| Telemetry ownership | Two starts produce one output per input; stop/start and reconnect retain one owned subscription; all subscriptions are canceled on teardown |
| Telemetry meaning | Millisecond age stays milliseconds; age zero, absent, malformed, and stale values remain distinct; status mapping uses a verified producer fixture |
| Commands | Failed/disconnected/timeout submissions do not show successful playback/recording/stopping; stale or mismatched responses cannot complete a newer operation |
| Stop ordering | Pending debounced steering/normal commands cannot be emitted after a stop invalidates them; no automatic restart or replay |
| State/UX | Nullable URL/file/error fields can clear; telemetry and freshness coexist; save/cancel/discard follow the approved semantics |
| Navigation/camera | Repeated tab entry, background/resume, and endpoint changes have bounded listeners and correct WebView source; controls remain usable |
| Diagnostics | Credential fields are excluded from state diffs and logs; no raw credential-bearing payloads in failure reporting |
| Compatibility | Existing wire keys/path format remain unchanged during structural moves; any change has producer/consumer fixtures and a migration decision |

For implementation, use the commands in
[Flutter development](development.md#local-validation). Shared transport, DI,
and cross-feature changes warrant the full Flutter suite and static analysis,
not only mocked use-case delegation tests. Real device/firmware checks require
explicit authorization and observation as described in the
[firmware guide](../firmware/development.md).

## Approval boundaries and suggested first slice

The implementation resolved the approval boundaries as follows: the single
runtime composition uses the real remote path repository; recording Cancel
discards and empty Save validates in place; backgrounding retains the current
session without automatic commands; no verified firmware
acknowledgment/status contract exists, so local submission/requested semantics
remain; and no second package consumer exists, so extraction is deferred.

The first implementation slice should be Phase 0 followed by a failing
regression test and its focused Phase 1 fix, rather than moving all folders at
once or adding tests afterward. Prioritize
truthful command outcomes and session disposal; then the neutral connection
contract and domain-owned path interface are small, measurable separation wins.
