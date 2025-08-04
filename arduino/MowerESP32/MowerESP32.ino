#include <ESPAsyncWebServer.h>
#include "network.h"
#include "http_server.h"
#include "serial_link.h"
#include "telemetry_store.h"
#include "websocket_server.h"
#include "connection_manager.h"

AsyncWebServer server(81);

String lastTelemetry = "{}";

extern ConnectionManager connectionManager;

void setup() {
  Serial.begin(115200); //For debugging
  initWebSocket();
  connectionManager.begin();
  
  telemetryStoreInit();
  serialLinkInit();
 
  Serial.println("[WS] WebSocket server started");

}

void loop() {
  serialLinkLoop();
  ws.cleanupClients();
}
