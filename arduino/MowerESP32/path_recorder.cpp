#include "path_recorder.h"
#include "telemetry_store.h"
#include <ArduinoJson.h>
#include <mower_esp.h>

bool PathRecorder::start() {
    if (_recording) return false;
    _lastError = "";
    _lastSavedFilePath = "";
    // Ensure /sdcard/paths exists
    String dir = String(_mountPoint) + "/paths";
    if (!SD_MMC.exists(dir.c_str())) {
        if (!SD_MMC.mkdir(dir.c_str())) {
            _lastError = "mkdir paths failed";
            log_e("PathRecorder: cannot create paths dir");
            return false;
        }
    }
    _tempName = String("tmp_") + String((unsigned long)millis());
    String path = tempFilePath();
    _file = SD_MMC.open(path.c_str(), FILE_WRITE);
    if (!_file) {
        _lastError = String("open temp failed: ") + path;
        log_e("PathRecorder: cannot open temp file %s", path.c_str());
        return false;
    }
    _file.println(F("ms,angle"));
    _file.flush();
    _startedAt    = millis();
    _lastSampleAt = 0;
    _sampleCount  = 0;
    _recording    = true;
    log_i("PathRecorder: started → %s  (SD free: %llu MB)",
          path.c_str(),
          (unsigned long long)(SD_MMC.totalBytes() - SD_MMC.usedBytes()) / (1024 * 1024));
    return true;
}

bool PathRecorder::stop(const String& finalName) {
    if (!_recording) return false;
    _recording = false;

    unsigned long durationMs = millis() - _startedAt;
    uint32_t fileSize = _file ? (uint32_t)_file.size() : 0;
    if (_file) { _file.flush(); _file.close(); }

    String src = tempFilePath();

    // Empty name = discard: delete the temp file
    if (finalName.length() == 0) {
        bool ok = SD_MMC.remove(src.c_str());
        _lastError = ok ? "" : String("discard delete failed: ") + src;
        log_i("PathRecorder: DISCARDED %s — samples=%lu dur=%lus (%s)",
              src.c_str(), (unsigned long)_sampleCount,
              (unsigned long)(durationMs / 1000), ok ? "deleted" : "delete FAILED");
        return ok;
    }

    // Rename temp file to final name (ensure unique if already exists)
    String target = finalFilePath(finalName);
    int suffix = 1;
    while (SD_MMC.exists(target.c_str())) {
        target = finalFilePath(finalName + String("_") + String(suffix++));
    }
    if (!SD_MMC.rename(src.c_str(), target.c_str())) {
        _lastError = String("rename failed: ") + src + " -> " + target;
        log_e("PathRecorder: rename FAILED %s -> %s", src.c_str(), target.c_str());
        return false;
    }
    _lastSavedFilePath = target;
    _lastError = "";
    log_i("PathRecorder: SAVED → %s  samples=%lu  dur=%lus  size=%lu bytes",
          target.c_str(),
          (unsigned long)_sampleCount,
          (unsigned long)(durationMs / 1000),
          (unsigned long)fileSize);
    return true;
}

void PathRecorder::loop() {
    if (!_recording) return;
    unsigned long now = millis();
    if (now - _lastSampleAt >= SAMPLE_INTERVAL_MS) {
        sampleAndWrite();
        _lastSampleAt = now;
    }
}

bool PathRecorder::sampleAndWrite() {
    if (!_file) return false;
    // Obtain telemetry JSON string
    String telemetryJson = telemetryGet();
    if (telemetryJson.length() == 0) {
        _lastError = "telemetry empty";
        log_w("PathRecorder: no telemetry — sample skipped (count=%lu)", (unsigned long)_sampleCount);
        return false;
    }

    StaticJsonDocument<256> doc;
    DeserializationError err = deserializeJson(doc, telemetryJson);
    if (err) {
        _lastError = String("telemetry parse error: ") + err.c_str();
        log_w("PathRecorder: telemetry JSON parse error: %s", err.c_str());
        return false;
    }

    float angle = doc["data"]["stepperAngle"].as<float>();
    unsigned long relMs = millis() - _startedAt;

    char line[64];
    snprintf(line, sizeof(line), "%lu,%.2f", relMs, angle);
    _file.println(line);

    _sampleCount++;
    _lastError = "";

    // Flush every 5 samples (~1 s) to reduce wear
    if (_sampleCount % 5 == 0) _file.flush();

    // Progress log every 25 samples (~5 s)
    if (_sampleCount % 25 == 0) {
        log_i("PathRecorder: progress — samples=%lu  elapsed=%lus  angle=%.2f  file=%lu B",
              (unsigned long)_sampleCount,
              (unsigned long)(relMs / 1000),
              angle,
              (unsigned long)_file.size());
    }
    return true;
}
