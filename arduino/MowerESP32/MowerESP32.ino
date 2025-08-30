#include <mower_esp.h>

#include "secrets.h"
#include "pins_esp32cam.h"

using namespace Mower;

WifiAdapter   wifiAdapter;
WsServer      wsServer;
MjpegStream   mjpegStream;
MjpegServer   mjpegServer(mjpegStream, 8082);
CameraSetup   cameraSetup;
MegaSerial    megaSerial;
ESPMegaRouter espMegaRouter;
Heartbeat     heartbeat;

void setup() {
    Serial.begin(115200);
    delay(200);
    log_err(esp_reset_reason(), "BOOT");

    wifiAdapter.onConnected([](){
        wsServer.begin(81);

        if (cameraSetup.begin() != ESP_OK) {
            Serial.println("[VIDEO] Camera init failed - video disabled");
        } else {
            mjpegStream.setTargetFps(10);     // start conservative (10fps)
            mjpegServer.setSingleClient(true);
            mjpegServer.begin();
        }
    });

    wifiAdapter.onDisconnected([](int reason){
        wsServer.stop();
        mjpegServer.end(); // ✅ ensure stream task stops on disconnect
    });

    wifiAdapter.begin(MowerConfig::WIFI_SSID, MowerConfig::WIFI_PASSWORD);
    delay(100);

    wsServer.onMessage([](const JsonDocument& doc, uint8_t clientId) {
        if (doc["topic"] == "mega_cmd") {
            String line; serializeJson(doc, line);
            megaSerial.writeLine(line);
        }
        if (doc["topic"] == "camera") {
            Serial.println("[WS] Camera command");
        }
    });

    megaSerial.begin(115200, ESP32CAM_MEGASERIAL_RX, ESP32CAM_MEGASERIAL_TX);
    espMegaRouter.begin(&wsServer, &megaSerial);
    espMegaRouter.attachHeartbeat(&heartbeat);
    heartbeat.begin(&wsServer, &wifiAdapter);
    heartbeat.setIntervals(5000, 15000, 30000);
}

void loop() {
    TRACE_LOOP("wifi",   wifiAdapter.loop());
    TRACE_LOOP("ws",     wsServer.loop());
    TRACE_LOOP("router", espMegaRouter.loop());
    TRACE_LOOP("hb",     heartbeat.loop());
}
