#include "websocket_server.h"

AsyncWebSocket ws("/ws");
ConnectionManager connectionManager(ws);

static void onWsEvent(AsyncWebSocket * server, AsyncWebSocketClient * client,
      AwsEventType type, void * arg, uint8_t * data, size_t len) {

        switch (type) {
          case WS_EVT_CONNECT:
            connectionManager.onClientConnected(client);
            break;
          case WS_EVT_DISCONNECT:
            connectionManager.onClientDisconnected(client);
            break;
          case WS_EVT_DATA: {
            String msg = "";
            for (size_t i = 0; i < len; i++) {
                msg += (char) data[i];
            }
            // Handle incoming control message here
            Serial.printf("WS Message: %s\n", msg.c_str());
            break;
          } 
          default:
            break;
      };
      
      if(type == WS_EVT_CONNECT) {
          Serial.printf("Client %u connected\n", client->id());
      } else if (type == WS_EVT_DISCONNECT) {
          Serial.printf("Client %u disconnected\n", client->id());
      }       
}

void initWebSocket() {
  ws.onEvent(onWsEvent);
}
