#pragma once
#include <Arduino.h>

namespace netcfg {
    // Device identity
    static constexpr const char* kHostname = "mower-esp32";
    static constexpr const char* kApSsidPrefix = "MOWER-AP-";
    static constexpr const char* kApPassword = "mowerbot-setup";

    // Timings
    static constexpr uint32_t kConnectTimeoutMs = 15000;
    static constexpr uint32_t kRetryBackoffStartMs = 2000;
    static constexpr uint32_t kRetryBackoffMaxMs = 15000;
    static constexpr uint32_t kLinkCheckMs = 2500;

    // AP Fallback
    static constexpr bool kEnableApFallback = true;

    // Power save (hotspots often dislike modem sleep)
    static constexpr bool kDisableWifiSleep = true;

    // NVS keys
    static constexpr const char* kPrefsNamespace = "net";
    static constexpr const char* kKeySsid = "ssid";
    static constexpr const char* kKeyPass = "pass";
}