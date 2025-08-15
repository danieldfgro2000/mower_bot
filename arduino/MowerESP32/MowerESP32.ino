#include <ESPAsyncWebServer.h>
#include "network.h"
#include "serial_link.h"
#include "telemetry_store.h"
#include "websocket_server.h"
#include "connection_manager.h"

using namespace network;

void setup() {
    Serial.begin(115200);
    delay(100);

    network::NetworkConfig cfg{};

    // WiFi mower credentials
    cfg.ssid = "MOWER_BOT";
    cfg.password = "mower1234";

    // Optional static IP configuration (disable for DHCP)
    cfg.staticIp.enabled = false;

    cfg.staticIp.local = IPAddress(192, 168, 1, 60);
    cfg.staticIp.gateway = IPAddress(192, 168, 1, 1);
    cfg.staticIp.subnet = IPAddress(255, 255, 255, 0);
    cfg.staticIp.dns1 = IPAddress(8, 8, 8, 8);
    cfg.staticIp.dns2 = IPAddress(1, 1, 1, 1);

    // WebSocket port
    cfg.ws.port = 81; // Default Web

    //  ---- Boot sequence ----
    network::begin(cfg);
    conn::begin();
}
void loop() {
    conn::loop();
}
