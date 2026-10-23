#pragma once

#include <Arduino.h>
#include <FS.h>
#include <SD_MMC.h>
#include "esp_camera.h"

namespace Mower {

class SdRecorder {
public:
    bool begin(const char* mountPoint = "/sdcard", bool oneBitMode = true);

    bool isMounted() const { return _mounted; }

    // Starts recording frames into a folder. If fileBaseName is provided, frames will be stored under
    // mountPoint/records/<fileBaseName>/frame_<index>.jpg
    // Returns false if already recording or not mounted.
    bool startRecording(const String& fileBaseName = "rec");

    // Stops the recording task; returns true if a recording was running.
    bool stopRecording();

    bool isRecording() const { return _recording; }

private:
    static void taskTrampoline(void* param);
    void recordLoop();

    String makeRecordDir(const String& baseName);

private:
    bool _mounted = false;
    bool _recording = false;
    TaskHandle_t _task = nullptr;
    String _mountPoint = "/sdcard";
    String _sessionDir;
    uint32_t _frameIndex = 0;
};

} // namespace Mower

