# MowerBot

Flutter operator app and Arduino firmware for a mower-control prototype.
The intended product is a supervised, battery-electric, two-pod tracked mowing
platform, progressing toward RTK Teach & Repeat only after mechanical,
operational, and independent-safety validation.

**Current implementation:** Android/iOS Flutter app with connection, control,
camera, telemetry, and path-management flows; ESP32 camera/network/SD firmware;
and Mega steering/actuator firmware. Recorded paths currently replay timed
steering angles, not RTK coordinates.

**Status:** prototype and concept validation. Existing software does not prove
that the planned tracked machine, independent safety system, or commercial
operating envelope has been implemented or validated.

## Start here

- [Concept, business, and build plan](plan.md) - authoritative product direction,
  assumptions, open decisions, and stage gates.
- [Project overview](docs/project/overview.md) - plan summary and implementation gaps.
- [Documentation index](docs/index.md) - scoped development documentation.
- [Agent instructions](AGENTS.md) - mandatory guardrails for repository work.
- [Flutter development](docs/flutter/development.md) - architecture and local checks.
- [Firmware development](docs/firmware/development.md) - contracts, prerequisites,
  and hardware-operation boundaries.

Do not upload firmware, start a serial session, send live control commands, or
run path playback as an automatic consequence of a code/documentation change.
