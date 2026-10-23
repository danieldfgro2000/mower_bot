# Firmware and Device Contracts

Read [project guardrails](../agents/project-guardrails.md) and the
[plan-to-code overview](../project/overview.md) first. These sketches describe
the current prototype, not the final tracked-drive or independent safety design.

## Source ownership and build prerequisites

| Area | Owning files |
| --- | --- |
| ESP32 startup, routing, SD path commands | [`MowerESP32.ino`](../../arduino/MowerESP32/MowerESP32.ino) |
| Camera selection, pins, HTTP service | [`board_config.h`](../../arduino/MowerESP32/board_config.h), [`camera_pins.h`](../../arduino/MowerESP32/camera_pins.h), [`app_httpd.cpp`](../../arduino/MowerESP32/app_httpd.cpp) |
| ESP32/Mega serial pins | [`pins_esp_to_mega.h`](../../arduino/MowerESP32/pins_esp_to_mega.h) |
| Recording/playback/storage | [`path_recorder.cpp`](../../arduino/MowerESP32/path_recorder.cpp), [`path_player.cpp`](../../arduino/MowerESP32/path_player.cpp), [`sd_recorder.cpp`](../../arduino/MowerESP32/sd_recorder.cpp) |
| Mega orchestration and messages | [`MowerMega.ino`](../../arduino/MowerMega/MowerMega.ino), [`messaging.cpp`](../../arduino/MowerMega/messaging.cpp) |
| Steering, actuators, feedback, watchdog | [`steering.cpp`](../../arduino/MowerMega/steering.cpp), [`actuators.cpp`](../../arduino/MowerMega/actuators.cpp), [`wheel_telemetry.cpp`](../../arduino/MowerMega/wheel_telemetry.cpp), [`security_watchdog.cpp`](../../arduino/MowerMega/security_watchdog.cpp) |

The ESP32 sketch includes external `mower_esp.h`, ArduinoJson, camera, and SD
facilities. Mega also uses ArduinoJson, AccelStepper, and TMCStepper. The external
Mower library supplies network/serial/heartbeat abstractions, so their full
implementation cannot be inferred from the sketch alone.

There is no checked-in PlatformIO project, Arduino sketch profile, dependency
lock, or reproducible firmware build script. Before compiling, confirm the
actual board/FQBN, core and library versions, Mower library source/revision,
partition/PSRAM requirements, and required local configuration. The AI Thinker
camera macro in `board_config.h` and example matrix in
[`ci.json`](../../arduino/MowerESP32/ci.json) are not proof of the connected
board or a validated compile command.

`MowerESP32.ino` expects `MowerConfig::WIFI_SSID` and
`MowerConfig::WIFI_PASSWORD` from local `secrets.h`, which is excluded by
[.gitignore](../../.gitignore). Do not print or commit its contents; no example
secret file is currently provided. Do not copy credentials from another project.

Once those prerequisites are confirmed, perform local compile-only validation
using the verified toolchain for each affected sketch. Do not invent a working
FQBN command or claim a build passed without establishing the configuration.
Uploading, monitoring, resetting, or sending serial commands remains a separate
user-authorized, hardware-observed step.

## Current app/device contract

The app envelope is defined in
[`message_envelope.dart`](../../lib/core/data/network/message_envelope.dart).
ESP32 consumes local path commands and forwards other messages to Mega as
newline-delimited JSON. Serial initialization is 115200 baud on both sketches.

The control WebSocket uses port **85** in ESP32 `wsServer.begin(85)` and the app's
[`MowerWsPort.ctrl`](../../lib/core/data/repo/connection_repository_impl.dart).
Use those owners, not an older port-81 comment in the control repository.
Camera HTTP is separate; inspect `app_httpd.cpp` and the app camera consumer for
its actual service URL before changing networking.

| Operation | Payload within `{"topic":"drive","data":...}` | Owning receiver |
| --- | --- | --- |
| Steering | `{"mega":{"command":"steer","angle":<degrees>}}` | Mega messaging/steering |
| Drive enable | `{"mega":{"command":"drive","isMoving":<bool>}}` | Mega messaging/actuators |
| Implement/start actuator | `{"mega":{"command":"start","start":<bool>}}` | Mega messaging/actuators |
| Software emergency stop | `{"mega":{"command":"emergency_stop"}}` | Mega messaging |
| Start recording | `{"cmd":"start_record"}` | ESP32 path recorder |
| Save/discard recording | `{"cmd":"stop_record","fileName":<name>}` | ESP32; empty name discards the temporary file |
| Play/delete a path | `{"cmd":"play_path","fileName":<name>}` / `{"cmd":"delete_path","fileName":<name>}` | ESP32 player/SD |
| Stop/list/diagnose paths | `{"cmd":"stop_path"}` / `{"cmd":"list_paths"}` / `{"cmd":"diag_paths"}` | ESP32 |

These are schema illustrations, not runnable operating instructions.
ESP32 sends `pathList` with `data.paths`, `pathEvent` with `event`, `name`, and
`ok`, and `pathDiag` with recording/playback/storage diagnostics. A Flutter
method completing after send is not a device acknowledgment; keep this
distinction when changing the path UI.

Mega emits `telemetry` with actuator booleans, `stepperAngle`,
`actualAngleFromOptic`, and steering degree/step limits. The app's
[`TelemetryMapper`](../../lib/core/data/dto/telemetry_data_dto.dart) also reads
speed/distance with defaults; field presence in a DTO does not prove the current
Mega sender measures or transmits it.

## SD path format

[`path_recorder.h`](../../arduino/MowerESP32/path_recorder.h) and its
implementation record every 200 ms to `/paths/<name>.csv`, mounted via `/sdcard`.
The header is `ms,angle`: elapsed milliseconds and commanded steering angle in
degrees. Temporary files are renamed on save, with suffixes for name collisions;
an empty final name deletes the temporary recording.

[`path_player.cpp`](../../arduino/MowerESP32/path_player.cpp) replays these
samples by elapsed time and sends steering commands. It does not store RTK fix,
position, boundaries, attachment/width configuration, or route qualification.
Do not reinterpret saved files as RTK routes. Format changes require explicit
compatibility/migration handling and tests of app naming plus firmware storage.

## Known safety boundaries

- The Mega watchdog checks ESP heartbeat locally; it is software in the normal
  control loop, not an independent emergency energy-isolation path.
- `MowerMega.ino` returns from `loop()` while homing before running the watchdog
  and message handler. Do not assume those handlers remain available during
  homing or claim comprehensive stop coverage.
- `PathPlayer::stop()` closes playback; it does not disable drive/start
  actuators. `stop_path` must not be described as an emergency stop.
- The Mega emergency command disables drive/start and commands steering zero;
  it does not itself cancel ESP32 playback or implement a latched restart
  inhibit. A UI "STOP" label is not evidence of the plan's independent E-stop.
- ESP32 playback and the external heartbeat library must be included in any
  link-loss or emergency-stop analysis. Do not infer end-to-end safety from a
  single timeout constant or a network connection flag.

Future changes must preserve existing protections while closing the explicitly
scoped gap. Verify boot, homing, link loss, stale commands, emergency stop,
playback cancellation, SD failure, and restart behavior with automated checks
where possible and a separately authorized hardware procedure. Do not energize
hardware merely to complete a software/documentation check.
