#include "esp_camera.h"
#include <mower_esp.h>
#include <SD_MMC.h>
#include <ArduinoJson.h>

#include "secrets.h"
#include "pins_esp_to_mega.h"
#include "sd_recorder.h"
#include "path_recorder.h"
#include "path_player.h"

using namespace Mower;

WifiAdapter   wifiAdapter;
WsServer      wsServer;
CameraSetup   cameraSetup;
MegaSerial    megaSerial;
ESPMegaRouter espMegaRouter;
Heartbeat     heartbeat;
SdRecorder    sdRecorder;
PathRecorder  pathRecorder;
PathPlayer    pathPlayer;

void startCameraServer();

// ── helpers ──────────────────────────────────────────────────

// SD mount point and paths directory — must match PathRecorder/PathPlayer
static const char* const MOUNT_POINT  = "/sdcard";
static const char* const PATHS_DIR    = "/paths";

/// Strip a trailing ".csv" extension (case-sensitive) from a name string.
static String stripCsv(const String& name) {
    if (name.endsWith(".csv")) return name.substring(0, name.length() - 4);
    return name;
}

static void broadcastPathEvent(const char* event, const char* name, bool ok) {
    StaticJsonDocument<160> doc;
    doc["topic"]        = "pathEvent";
    doc["data"]["event"] = event;
    doc["data"]["name"]  = name;
    doc["data"]["ok"]    = ok;
    wsServer.broadcastJson(doc);
}

static void printPathDiagToSerial(const JsonDocument& doc) {
    Serial.println(F("[PATH][DIAG] ================================="));
    Serial.print(F("[PATH][DIAG] sdOk="));
    Serial.print(doc["data"]["sdOk"].as<bool>() ? F("true") : F("false"));
    Serial.print(F(" totalMB="));
    Serial.print(doc["data"]["sdTotalMB"].as<uint32_t>());
    Serial.print(F(" usedMB="));
    Serial.print(doc["data"]["sdUsedMB"].as<uint32_t>());
    Serial.print(F(" freeMB="));
    Serial.println(doc["data"]["sdFreeMB"].as<uint32_t>());

    Serial.print(F("[PATH][DIAG] dir='"));
    Serial.print(doc["data"]["pathsDir"].as<const char*>());
    Serial.print(F("' exists="));
    Serial.print(doc["data"]["pathsDirExists"].as<bool>() ? F("true") : F("false"));
    Serial.print(F(" count="));
    Serial.println(doc["data"]["pathCount"].as<uint16_t>());

    Serial.print(F("[PATH][DIAG] recording="));
    Serial.print(doc["data"]["isRecording"].as<bool>() ? F("true") : F("false"));
    Serial.print(F(" samples="));
    Serial.print(doc["data"]["recordSampleCount"].as<uint32_t>());
    Serial.print(F(" temp='"));
    Serial.print(doc["data"]["recordTempFile"].as<const char*>());
    Serial.print(F("' saved='"));
    Serial.print(doc["data"]["recordLastSavedFile"].as<const char*>());
    Serial.print(F("' err='"));
    Serial.print(doc["data"]["recordLastError"].as<const char*>());
    Serial.println(F("'"));

    Serial.print(F("[PATH][DIAG] playing="));
    Serial.print(doc["data"]["isPlaying"].as<bool>() ? F("true") : F("false"));
    Serial.print(F(" samples="));
    Serial.print(doc["data"]["playSampleCount"].as<uint32_t>());
    Serial.print(F(" malformed="));
    Serial.print(doc["data"]["playMalformedCount"].as<uint32_t>());
    Serial.print(F(" active='"));
    Serial.print(doc["data"]["playActiveFile"].as<const char*>());
    Serial.print(F("' err='"));
    Serial.print(doc["data"]["playLastError"].as<const char*>());
    Serial.println(F("'"));

    JsonArrayConst paths = doc["data"]["paths"].as<JsonArrayConst>();
    for (JsonObjectConst p : paths) {
        Serial.print(F("[PATH][DIAG] file name='"));
        Serial.print(p["name"].as<const char*>());
        Serial.print(F("' size="));
        Serial.print(p["sizeBytes"].as<uint32_t>());
        Serial.print(F(" estSamples="));
        Serial.println(p["estSamples"].as<uint32_t>());
    }
    Serial.println(F("[PATH][DIAG] ================================="));
}

static void broadcastPathList() {
    StaticJsonDocument<2048> doc;
    doc["topic"] = "pathList";
    JsonArray arr = doc["data"].createNestedArray("paths");

    if (SD_MMC.exists(PATHS_DIR)) {
        File root = SD_MMC.open(PATHS_DIR);
        if (root && root.isDirectory()) {
            File entry = root.openNextFile();
            while (entry) {
                if (!entry.isDirectory()) {
                    String name = String(entry.name());
                    int slash = name.lastIndexOf('/');
                    if (slash >= 0) name = name.substring(slash + 1);
                    if (name.endsWith(".csv")) arr.add(name);
                }
                entry.close();
                entry = root.openNextFile();
            }
            root.close();
        }
    }

    Serial.print(F("[PATH] list_paths count="));
    Serial.println(arr.size());
    for (JsonVariant v : arr) {
        Serial.print(F("[PATH] list_paths item='"));
        Serial.print(v.as<const char*>());
        Serial.println(F("'"));
    }

    wsServer.broadcastJson(doc);
}

