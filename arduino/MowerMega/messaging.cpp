#include "messaging.h"
#include "steering.h"
#include "wheel_telemetry.h"
#include "actuators.h"
#include <ArduinoJson.h>
#include <Arduino.h>
#include "security_watchdog.h"

static void dbgPrintRaw_(const String& s) {
    Serial.print(F("RAW(")); Serial.print(s.length()); Serial.print(F("): "));
    Serial.println(s); // shows the exact line

    // also dump HEX to catch hidden chars like \r, \t, or non-ASCII
//    Serial.print(F("HEX: "));
//    for (size_t i = 0; i < s.length(); ++i) {
//        uint8_t b = static_cast<uint8_t>(s[i]);
//        if (b < 16) Serial.print('0');
//        Serial.print(b, HEX); Serial.print(' ');
//    }
//    Serial.println();
}

static void dbgPrintJson_(const JsonDocument& d) {
    // pretty is optional; use serializeJson(d, Serial) if you prefer compact
    serializeJsonPretty(d, Serial);
    Serial.println();
}

static unsigned long lastSend = 0;

static const char* commandTypeName(CommandType c) {
    switch (c) {
        case CMD_STEER: return "CMD_STEER";
        case CMD_START: return "CMD_START";
        case CMD_DRIVE: return "CMD_DRIVE";
        case CMD_EMERGENCY_STOP: return "CMD_EMERGENCY_STOP";
        default: return "CMD_UNKNOWN";
    }
}

CommandType parseCommandKey(const JsonDocument& doc) {
    if (doc["data"]["mega"]["command"] == "steer") return CMD_STEER;
    if (doc["data"]["mega"]["command"] == "start") return CMD_START;
    if (doc["data"]["mega"]["command"] == "drive") return CMD_DRIVE;
    if (doc["data"]["mega"]["command"] == "emergency_stop") return CMD_EMERGENCY_STOP;
    return CMD_UNKNOWN;
}

void messagingHandleInput() {
  if(!Serial1.available()) return;

  String input = Serial1.readStringUntil('\n');
  if(input.length() == 0) return;
  input.trim();


    StaticJsonDocument<512> doc;
    DeserializationError err = deserializeJson(doc, input);
    if(err) {
        Serial.print(F("JSON parse failed: "));
        Serial.println(err.c_str());
        dbgPrintRaw_(input);
        Serial.print(F("Doc capacity: ")); Serial.print(doc.capacity());
      Serial.print(F(" bytes, used: ")); Serial.println(doc.memoryUsage());
      return;
  }

//  dbgPrintJson_(doc);

  if (doc.containsKey("sys") && doc["sys"].containsKey("hb")) {
      uint32_t t = doc["sys"]["hb"].as<uint32_t>();
      securityWatchdogOnEspKeepAlive(t);
      return;
  }

  CommandType cmd = parseCommandKey(doc);

  switch (cmd) {
      case CMD_STEER: {
          // Basic angle command
          if (doc["data"]["mega"].containsKey("angle")) {
              steeringSetAngle(doc["data"]["mega"]["angle"].as<float>());
          }
          // Simple manual zeroing: declare current physical angle as logical zero
          if (doc["data"]["mega"].containsKey("zeroAngleDeg")) {
              steeringSetZeroAngleDeg(doc["data"]["mega"]["zeroAngleDeg"].as<float>());
          }
          // Adjust homing inactivity window ms
          if (doc["data"]["mega"].containsKey("homingNoPulseMs")) {
              steeringSetHomingNoPulseMs(doc["data"]["mega"]["homingNoPulseMs"].as<unsigned long>());
          }
          break; }
      case CMD_START:
          actuatorStart(doc["data"]["mega"]["start"].as<bool>());
          break;
      case CMD_DRIVE:
          actuatorDrive(doc["data"]["mega"]["isMoving"].as<bool>());
          break;
      case CMD_EMERGENCY_STOP:
          actuatorDrive(false);
          actuatorStart(false);
          steeringSetAngle(0.0);
          break;
      default:
            dbgPrintJson_(doc);
            Serial.print("Unknown command received\n");
            break;
  }
}

void messagingSendTelemetry() {
  if(millis() - lastSend < 1000) return;
  lastSend = millis();

  StaticJsonDocument<384> doc;
  doc["topic"] = "telemetry";
  doc["data"]["stepperAngle"] = steeringGetCommandedAngle();
  doc["data"]["actualAngleFromOptic"] = wheelGetAngle();
  // Removed centerOffsetDeg telemetry (simplified logic)
  doc["data"]["limitLeftDeg"] = steeringGetLimitLeftDeg();
  doc["data"]["limitRightDeg"] = steeringGetLimitRightDeg();
  doc["data"]["limitLeftSteps"] = steeringGetLimitLeftSteps();
  doc["data"]["limitRightSteps"] = steeringGetLimitRightSteps();
  serializeJson(doc, Serial1);
  Serial1.println();
//  Serial.println("[MEGA] Sending telemetry: " + json);
}
