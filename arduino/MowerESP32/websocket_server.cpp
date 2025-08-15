#include "websocket_server.h"
#include <WebSocketsServer.h>

namespace {
    WebSocketsServer* g_server = nullptr;
    uint16_t g_port = 0;
    uint8_t g_connectedCount = 0;

    void ensureStopped() {
        if(g_server) {
            g_server->close();
            delete g_server;
            g_server = nullptr;
            g_port = 0;
            g_connectedCount = 0;
        }
    }

    void onWsEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {

        switch (type) {
            case WStype_CONNECTED:
                if(g_connectedCount < 255) g_connectedCount++;
                break;
            case WStype_DISCONNECTED:
                if(g_connectedCount > 0) g_connectedCount--;
                break;
            case WStype_TEXT:
                // Handle incoming text payload here
                // Example: echo back
                if (g_server) g_server->sendTXT(num, payload, length);
                break;
            case WStype_BIN:
                // Handle binary payload if you use it
                break;
            default:
                break;
      }
  }

}

namespace ws {
    void begin(uint16_t port) {
        if(g_server && g_port == port) return;
        ensureStopped();
        
        g_server = new WebSocketsServer(port);
        g_server->begin();
        g_server->onEvent(onWsEvent);
        g_port = port;
        
        Serial.printf("[WS] WebSocket server started on port %d\n", g_port);
    }

    void loop() {
        if(g_server) g_server->loop();
    }
    void restart(uint16_t port) {
        ensureStopped();
        begin(port);
    }
    bool isRunning() {
        return g_server != nullptr;
    }
    uint16_t currentPort() {
        return g_port;
    }
    bool hasClients() { return g_connectedCount > 0; }
    uint8_t connectedCount() { return g_connectedCount; }
}

ConnectionManagerLegacyShim connectionManager;

bool ConnectionManagerLegacyShim::hasClients() const {
  return ws::hasClients();
}
