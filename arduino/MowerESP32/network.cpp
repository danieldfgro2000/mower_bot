#include "network.h"
#include <WiFi.h>

const char* ssid = "MOWER_HOTSPOT";
const char* password = "2uGabriel";

void networkInit() {
    delay(1);
  WiFi.softAP(ssid, password);
  Serial.print("Hotspot IP: ");
  Serial.println(WiFi.softAPIP());
}
