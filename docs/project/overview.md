# Project Overview

## Intended product

[plan.md](../../plan.md) is the authoritative concept, business, and build plan.
This overview was grounded in its 2026-10-14 baseline and the current source
tree; it does not change its decisions or claim its stages are complete.

MowerBot is intended for supervised mowing-as-a-service on rough grass,
orchards, slopes, and difficult-access plots. The design consists of two
self-contained tracked pods joined by a variable-width scissor frame, with a
longitudinal implement spine. The first implement is the DAC 9100 underbody
mower. A washable conveyor, passive trailer, and front fruit drum are planned
attachments, not implemented software features. The four-column cage is excluded.

The plan's approximate 48 V, 8 kWh, two 2 kW continuous drives, 70-80 Nm per
track, and 4 km/h mowing figures are provisional sizing targets, not accepted
component specifications or firmware limits. Pricing and utilization are
business hypotheses. Preserve the full evidence distinctions in the plan.

## What the repository contains

| Surface | Current source and responsibility |
| --- | --- |
| Flutter entry and navigation | [`main.dart`](../../lib/main.dart), [`app_router.dart`](../../lib/app_router.dart), and [`app_shell.dart`](../../lib/shell/app_shell.dart); connection, control, and paths tabs |
| Operator features | [`lib/features/`](../../lib/features/): connection, control/camera, paths, and telemetry |
| Shared infrastructure | [`lib/core/`](../../lib/core/): WebSocket clients, DTOs, repositories, errors, platform Wi-Fi/permissions, and GetIt DI |
| ESP32 sketch | [`MowerESP32.ino`](../../arduino/MowerESP32/MowerESP32.ino): Wi-Fi/WebSocket routing, camera integration, SD recording/playback, and Mega serial bridge |
| Mega sketch | [`MowerMega.ino`](../../arduino/MowerMega/MowerMega.ino): steering/homing, actuators, optical feedback, telemetry, and software watchdog |
| Local checks | [`test/`](../../test/), [`analysis_options.yaml`](../../analysis_options.yaml), and [`tool/coverage.sh`](../../tool/coverage.sh) |

This is not yet a software implementation of independent left/right tracked
pod control. The current drive protocol uses start/drive booleans and a steering
angle. The ESP32 also depends on an external `mower_esp.h` library whose source
and pinned build configuration are not included here.

## Plan-to-code gaps

| Intended capability | Current evidence and boundary |
| --- | --- |
| Two-pod differential drive and width/implement configuration | Current Mega code controls steering and actuators; controller topology and a tracked-drive migration remain design work |
| RTK Teach & Repeat | SD files contain `ms,angle` samples; playback sends timed steering commands, not localized routes or RTK/geofence metadata |
| Independent safety and restart inhibition | App stop commands and a Mega software heartbeat watchdog exist; they are not evidence of an independent contactor/E-stop safety system |
| Battery, motor, thermal, tilt, and RTK supervision | Current Mega telemetry reports steering/actuator state and limits; do not infer the plan's full sensor set from DTO fields/defaults |
| Commercial field readiness | No stage-completion evidence is established by the repository; component, braking, stability, legal, and pilot-business gates remain those in the plan |

The [firmware guide](../firmware/development.md) records specific prototype
caveats. They are constraints for future work, not changes made by this
documentation task.

## Build sequence and decision gates

Follow the plan's sequence rather than treating autonomy as the first milestone:

| Stage | Required direction / exit evidence |
| --- | --- |
| 0: customer and site validation | Plausible pilot demand and documented site/operating constraints |
| 1: bench propulsion | One drive meets intended duty with measured current, thermal, torque, and fault behavior |
| 2: rolling two-pod chassis | Repeatable control, width locks, stability, braking, and track retention |
| 3: mower integration | Repeatable supervised cutting with measured energy, vibration, stopping, and service effort |
| 4: independent safety and supervised operations | Every emergency path demonstrated independently; predictable manual operation |
| 5: RTK Teach & Repeat | Qualified routes and observed boundary, localization-loss, pause, and stop behavior |
| 6: pilot service | Recorded reliability, operator effort, energy, revenue, and contribution margin |

Safety is a prerequisite throughout commissioning; Stage 4 is not permission to
defer emergency protection during earlier bench/chassis work.

Before the next control redesign, resolve the controller topology, independent
safety-state diagram, command/acknowledgment and fault semantics, and verified
hardware limits with the user. Before RTK work, establish localization and route
qualification requirements. Do not select battery chemistry, gearing, remote
link, or safe slope/speed limits from provisional numbers alone.
