#include "path_manager.h"
#include <SPI.h>
#include <SdFat.h>

SdFat SD;

PathManager::PathManager(uint8_t csPin) : _csPin(csPin), state(PATH_IDLE) {}

bool PathManager::begin() {
    if(!SD.begin(_csPin, SD_SCK_MHZ(25))) {
        Serial.println("SD card initialization failed!");
        state = PATH_ERROR;
        return false; // SD card initialization failed
    }
    if(!SD.exists("/paths")) {
        SD.mkdir("/paths"); // Create a directory for paths if it doesn't exist
    }
    return true;
}

bool PathManager::startRecording(const char* filename) {
    if (state != PATH_IDLE) {
        return false;
    }
    String fullPath = String("/paths/") + filename;
    FsFile currentFile = SD.open(fullPath, O_WRITE | O_CREAT | O_APPEND);
    if (!currentFile) {
        Serial.println("Failed to open file for writing");
        state = PATH_ERROR;
        return false; // Failed to open file
    }
    state = PATH_RECORDING;
    return true;
}

void PathManager::recordData(const PathPoint& point) {
    if (state == PATH_RECORDING) {
        currentFile.print(point.x);
        currentFile.print(",");
        currentFile.print(point.y);
        currentFile.print(",");
        currentFile.print(point.heading);
        currentFile.print(",");
        currentFile.println(point.timestamp);
    }
}

void PathManager::stopRecording() {
    if (state == PATH_RECORDING && currentFile) {
        currentFile.close();
        state = PATH_IDLE;
    }
}

bool PathManager::playPath(const char* filename) {
    if (state != PATH_IDLE) {
        return false; // Cannot play path while recording or playing another path
    }
    String fullPath = String("/paths/") + filename;
    FsFile file = SD.open(fullPath, O_READ);
    if (!file) {
        return false; // Failed to open file
    }

    while (file.available()) {
        String line = file.readStringUntil('\n');
        PathPoint point;
        sscanf(line.c_str(), "%f,%f,%f,%lu", &point.x, &point.y, &point.heading, &point.timestamp);
        delay(50);
    }

    file.close();
    state = PATH_IDLE;
    return true;
}

bool PathManager::deletePath(const char* filename) {
    String fullPath = String("/paths/") + filename;
    return SD.remove(fullPath);
}

void PathManager::listPaths() {
    File dir = SD.open("/paths");
    if(!dir) return false;

    File entry;
    while ((entry = dir.openNextFile())) {
       
        entry.close();
    }
    dir.close();
    return true;
}
