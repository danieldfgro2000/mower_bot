#pragma once
#include <Arduino.h>

namespace SerialLinkConfig {
  constexpr uint32_t kBaud = 115200;

  constexpr int8_t kRxPin = 13;
  constexpr int8_t kTxPin = 15;
  constexpr uint32_t kReadTimeoutMs = 30;
  constexpr uint16_t kMaxLine = 512;
}

void serialLinkInit();
void serialLinkLoop();
