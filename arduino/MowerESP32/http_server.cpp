#include "http_server.h"
#include "telemetry_store.h"
#include <ESPAsyncWebServer.h>

extern AsyncWebServer server;

void httpServerInit() {
  
  // ---- POST /command ----

  server.on("/command", HTTP_POST, [](AsyncWebServerRequest *request) {
    if (request->hasParam("body", true)) {
      const AsyncWebParameter* p = request->getParam("body", true);
      String jsonCommand = p->value();
      Serial2.println(jsonCommand); // Forward to Mega
      Serial.println("[CMD]" + jsonCommand);
      request->send(200, "application/json",  "{\"status\":\"OK\"}");
    } else {
      request->send(400, "application/json", "{\"error\":\"Missing body\"}");
   
    }
  });

  // ---- GET /telemetry ----

  server.on("/telemetry", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send(200, "application/json", telemetryGet());
  });

  server.begin();
  Serial.println("HTTP server started");
}
