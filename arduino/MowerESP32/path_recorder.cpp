#include "path_recorder.h"
#include "telemetry_store.h"
#include <ArduinoJson.h>
#include <mower_esp.h>

bool PathRecorder::start() {
    if (_recording) return false;
    // Ensure /sdcard/paths exists
    String dir = String(_mountPoint) + "/paths";
    if (!SD_MMC.exists(dir.c_str())) {
        if (!SD_MMC.mkdir(dir.c_str())) {
            log_e("PathRecorder: cannot create paths dir");
            return false;
        }
    }
    _tempName = String("tmp_") + String((unsigned long)millis());
    String path = tempFilePath();
    _file = SD_MMC.open(path.c_str(), FILE_WRITE);
    if (!_file) {
        log_e("PathRecorder: cannot open temp file %s", path.c_str());
        return false;
    }
    _file.println(F("ms,angle"));
    _file.flush();
    _startedAt = millis();
    _lastSampleAt = 0;
    _recording = true;
    log_i("PathRecorder: started (%s)", path.c_str());
    return true;
}

bool PathRecorder::stop(const String& finalName) {
    if (!_recording) return false;
    _recording = false;
    if (_file) { _file.flush(); _file.close(); }

    // Rename temp file to final name (ensure unique if exists)
    String target = finalFilePath(finalName);
    int suffix = 1;
    while (SD_MMC.exists(target.c_str())) {
        target = finalFilePath(finalName + String("_") + String(suffix++));
    }
    String src = tempFilePath();
    if (!SD_MMC.rename(src.c_str(), target.c_str())) {
        log_e("PathRecorder: rename failed %s -> %s", src.c_str(), target.c_str());
        return false;
    }
    log_i("PathRecorder: stopped, saved as %s", target.c_str());
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
    if (telemetryJson.length() == 0) return false;

    StaticJsonDocument<256> doc; // keep small
    DeserializationError err = deserializeJson(doc, telemetryJson);
    if (err) return false; // JSON parse failed

    float angle = doc["data"]["stepperAngle"].as<float>();
    unsigned long relMs = millis() - _startedAt;

    char line[64];
    snprintf(line, sizeof(line), "%lu,%.2f", relMs, angle);
    _file.println(line);
    // Avoid excessive flush to reduce wear; flush every ~second
    static unsigned count = 0; count++;
    if (count % 5 == 0) _file.flush();
    return true;
}