// Sends detailed SD + path diagnostics back over WebSocket
// Topic "pathDiag" — Flutter just needs to log / display it.
static void broadcastPathDiag() {
    StaticJsonDocument<3072> doc;
    doc["topic"] = "pathDiag";

    bool sdOk = SD_MMC.cardType() != CARD_NONE;
    doc["data"]["sdOk"]      = sdOk;
    doc["data"]["sdTotalMB"] = (uint32_t)(SD_MMC.totalBytes() / (1024 * 1024));
    doc["data"]["sdUsedMB"]  = (uint32_t)(SD_MMC.usedBytes()  / (1024 * 1024));
    doc["data"]["sdFreeMB"]  = (uint32_t)((SD_MMC.totalBytes() - SD_MMC.usedBytes()) / (1024 * 1024));
    doc["data"]["pathsDir"]  = PATHS_DIR;
    doc["data"]["isRecording"] = pathRecorder.isRecording();
    doc["data"]["isPlaying"]   = pathPlayer.isPlaying();
    doc["data"]["recordSampleCount"] = pathRecorder.sampleCount();
    doc["data"]["recordTempFile"] = pathRecorder.activeTempFilePath();
    doc["data"]["recordLastSavedFile"] = pathRecorder.lastSavedFilePath();
    doc["data"]["recordLastError"] = pathRecorder.lastError();
    doc["data"]["playSampleCount"] = pathPlayer.sampleCount();
    doc["data"]["playMalformedCount"] = pathPlayer.malformedCount();
    doc["data"]["playActiveFile"] = pathPlayer.activeFilePath();
    doc["data"]["playLastError"] = pathPlayer.lastError();

    bool dirExists = SD_MMC.exists(PATHS_DIR);
    doc["data"]["pathsDirExists"] = dirExists;

    JsonArray arr = doc["data"].createNestedArray("paths");
    uint16_t totalCount = 0;

    if (dirExists) {
        File root = SD_MMC.open(PATHS_DIR);
        if (root && root.isDirectory()) {
            File entry = root.openNextFile();
            while (entry) {
                if (!entry.isDirectory()) {
                    String name = String(entry.name());
                    int slash = name.lastIndexOf('/');
                    if (slash >= 0) name = name.substring(slash + 1);

                    if (name.endsWith(".csv")) {
                        uint32_t sz = (uint32_t)entry.size();
                        // Estimate: subtract header line (~10 B), divide by avg line len (~12 B)
                        uint32_t est = sz > 10 ? (sz - 10) / 12 : 0;

                        JsonObject obj = arr.createNestedObject();
                        obj["name"]       = name;
                        obj["sizeBytes"]  = sz;
                        obj["estSamples"] = est;
                        totalCount++;
                    }
                }
                entry.close();
                entry = root.openNextFile();
            }
            root.close();
        }
    }
    doc["data"]["pathCount"] = totalCount;

    log_i("[DIAG] SD=%s %luMB total %luMB free | paths=%u | rec=%s(%lu) play=%s(%lu/%lu malformed)",
          sdOk ? "OK" : "FAIL",
          (unsigned long)doc["data"]["sdTotalMB"].as<uint32_t>(),
          (unsigned long)doc["data"]["sdFreeMB"].as<uint32_t>(),
          (unsigned)totalCount,
          pathRecorder.isRecording() ? "YES" : "no",
          (unsigned long)pathRecorder.sampleCount(),
          pathPlayer.isPlaying()     ? "YES" : "no",
          (unsigned long)pathPlayer.sampleCount(),
          (unsigned long)pathPlayer.malformedCount());

    printPathDiagToSerial(doc);

    wsServer.broadcastJson(doc);
}

// ── setup ────────────────────────────────────────────────────

