#include "messaging.h"
#include "steering.h"
#include "wheel_telemetry.h"
#include "actuators.h"
#include <ArduinoJson.h>
#include <Arduino.h>

static unsigned long lastSend = 0;

void messagingInit() {
  Serial1.begin(115200); // ESP32 link
}

void messagingHandleInput() {
  if(!Serial1.available()) return;

  String input = Serial1.readStringUntil('\n');
  input.trim();
  if(input.length() == 0) return;

  StaticJsonDocument<256> doc;
  DeserializationError err = deserializeJson(doc, input);
  if(err) {
    Serial.println("JSON parse failed.");
    return;
  }

  if(doc.containsKey("steer")) {
    float angle = doc["steer"].as<float>();
    steeringSetAngle(angle);
  }

  if(doc.containsKey("start")) {
    bool start = doc["start"].as<bool>();
    actuatorStart(start);
  }

  if(doc.containsKey("drive")) {
    bool drive = doc["drive"].as<bool>();
    actuatorDrive(drive);
  }
}

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
