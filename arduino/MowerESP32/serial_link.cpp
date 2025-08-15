#include "serial_link.h"
#include "telemetry_store.h"
#include "websocket_server.h"
#include <ArduinoJson.h>

using namespace SerialLinkConfig;

namespace {
  constexpr size_t kJsonCapacity = 384;
}

static bool readLine(Stream& s, String& out) {
  if(!s.available()) return false;
  out = s.readStringUntil('\n');
  out.trim();
  if(out.length() == 0) {
    Serial.println(F("[Warn] Telemetry frame was empty."));
    return false;
  }
  if(out.length() > kMaxLine) {
    Serial.printf("[WARN] Telemetry too long: %u bytes. Dropping. \n", out.length());
    return false;
  }
  return true;
}

void serialLinkInit() {
  Serial2.begin(kBaud, SERIAL_8N1, kRxPin, kRxPin);
  Serial2.setTimeout(kReadTimeoutMs);
  Serial.printf("[INFO] Serial2 init @%lu, RX=%d, TX=%d\n",
                (unsigned long)kBaud, (int)kRxPin, (int)kTxPin);
}

void serialLinkLoop() {
  String telemetry;
  if(!readLine(Serial2, telemetry)) return;
 
  StaticJsonDocument<kJsonCapacity> doc;
  DeserializationError err = deserializeJson(doc, telemetry);
 
  if(err) {
    Serial.println("[ERR] Telemetry JSON parse failed");
    Serial.println(err.f_str());
    return;
  }

  if(!doc.containsKey("angle") || !doc.containsKey("speed") || !doc.containsKey("distance")) {
    Serial.println(F("[WARN] Telemetry missing required keys; dropping frame"));
    return;
  }
  telemetryUpdateFromMega(telemetry);
  if (connectionManager.hasClients()) {
//    connectionManager.sendMessage(telemetry);/
  }
  
  Serial.print(F("[TELEMETRY]"));
  Serial.println(telemetry);
}
