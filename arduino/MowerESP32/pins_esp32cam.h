#pragma once

#define PWDN_GPIO_NUM     32 // Power down pin
#define RESET_GPIO_NUM    -1 // Reset pin
#define XCLK_GPIO_NUM      0 // XCLK pin

#define SIOD_GPIO_NUM     26 // SIOD pin
#define SIOC_GPIO_NUM     27 // SIOC pin

#define Y2_GPIO_NUM      5
#define Y3_GPIO_NUM      18
#define Y4_GPIO_NUM      19
#define Y5_GPIO_NUM      21
#define Y6_GPIO_NUM      36
#define Y7_GPIO_NUM      39
#define Y8_GPIO_NUM      34
#define Y9_GPIO_NUM      35

#define VSYNC_GPIO_NUM   25
#define HREF_GPIO_NUM    23
#define PCLK_GPIO_NUM    22

static constexpr int ESP32CAM_MEGASERIAL_RX = 13; // RX pin for Mega Serial
static constexpr int ESP32CAM_MEGASERIAL_TX = 12; // TX pin for Mega Serial