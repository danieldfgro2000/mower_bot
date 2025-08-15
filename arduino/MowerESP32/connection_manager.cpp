#include "connection_manager.h"
#include "network.h"
#include "websocket_server.h"

namespace {
    bool wsStarted = false;
    bool lastConnected = false;

    void maybePrintIp() {
        auto ip = network::ip();
        if(ip != IPAddress()) {
            Serial.printf("[WS] IP: %s\n", ip.toString().c_str());
        }
    }
}

namespace conn {
    void begin() {
        wsStarted = false;
        lastConnected = false;
    }
    void loop() {
        network::loop();

        const bool connected = network::isConnected();

        if(connected != lastConnected) {
            maybePrintIp();
        }

        lastConnected = connected;

        if(connected) {
            const uint16_t targetPort = network::webSocketPort();
            if(!wsStarted || !ws::isRunning() || ws::currentPort() != network::webSocketPort()) {
                ws::restart(network::webSocketPort());
                wsStarted = true;
            }
        }

        if(wsStarted) {
            ws::loop();
        } else {
            Serial.println(F("[WS] WebSocket server not started."));
        }
    }
}