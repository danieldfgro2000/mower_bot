#include "sd_recorder.h"

namespace Mower {

bool SdRecorder::begin(const char* mountPoint, bool oneBitMode) {
    _mountPoint = mountPoint;
    if (_mounted) return true;

    // SD_MMC defaults: 4-bit mode requires correct wiring; use oneBitMode if wiring is minimal.
    if (!SD_MMC.begin("/sdcard", oneBitMode)) {
        log_e("SD_MMC.begin failed");
        _mounted = false;
        return false;
    }
    uint64_t cardSize = SD_MMC.cardSize() / (1024 * 1024);
    log_i("SD mounted, size: %llu MB", cardSize);

    // Ensure base folder exists
    if (!SD_MMC.exists("/sdcard/records")) {
        if (!SD_MMC.mkdir("/sdcard/records")) {
            log_e("Failed to create /sdcard/records");
        }
    }

    _mounted = true;
    return true;
}

bool SdRecorder::startRecording(const String& fileBaseName) {
    if (!_mounted || _recording) return false;

    _sessionDir = makeRecordDir(fileBaseName);
    _frameIndex = 0;

    _recording = true;
    xTaskCreatePinnedToCore(taskTrampoline, "sd_rec", 4096, this, 1, &_task, 1);
    return true;
}

bool SdRecorder::stopRecording() {
    if (!_recording) return false;
    _recording = false;
    if (_task) {
        // Wait task to finish loop and exit
        while (eTaskGetState(_task) != eDeleted) {
            vTaskDelay(10 / portTICK_PERIOD_MS);
        }
        _task = nullptr;
    }
    return true;
}

void SdRecorder::taskTrampoline(void* param) {
    auto* self = static_cast<SdRecorder*>(param);
    self->recordLoop();
    vTaskDelete(nullptr);
}

String SdRecorder::makeRecordDir(const String& baseName) {
    String dir = String("/sdcard/records/") + baseName;
    // if exists, append index
    int suffix = 1;
    while (SD_MMC.exists(dir.c_str())) {
        dir = String("/sdcard/records/") + baseName + String("_") + String(suffix++);
    }
    if (!SD_MMC.mkdir(dir.c_str())) {
        log_e("Failed to create record dir: %s", dir.c_str());
    }
    return dir;
}

void SdRecorder::recordLoop() {
    // Capture loop
    while (_recording) {
        camera_fb_t* fb = esp_camera_fb_get();
        if (!fb) {
            log_e("Camera frame failed");
            vTaskDelay(50 / portTICK_PERIOD_MS);
            continue;
        }
        // Ensure JPEG
        uint8_t* data = fb->buf;
        size_t len = fb->len;
        if (fb->format != PIXFORMAT_JPEG) {
            uint8_t* out = nullptr; size_t outLen = 0;
            if (frame2jpg(fb, 80, &out, &outLen)) {
                data = out; len = outLen;
            } else {
                esp_camera_fb_return(fb);
                log_e("JPEG convert failed");
                vTaskDelay(10 / portTICK_PERIOD_MS);
                continue;
            }
        }

        char path[128];
        snprintf(path, sizeof(path), "%s/frame_%06lu.jpg", _sessionDir.c_str(), (unsigned long)_frameIndex++);
        File f = SD_MMC.open(path, FILE_WRITE);
        if (!f) {
            log_e("Failed to open file: %s", path);
        } else {
            f.write(data, len);
            f.close();
            log_i("Saved %s (%u bytes)", path, (unsigned)len);
        }

        if (data != fb->buf) {
            free(data);
        }
        esp_camera_fb_return(fb);

        // Target FPS ~5
        vTaskDelay(200 / portTICK_PERIOD_MS);
    }
}

} // namespace Mower

