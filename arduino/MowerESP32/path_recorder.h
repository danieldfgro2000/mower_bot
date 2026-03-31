#pragma once
#include <Arduino.h>
#include <FS.h>
#include <SD_MMC.h>

// Records steering angle samples (timestamp ms since start, angle deg)
// into CSV file on SD card. Start creates a temp file; stop renames it.
class PathRecorder {
public:
    bool begin(const char* mountPoint = "/sdcard") {
        _mountPoint = mountPoint; return true; }

    bool isRecording() const { return _recording; }
    uint32_t sampleCount() const { return _sampleCount; }
    String activeTempFilePath() const { return _recording ? tempFilePath() : String(); }
    String lastSavedFilePath() const { return _lastSavedFilePath; }
    String lastError() const { return _lastError; }

    bool start();
    bool stop(const String& finalName);
    void loop();

private:
    bool sampleAndWrite();
    String tempFilePath() const { return String(_mountPoint) + "/paths/" + _tempName + ".csv"; }
    String finalFilePath(const String& name) const { return String(_mountPoint) + "/paths/" + name + ".csv"; }

private:
    const unsigned long SAMPLE_INTERVAL_MS = 200; // adjustable
    const size_t MAX_LINE = 64;
    const char* _mountPoint = "/sdcard";
    bool _recording = false;
    unsigned long _startedAt = 0;
    unsigned long _lastSampleAt = 0;
    String _tempName; // e.g., tmp_<millis>
    File _file;
    uint32_t _sampleCount = 0; // samples written in current session
    String _lastSavedFilePath;
    String _lastError;
};

