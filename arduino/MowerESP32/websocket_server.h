#ifndef WEBSOCKET_SERVER_H
#define WEBSOCKET_SERVER_H

 #include <ESPAsyncWebServer.h>
 #include "connection_manager.h"

 extern AsyncWebSocket ws;
 extern ConnectionManager connectionManager;

 void initWebSocket();

 #endif
