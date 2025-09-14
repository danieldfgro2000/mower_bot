#pragma once
#include <ArduinoJson.h>

enum CommandType {
    CMD_UNKNOWN,
    CMD_STEER,
    CMD_START,
    CMD_DRIVE,
    CMD_PATH_RECORDING_START,
    CMD_PATH_RECORDING_STOP,
    CMD_PATH_LIST,
    CMD_PATH_PLAY,
    CMD_PATH_DELETE,
    CMD_EMERGENCY_STOP,
};

CommandType parseCommandKey(const JsonDocument& doc);

void messagingHandleInput();
void messagingSendTelemetry();