#include "messaging.h"
#include "steering.h"
#include "wheel_telemetry.h"
#include "actuators.h"
#include "path_manager_global.h"
#include <ArduinoJson.h>
#include <Arduino.h>

static unsigned long lastSend = 0;

void messagingInit() {
  Serial.begin(115200); // For debugging
  Serial1.begin(115200); // ESP32 link
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

  CommandType cmd = parseComandKey(doc);

  switch (cmd) {
      case CMD_STEER:
          steeringSetAngle(doc["steer"].as<float>());
          break;
      case CMD_START:
          actuatorStart(doc["start"].as<bool>());
          break;
      case CMD_DRIVE:
          actuatorDrive(doc["drive"].as<bool>());
          break;
      case CMD_PATH_RECORDING_START:
            if(doc.containsKey("path_name")) {
                const char *pathName = doc["path_name"].as<const char *>();
                pathManager.startRecording(pathName);
            } else {
                Serial.println("Error: 'path_name' key is missing in path_recording_start command.");
            }
          pathManager.startRecording();
          break;
      case CMD_PATH_RECORDING_STOP:
          pathManager.stopRecording();
          break;
      case CMD_PATH_LIST:
          pathManager.listPaths();
          break;
      case CMD_PATH_PLAY:
            if(doc.containsKey("path_name")) {
                const char *pathName = doc["path_name"].as<const char *>();
                pathManager.playPath(pathName);
            } else {
                Serial.println("Error: 'path_name' key is missing in path_play command.");
            }
      case CMD_PATH_DELETE:
            if(doc.containsKey("path_name")) {
                const char *pathName = doc["path_name"].as<const char *>();
                pathManager.deletePath(pathName);
            } else {
                Serial.println("Error: 'path_name' key is missing in path_delete command.");
            }
          break;
      default:
            Serial.println("Unknown command received. %s", cmd);
            break;
  }
}

enum CommandType {
    CMD_UNKNOWN,
    CMD_STEER,
    CMD_START,
    CMD_DRIVE,
    CMD_PATH_RECORDING_START,
    CMD_PATH_RECORDING_STOP,
    CMD_PATH_LIST,
    CMD_PATH_PLAY,
    CMD_PATH_DELETE
};

CommandType parseComandKey(const JsonDocument& doc) {

    if(command == "steer") return CMD_STEER;
    if(command == "start") return CMD_START;
    if(command == "drive") return CMD_DRIVE;
    if(command == "path_recording_start") return CMD_PATH_RECORDING_START;
    if(command == "path_recording_stop") return CMD_PATH_RECORDING_STOP;
    if(command == "path_list") return CMD_PATH_LIST;
    if(command == "path_play") return CMD_PATH_PLAY;
    if(command == "path_delete") return CMD_PATH_DELETE;
  return CMD_UNKNOWN;

void messagingSendTelemetry() {
  if(millis() - lastSend < 200) return;
  lastSend = millis();

  StaticJsonDocument<256> doc;
  doc["angle"] = steeringGetCommandedAngle();
  doc["encoder"] = steeringGetActualAngle();
  doc["distance"] = wheelGetDistance();
  doc["speed"] = wheelGetSpeed();
  doc["homed"] = steeringIsHomed();

  String json;
  serializeJson(doc, json);
  Serial1.println(json);
}
