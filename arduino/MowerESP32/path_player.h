#pragma once
#include <Arduino.h>
#include <FS.h>
#include <SD_MMC.h>

// Streams a recorded path file (ms,angle) and sends steering commands to Mega
class PathPlayer {
public:
    bool begin(const char* mountPoint = "/sdcard") { _mountPoint = mountPoint; return true; }
    bool play(const String& name); // name without extension
    void stop();
    void loop();
    bool isPlaying() const { return _playing; }
private:
    bool loadNextSample();
    void sendAngle(float angle);
    String filePath(const String& name) const { return String(_mountPoint) + "/paths/" + name + ".csv"; }
private:
    const char* _mountPoint = "/sdcard";
    File _file;
    bool _playing = false;
    unsigned long _startedAt = 0;
    unsigned long _nextSampleMs = 0;
    float _nextAngle = 0.0f;
};

