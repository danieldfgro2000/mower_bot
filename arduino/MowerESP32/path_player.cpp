#include "path_player.h"
#include <mower_esp.h>

using namespace Mower;

extern MegaSerial megaSerial;

bool PathPlayer::play(const String& name) {
    if (_playing) return false;
    String path = filePath(name);
    _activeFilePath = path;
    _lastError = "";
    _file = SD_MMC.open(path.c_str(), FILE_READ);
    if (!_file) {
        _lastError = String("open failed: ") + path;
        log_e("PathPlayer: cannot open '%s'", path.c_str());
        return false;
    }

    // Log file metadata before starting
    log_i("PathPlayer: opening '%s'  size=%lu B", path.c_str(), (unsigned long)_file.size());

    // Skip header line
    String header = _file.readStringUntil('\n');
    log_i("PathPlayer: header='%s'", header.c_str());

    _startedAt     = millis();
    _sampleCount   = 0;
    _malformedCount = 0;

    if (!loadNextSample()) {
        _lastError = String("empty or header-only: ") + path;
        log_e("PathPlayer: file is empty or header-only: '%s'", path.c_str());
        _file.close();
        _activeFilePath = "";
        return false;
    }
    _playing = true;
    _lastError = "";
    log_i("PathPlayer: playback started — first sample at %lu ms, angle=%.2f",
          (unsigned long)_nextSampleMs, _nextAngle);
    return true;
}

void PathPlayer::stop() {
    if (!_playing) return;
    _playing = false;
    unsigned long durationMs = millis() - _startedAt;
    if (_file) _file.close();
    _activeFilePath = "";
    log_i("PathPlayer: stopped — samples=%lu  malformed=%lu  dur=%lus",
          (unsigned long)_sampleCount,
          (unsigned long)_malformedCount,
          (unsigned long)(durationMs / 1000));
}

void PathPlayer::loop() {
    if (!_playing) return;
    unsigned long elapsed = millis() - _startedAt;
    if (elapsed >= _nextSampleMs) {
        sendAngle(_nextAngle);
        _sampleCount++;

        // Progress log every 25 samples (~5 s)
        if (_sampleCount % 25 == 0) {
            log_i("PathPlayer: progress — samples=%lu  elapsed=%lus  angle=%.2f",
                  (unsigned long)_sampleCount,
                  (unsigned long)(elapsed / 1000),
                  _nextAngle);
        }

        if (!loadNextSample()) {
            log_i("PathPlayer: end of file after %lu samples", (unsigned long)_sampleCount);
            stop();
        }
    }
}

bool PathPlayer::loadNextSample() {
    if (!_file) return false;
    if (!_file.available()) return false;
    String line = _file.readStringUntil('\n');
    line.trim();
    if (line.length() == 0) return loadNextSample(); // skip blanks

    int comma = line.indexOf(',');
    if (comma < 0) {
        _malformedCount++;
        _lastError = String("malformed line: ") + line;
        log_w("PathPlayer: malformed line #%lu skipped: '%s'",
              (unsigned long)_malformedCount, line.c_str());
        return loadNextSample();
    }
    _nextSampleMs = line.substring(0, comma).toInt();
    _nextAngle    = line.substring(comma + 1).toFloat();
    _lastError = "";
    return true;
}

void PathPlayer::sendAngle(float angle) {
    String json = "{\"topic\":\"drive\",\"data\":{\"mega\":{\"command\":\"steer\",\"angle\":"
                  + String(angle, 2) + "}}}";
    megaSerial.writeLine(json);
}
