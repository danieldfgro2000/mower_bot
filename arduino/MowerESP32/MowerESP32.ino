#include <esp32_debug.h>
#include <wifi_adapter.h>
#include <esp32_debug.h>
#include <ws_server.h>      // control WS (JSON) on port 81
//#include <ws_async_video.h> // Async video WS on port 82
#include <zzz_ws_video.h> // Sync video WS on port 82
#include <camera_setup.h>
#include <mega_serial.h>

#include <esp_mega_router.h>
#include <heartbeat.h>

#include "secrets.h"
#include "pins_esp32cam.h"

using namespace Mower;

WifiAdapter             wifiAdapter;
WsServer                wsServer;
//WsAsyncVideo            wsAsyncVideo(82, "/video");
WsVideo                 wsVideo(wsServer);
CameraSetup             cameraSetup;
MegaSerial              megaSerial;
ESPMegaRouter           espMegaRouter;
Heartbeat               heartbeat;

void setup() {
    Serial.begin(115200);
    delay(200);
    log_err(esp_reset_reason(), "BOOT");

    wifiAdapter.onConnected([](){
        wsServer.begin(81);

        if (cameraSetup.begin() != ESP_OK) {
            Serial.println("[VIDEO] Camera init failed - video disabled");
        } else {
//            wsAsyncVideo.begin(25);
        }
    });
    wifiAdapter.onDisconnected([](int reason){
//        wsAsyncVideo.stop();
        wsVideo.stopAll();
        wsServer.stop();
    });
    wifiAdapter.begin(MowerConfig::WIFI_SSID, MowerConfig::WIFI_PASSWORD);
    delay(100);

    wsServer.onMessage([](const JsonDocument& doc, uint8_t clientId) {
        if(doc["topic"] == "mega_cmd") {
            String line;
            serializeJson(doc, line);
            megaSerial.writeLine(line);
        }

        if(strcmp(doc["topic"] | "", "camera") == 0) {
            wsVideo.handleMessage(doc, clientId);
//            const char* cmd = doc["data"]["cmd"] | "";
//            if(strcmp(cmd, "start") == 0) {
//                uint8_t reqFps = doc["data"]["fps"] | 15;
////                wsAsyncVideo.start(reqFps);
//                DynamicJsonDocument ack(128);
//                ack["topic"] = "camera";
//                ack["event"] = "started";
//                ack["fps"] = reqFps;
//                String out;
//                serializeJson(ack, out);
//                wsServer.sendTXT(clientId, out);
//            } else if(strcmp(cmd, "stop") == 0) {
////                wsAsyncVideo.stop();
//                DynamicJsonDocument ack(96);
//                ack["topic"] = "camera";
//                ack["event"] = "stopped";
//                String out;
//                serializeJson(ack, out);
//                wsServer.sendTXT(clientId, out);
//            }
        }
    });

    megaSerial.begin(115200, ESP32CAM_MEGASERIAL_RX, ESP32CAM_MEGASERIAL_TX);

    espMegaRouter.begin(&wsServer, &megaSerial);
    espMegaRouter.attachHeartbeat(&heartbeat);

    heartbeat.begin(&wsServer, &wifiAdapter);
//    heartbeat.setVideoStreamingProvider([&]() { return wsAsyncVideo.isStreaming(); });
    heartbeat.setIntervals(5000, 15000, 30000);
}

void loop() {
    TRACE_LOOP("wifi", wifiAdapter.loop());
    TRACE_LOOP("ws", wsServer.loop());
    TRACE_LOOP("ws video", wsVideo.loop());
    TRACE_LOOP("router", espMegaRouter.loop());
    TRACE_LOOP("hb", heartbeat.loop());
}