void setup() {
    Serial.begin(115200);
    delay(200);

    log_err(esp_reset_reason(), "BOOT");

    // Initialise SD card early (one-bit mode – safest wiring for ESP32-CAM)
    sdRecorder.begin(MOUNT_POINT, true);
    pathRecorder.begin(MOUNT_POINT);
    pathPlayer.begin(MOUNT_POINT);
    Serial.println(F("[PATH] startup diagnostics after SD/path init"));
    broadcastPathDiag();

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

    wsServer.onMessage([](const JsonDocument& doc, uint8_t /*clientId*/) {
        const char* topic = doc["topic"] | "";
        JsonVariantConst data = doc["data"].as<JsonVariantConst>();

        if (strcmp(topic, "drive") == 0 && data.is<JsonObjectConst>()) {
            const char* cmd = data["cmd"] | "";

            // ── start recording ──────────────────────────────
            if (strcmp(cmd, "start_record") == 0) {
                Serial.println(F("[PATH] command=start_record"));
                bool ok = pathRecorder.start();
                log_i("Record start: %s", ok ? "OK" : "FAIL");
                broadcastPathEvent("recordStarted", "", ok);
                broadcastPathDiag();
                return;

            // ── stop recording ───────────────────────────────
            } else if (strcmp(cmd, "stop_record") == 0) {
                const char* fn = data["fileName"] | "";
                // Strip accidental .csv suffix; empty name = discard
                String name = stripCsv(String(fn));
                Serial.print(F("[PATH] command=stop_record file='"));
                Serial.print(name);
                Serial.println(F("'"));
                bool ok = pathRecorder.stop(name);   // empty → discards temp file
                log_i("Record stop: '%s' => %s", name.c_str(), ok ? "OK" : "FAIL");
                broadcastPathEvent("recordStopped", name.c_str(), ok);
                broadcastPathDiag();
                return;

            // ── play path ────────────────────────────────────
            } else if (strcmp(cmd, "play_path") == 0) {
                const char* fn = data["fileName"] | "";
                if (strlen(fn) == 0) {
                    Serial.println(F("[PATH] command=play_path missing fileName"));
                    log_w("play_path: missing fileName");
                    broadcastPathEvent("playing", "", false);
                    broadcastPathDiag();
                } else {
                    String name = stripCsv(String(fn));   // strip .csv if client sent it
                    Serial.print(F("[PATH] command=play_path file='"));
                    Serial.print(name);
                    Serial.println(F("'"));
                    bool ok = pathPlayer.play(name);
                    log_i("Path play: '%s' => %s", name.c_str(), ok ? "OK" : "FAIL");
                    broadcastPathEvent("playing", name.c_str(), ok);
                    broadcastPathDiag();
                }
                return;

            // ── stop playback ────────────────────────────────
            } else if (strcmp(cmd, "stop_path") == 0) {
                Serial.println(F("[PATH] command=stop_path"));
                pathPlayer.stop();
                broadcastPathEvent("playingStopped", "", true);
                broadcastPathDiag();
                return;

            // ── list paths ───────────────────────────────────
            } else if (strcmp(cmd, "list_paths") == 0) {
                Serial.println(F("[PATH] command=list_paths"));
                broadcastPathList();
                broadcastPathDiag();
                return;

            // ── path diagnostics ─────────────────────────────
            } else if (strcmp(cmd, "diag_paths") == 0) {
                Serial.println(F("[PATH] command=diag_paths"));
                broadcastPathDiag();
                return;

            // ── delete path ──────────────────────────────────
            } else if (strcmp(cmd, "delete_path") == 0) {
                const char* fn = data["fileName"] | "";
                bool ok = false;
                if (strlen(fn) > 0) {
                    // Build full path; strip .csv first so we never get .csv.csv
                    String path = String(PATHS_DIR) + "/" + stripCsv(String(fn)) + ".csv";
                    Serial.print(F("[PATH] command=delete_path target='"));
                    Serial.print(path);
                    Serial.println(F("'"));
                    ok = SD_MMC.remove(path.c_str());
                    log_i("Delete: '%s' => %s", path.c_str(), ok ? "OK" : "FAIL");
                } else {
                    Serial.println(F("[PATH] command=delete_path missing fileName"));
                }
                broadcastPathEvent("deleted", fn, ok);
                broadcastPathDiag();
                return;
            }

            Serial.print(F("[PATH] drive command not handled locally, cmd='"));
            Serial.print(cmd);
            Serial.println(F("' -> forwarding to Mega"));
        } else if (strcmp(topic, "drive") == 0) {
            Serial.println(F("[PATH] drive message has non-object data -> forwarding to Mega"));
        }

        // Default: forward everything else to Mega
        String line;
        serializeJson(doc, line);
        megaSerial.writeLine(line);
    });

    megaSerial.begin(115200, ESP32CAM_MEGASERIAL_RX, ESP32CAM_MEGASERIAL_TX, Serial);

    espMegaRouter.begin(&wsServer, &megaSerial);
    espMegaRouter.attachHeartbeat(&heartbeat);

    heartbeat.begin(&wsServer, &wifiAdapter, &megaSerial);
}

// ── loop ─────────────────────────────────────────────────────

void loop() {
    TRACE_LOOP("wifi",   wifiAdapter.loop());
    TRACE_LOOP("ws",     wsServer.loop());
    TRACE_LOOP("router", espMegaRouter.loop());
    TRACE_LOOP("hb",     heartbeat.loop());
    TRACE_LOOP("pathRecorder", pathRecorder.loop());
    TRACE_LOOP("pathPlayer", pathPlayer.loop());
}
