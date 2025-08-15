#include "network.h"
#include <WiFi.h>

const char* ssid = "MOWER_HOTSPOT";
const char* password = "2uGabriel";

namespace network {
    namespace {
        NetworkConfig g_cfg{};
        bool g_connected{false};
        constexpr uint16_t kDefaultWsPort = 8080;

        void applyStaticIpIfNeeded(const StaticIpConfig& s) {
            if(!s.enabled) return;
            if(s.dns2 == IPAddress()) {
                WiFi.config(s.local, s.gateway, s.subnet, s.dns1);
            } else {
                WiFi.config(s.local, s.gateway, s.subnet, s.dns1, s.dns2);
            }
        }
    }


  void begin(const NetworkConfig& cfg) {
      g_cfg = cfg;
      
      WiFi.mode(WIFI_STA);
      applyStaticIpIfNeeded(cfg.staticIp);
  
      if(cfg.ssid && cfg.password) {
          WiFi.begin(cfg.ssid, cfg.password);
      } else if (cfg.ssid) {
          WiFi.begin(cfg.ssid);
      }
      
  }

  void loop() {
      wl_status_t st = WiFi.status();
      bool now = (st == WL_CONNECTED);
      g_connected = now;
  }

  bool isConnected() { return g_connected; }
  IPAddress ip() { return g_connected ? WiFi.localIP() : IPAddress(); }
  
  void setWebSocketPort(uint16_t port) {
      g_cfg.ws.port = port;
  }
  uint16_t webSocketPort() {
      return g_cfg.ws.port == 0 ? kDefaultWsPort: g_cfg.ws.port;
  }
  
  const NetworkConfig& currentConfig() {
      return g_cfg;
  }
}
