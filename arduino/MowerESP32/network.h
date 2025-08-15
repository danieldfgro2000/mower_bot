#pragma once
#include <Arduino.h>
#include <IPAddress.h>

namespace network {
    struct StaticIpConfig {
        IPAddress local;
        IPAddress gateway;
        IPAddress subnet;
        IPAddress dns1;
        IPAddress dns2;
        bool enabled{ false };
    };

    struct WebSocketConfig {
        uint16_t port{0}; // 0 means not set -> will fallback to default inside impl
    };

    struct NetworkConfig {
        const char* ssid{nullptr};
        const char* password{nullptr};
        StaticIpConfig staticIp{};
        WebSocketConfig ws{};
    };

    // ---- lifecycle ----
    void begin(const NetworkConfig& cfg);
    void loop();

    // ---- status ----
    bool isConnected();
    IPAddress ip();

    // ---- config accessors ----
    void setWebSocketPort(uint16_t port);
    uint16_t webSocketPort();

    const NetworkConfig& currentConfig();
}
