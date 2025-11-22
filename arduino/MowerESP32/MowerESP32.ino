#include "esp_camera.h"
#include <mower_esp.h>

#include "secrets.h"
#include "pins_esp_to_mega.h"
#include "sd_recorder.h"
#include "path_recorder.h" // added
#include "path_player.h"   // added

using namespace Mower;

WifiAdapter   wifiAdapter;
WsServer      wsServer;
CameraSetup   cameraSetup;
MegaSerial    megaSerial;
ESPMegaRouter espMegaRouter;
Heartbeat     heartbeat;
SdRecorder    sdRecorder;
PathRecorder  pathRecorder;   // new
PathPlayer    pathPlayer;     // new

void startCameraServer();

void setup() {
    Serial.begin(115200);
    delay(200);

    log_err(esp_reset_reason(), "BOOT");

    // Initialize SD card early (one-bit mode for safer wiring on ESP32-CAM)
    sdRecorder.begin("/sdcard", true);
    pathRecorder.begin("/sdcard");
    pathPlayer.begin("/sdcard");

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
        // Intercept SD/path record & playback commands coming from Flutter
        const char* topic = doc["topic"] | "";
        if (strcmp(topic, "drive") == 0 && doc["data"].is<JsonObject>()) {
            const char* cmd = doc["data"]["cmd"] | "";
            if (strcmp(cmd, "start_record") == 0) {
                // Optional custom session base name (for camera frames only)
                String base = doc["data"]["fileName"].is<const char*>() ? String(doc["data"]["fileName"].as<const char*>()) : String("");
                if (base.length() == 0) {
                    base = String("rec_") + String((unsigned long)millis());
                }
                bool startedFrames = sdRecorder.startRecording(base); // image recording
                bool startedPath = pathRecorder.start();             // angle path recording
                log_i("Record start: frames=%s path=%s base=%s", startedFrames ? "OK" : "NO", startedPath ? "OK" : "NO", base.c_str());
                return; // handled locally, don't forward to Mega
            } else if (strcmp(cmd, "stop_record") == 0) {
                // fileName designates final path name; rename path file accordingly
                String finalName = doc["data"]["fileName"].is<const char*>() ? String(doc["data"]["fileName"].as<const char*>()) : String("path_") + String((unsigned long)millis());
                bool stoppedFrames = sdRecorder.stopRecording();
                bool stoppedPath = pathRecorder.stop(finalName);
                log_i("Record stop: frames=%s path=%s name=%s", stoppedFrames ? "OK" : "NO", stoppedPath ? "OK" : "NO", finalName.c_str());
                return; // handled locally, don't forward to Mega
            } else if (strcmp(cmd, "play_path") == 0) {
                String name = doc["data"]["fileName"].is<const char*>() ? String(doc["data"]["fileName"].as<const char*>()) : String("");
                if (name.length() == 0) {
                    log_w("play_path missing fileName");
                } else {
                    bool ok = pathPlayer.play(name);
                    log_i("Path play request: %s => %s", name.c_str(), ok ? "OK" : "FAIL");
                }
                return; // local
            } else if (strcmp(cmd, "stop_path") == 0) {
                pathPlayer.stop();
                log_i("Path playback stop requested");
                return; // local
            }
        }

        // Default: forward to Mega
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
    // Added path recording & playback loops
    pathRecorder.loop();
    pathPlayer.loop();
}
