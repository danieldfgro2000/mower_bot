#include <wifi_adapter.h>

#include <ws_server.h>
#include <ws_video.h>
#include <ws_video_setup.h>
#include <mega_serial.h>

#include <router.h>
#include <heartbeat.h>

#include "secrets.h"
#include "pins_esp32cam.h"

#if !defined(BOARD_HAS_PSRAM)
#  warning "PSRAM not enabled. Enable PSRAM in Tools > PSRAM: Enabled (camera needs it)."
#endif

using namespace Mower;

static const char* reset_reason_str(esp_reset_reason_t r) {
    switch (r) {
        case ESP_RST_POWERON:   return "POWERON";
        case ESP_RST_SW:        return "SW";
        case ESP_RST_PANIC:     return "PANIC";
        case ESP_RST_BROWNOUT:  return "BROWNOUT";
        case ESP_RST_WDT:       return "WDT";
        case ESP_RST_DEEPSLEEP: return "DEEPSLEEP";
        default:                return "OTHER";
    }
}

WifiAdapter             g_net;
WsServer                g_ws;
WsVideo                 g_video(g_ws);
static CameraSetup*            g_camera = nullptr;
MegaSerial              g_mega;
Router                  g_router;
Heartbeat               g_hb;

void setup() {
    Serial.begin(115200);
    delay(200);
    esp_reset_reason_t reason = esp_reset_reason();
    Serial.printf("[BOOT] Reset reason: %d (%s)\n", reason, reset_reason_str(reason));
    Serial.flush();

    // 1) Bring up Wi-Fi (auto-reconnect handled internally)
    g_net.onConnected([](){

    });
    Serial.printf("[NET] Connecting to Wi-Fi SSID: %s\n", MowerConfig::WIFI_SSID);
    g_net.begin(MowerConfig::WIFI_SSID, MowerConfig::WIFI_PASSWORD);

    // 2) Serial bridge to Mega 2560 (pins from config/pins_esp32cam.h)
    g_mega.begin(115200, ESP32CAM_MEGASERIAL_RX, ESP32CAM_MEGASERIAL_TX);

    // 3) WebSocket server (for Flutter app)
    CameraPins pins {
            PWDN_GPIO_NUM,
            RESET_GPIO_NUM,

            XCLK_GPIO_NUM,

            SIOD_GPIO_NUM,
            SIOC_GPIO_NUM,

            Y2_GPIO_NUM,
            Y3_GPIO_NUM,
            Y4_GPIO_NUM,
            Y5_GPIO_NUM,
            Y6_GPIO_NUM,
            Y7_GPIO_NUM,
            Y8_GPIO_NUM,
            Y9_GPIO_NUM,

            VSYNC_GPIO_NUM,
            HREF_GPIO_NUM,
            PCLK_GPIO_NUM,
    };
    g_camera = new CameraSetup(pins);

    CameraOpts opts;
    opts.xclk_hz = 20000000;
    opts.frame_size = FRAMESIZE_VGA;
    opts.jpeg_quality = 12;
    opts.fb_count = 2;
    opts.prefer_psram = true;
    opts.pixformat = PIXFORMAT_JPEG;

    if (g_camera->begin(opts) != ESP_OK) {
        Serial.println("[VIDEO] Camera init failed - video disabled");
    }

    g_ws.begin(81);
    g_video.begin(8); // Default 8 FPS
    g_ws.onMessage([](const JsonDocument& doc, uint8_t clientId) {
        // Forward command payloads to Mega as line-delimited JSON
        if(doc["type"] == "command") {
            String line;
            serializeJson(doc, line);
            g_mega.writeLine(line);
        }
        if(strcmp(doc["topic"] | "", "video") == 0) {
            g_video.handleMessage(doc, clientId);
        }
    });

    g_router.begin(&g_ws, &g_mega);
    g_router.attachHeartbeat(&g_hb);

    g_hb.begin(&g_ws, &g_net);
}

void loop() {
    g_net.loop();
    g_ws.loop();
    g_video.loop();
    g_router.loop();
    g_hb.loop();

    // Keep alive pings
    static uint32_t lastPing = 0;
    if (millis() - lastPing > 15000UL) {
        lastPing = millis();
        g_ws.pingAll();
    }
}
