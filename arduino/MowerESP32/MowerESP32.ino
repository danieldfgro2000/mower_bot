#include "esp_camera.h"
#include <mower_esp.h>

#include "secrets.h"
#include "pins_esp_to_mega.h"

using namespace Mower;

WifiAdapter   wifiAdapter;
WsServer      wsServer;
CameraSetup   cameraSetup;
MegaSerial    megaSerial;
ESPMegaRouter espMegaRouter;
Heartbeat     heartbeat;

void startCameraServer();

void setup() {
    Serial.begin(115200);
    delay(200);

    log_err(esp_reset_reason(), "BOOT");

    wifiAdapter.onConnected([](){
        wsServer.begin(85);
        if (cameraSetup.begin() == ESP_OK) startCameraServer();
    });

    wifiAdapter.onDisconnected([](int reason){
        wsServer.stop();
    });

    wifiAdapter.begin(MowerConfig::WIFI_SSID, MowerConfig::WIFI_PASSWORD);
//    wifiAdapter.beginAP(MowerConfig::AP_SSID, MowerConfig::AP_PASSWORD, 11, false, 4);
    delay(100);

    wsServer.onMessage([](const JsonDocument& doc, uint8_t clientId) {
        String line;
        serializeJson(doc, line);
        megaSerial.writeLine(line);
    });

    megaSerial.begin(115200, ESP32CAM_MEGASERIAL_RX, ESP32CAM_MEGASERIAL_TX, Serial);

    espMegaRouter.begin(&wsServer, &megaSerial);
    espMegaRouter.attachHeartbeat(&heartbeat);

    heartbeat.begin(&wsServer, &wifiAdapter, &megaSerial);
}

void loop() {
    TRACE_LOOP("wifi",   wifiAdapter.loop());
    TRACE_LOOP("ws",     wsServer.loop());
    TRACE_LOOP("router", espMegaRouter.loop());
    TRACE_LOOP("hb",     heartbeat.loop());
}
