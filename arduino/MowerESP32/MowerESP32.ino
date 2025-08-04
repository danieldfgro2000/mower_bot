#include <ESPAsyncWebServer.h>
#include "network.h"
#include "http_server.h"
#include "serial_link.h"
#include "telemetry_store.h"

AsyncWebServer server(81);

String lastTelemetry = "{}";


void setup() {
  Serial.begin(115200); //For debugging
  telemetryStoreInit();
  serialLinkInit();
  networkInit();
  httpServerInit();
 
  Serial.println("[WS] WebSocket server started");

}

void loop() {
  serialLinkLoop();
}
