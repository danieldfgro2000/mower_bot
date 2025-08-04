#ifndef PATH_MANAGER_H
#define PATH_MANAGER_H

#include <SdFat.h>

enum PathState {
    PATH_IDLE,
    PATH_RECORDING,
    PATH_PLAYING,
    PATH_ERROR
};

struct PathPoint {
  float x;
  float y;
  float heading;
  unsigned long timestamp;
};

class PathManager {
public:
    PathManager(uint8_t csPin);
    bool begin();
    bool startRecording(const char* filename);
    void recordData(const PathPoint& point);
    void stopRecording();
    bool playPath(const char* filename);
    bool deletePath(const char* filename);
    void listPaths();

    PathState getState() { return state;}
    
private:
    uint8_t _csPin;
    PathState state;
    FsFile currentFile;
};

#endif
