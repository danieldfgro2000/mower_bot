#include <wifi_adapter.h>

#include <ws_server.h>
#include <mega_serial.h>

#include <router.h>
#include <heartbeat.h>

#include "secrets.h"
#include "pins_esp32cam.h"

using namespace Mower;

WifiAdapter             g_net;
WsServer                g_ws;
MegaSerial              g_mega;
Router                  g_router;
Heartbeat               g_hb;

void setup() {
    Serial.begin(115200);
    delay(200);

    // 1) Bring up Wi-Fi (auto-reconnect handled internally)
    g_net.onConnected([](){

    });
    Serial.printf("[NET] Connecting to Wi-Fi SSID: %s\n", MowerConfig::WIFI_SSID);
    g_net.begin(MowerConfig::WIFI_SSID, MowerConfig::WIFI_PASSWORD);

    // 2) Serial bridge to Mega 2560 (pins from config/pins_esp32cam.h)
    g_mega.begin(115200, ESP32CAM_MEGASERIAL_RX, ESP32CAM_MEGASERIAL_TX);

    // 3) WebSocket server (for Flutter app)
    g_ws.begin(81);
    g_ws.onMessage([](const JsonDocument& doc, uint8_t clientId) {
        // Forward command payloads to Mega as line-delimited JSON
        if(doc["type"] == "command") {
            String line;
            serializeJson(doc, line);
            g_mega.writeLine(line);
        }
    });

    g_router.begin(&g_ws, &g_mega);
    g_router.attachHeartbeat(&g_hb);

    g_hb.begin(&g_ws, &g_net);
}

void loop() {
    g_net.loop();
    g_ws.loop();
    g_router.loop();
    g_hb.loop();

    // Keep alive pings
    static uint32_t lastPing = 0;
    if (millis() - lastPing > 15000UL) {
        lastPing = millis();
        g_ws.pingAll();
    }
}
