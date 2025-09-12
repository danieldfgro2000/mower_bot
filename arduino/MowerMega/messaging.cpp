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

//  dbgPrintRaw_(input);

  StaticJsonDocument<512> doc;
  DeserializationError err = deserializeJson(doc, input);
  if(err) {
      Serial.print(F("JSON parse failed: "));
      Serial.println(err.c_str());
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
