#pragma once
#include <Arduino.h>

namespace ws {
    void begin(uint16_t port);
    void loop();
    
    void restart(uint16_t port);

    // Introspection
    bool isRunning();
    uint16_t currentPort();

    // --- Client presence / count ----
    bool hasClients();
    uint8_t connectedCount();
}

struct ConnectionManagerLegacyShim {
  bool hasClients() const;
};

extern ConnectionManagerLegacyShim connectionManager;
