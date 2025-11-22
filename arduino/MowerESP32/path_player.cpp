#include "path_player.h"
#include <mower_esp.h> // for log_i/log_e and MegaSerial definition

extern MegaSerial megaSerial; // defined in main sketch

bool PathPlayer::play(const String& name) {
    if (_playing) return false;
    String path = filePath(name);
    _file = SD_MMC.open(path.c_str(), FILE_READ);
    if (!_file) {
        log_e("PathPlayer: cannot open %s", path.c_str());
        return false;
    }
    // Skip header line
    String header = _file.readStringUntil('\n');
    (void)header;
    _startedAt = millis();
    if (!loadNextSample()) {
        log_e("PathPlayer: empty path file %s", path.c_str());
        _file.close();
        return false;
    }
    _playing = true;
    log_i("PathPlayer: playing %s", path.c_str());
    return true;
}

void PathPlayer::stop() {
    if (!_playing) return;
    _playing = false;
    if (_file) _file.close();
    log_i("PathPlayer: stopped");
}

void PathPlayer::loop() {
    if (!_playing) return;
    unsigned long elapsed = millis() - _startedAt;
    if (elapsed >= _nextSampleMs) {
        sendAngle(_nextAngle);
        if (!loadNextSample()) {
            stop(); // end of file
        }
    }
}

bool PathPlayer::loadNextSample() {
    if (!_file) return false;
    if (!_file.available()) return false;
    String line = _file.readStringUntil('\n');
    line.trim();
    if (line.length() == 0) return loadNextSample(); // skip blanks
    // Format: ms,angle
    int comma = line.indexOf(',');
    if (comma < 0) return loadNextSample(); // malformed skip
    String msStr = line.substring(0, comma);
    String angStr = line.substring(comma + 1);
    _nextSampleMs = msStr.toInt();
    _nextAngle = angStr.toFloat();
    return true;
}

void PathPlayer::sendAngle(float angle) {
    String json = "{\"topic\":\"drive\",\"data\":{\"mega\":{\"command\":\"steer\",\"angle\":" + String(angle, 2) + "}}}";
    megaSerial.writeLine(json);
}
