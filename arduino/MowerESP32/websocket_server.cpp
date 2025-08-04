#include "websocket_server.h"
#include <ESPAsyncWebServer.h>

extern AsyncWebServer server;
AsyncWebSocket ws("/ws");

void websocketInit() {
  ws.onEvent([](AsyncWebSocket * server, AsyncWebSocketClient * client,
      AwsEventType type, void * arg, uint8_t * data, size_t len) {
        if(type == WS_EVT_CONNECT) {
          Serial.printf("Client %u connected\n", client->id());
        } else if (type == WS_EVT_DISCONNECT) {
          Serial.printf("Client %u disconnected\n", client->id());
        }
      });
  server.addHandler(&ws);
  Serial.println("Websocket server started on /ws");
}

void websocketSend(const String &msg) {
  ws.textAll(msg);
}
