#include "messaging.h"
#include "steering.h"
#include "wheel_telemetry.h"
#include "actuators.h"
#include <ArduinoJson.h>
#include <Arduino.h>

static unsigned long lastSend = 0;

static const char* commandTypeName(CommandType c) {
    switch (c) {
        case CMD_STEER: return "CMD_STEER";
        case CMD_START: return "CMD_START";
        case CMD_DRIVE: return "CMD_DRIVE";
        default: return "CMD_UNKNOWN";
    }
}

CommandType parseCommandKey(const JsonDocument& doc) {
    if (doc["mega"]["command"] == "steer") return CMD_STEER;
    if (doc["mega"]["command"] == "start") return CMD_START;
    if (doc["mega"]["command"] == "drive") return CMD_DRIVE;
    return CMD_UNKNOWN;
}

void messagingHandleInput() {
  if(!Serial1.available()) return;

  String input = Serial1.readStringUntil('\n');
  if(input.length() == 0) return;
  input.trim();
  StaticJsonDocument<256> doc;

  DeserializationError err = deserializeJson(doc, input);
  if(err) {
    Serial.println("JSON parse failed.");
    return;
  }

  CommandType cmd = parseCommandKey(doc);

  switch (cmd) {
      case CMD_STEER:
          steeringSetAngle(doc["mega"]["steer"].as<float>());
          break;
      case CMD_START:
          actuatorStart(doc["mega"]["start"].as<bool>());
          break;
      case CMD_DRIVE:
          actuatorDrive(doc["mega"]["drive"].as<bool>());
          break;
      default:
            Serial.print("Unknown command received\n");
            break;
  }
}

void messagingSendTelemetry() {
  if(millis() - lastSend < 200) return;
  lastSend = millis();

  StaticJsonDocument<256> doc;
  doc["mega"]["angle"] = steeringGetCommandedAngle();
  doc["mega"]["encoder"] = steeringGetActualAngle();
  doc["mega"]["distance"] = wheelGetDistance();
  doc["mega"]["speed"] = wheelGetSpeed();
  doc["mega"]["homed"] = steeringIsHomed();

  String json;
  serializeJson(doc, json);
  Serial1.println(json);
}
