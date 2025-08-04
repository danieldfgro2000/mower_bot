#ifndef CONNECTION_MANAGER_H
#define CONNECTION_MANAGER_H

#include <Arduino.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

enum class ClientConnectionState {
  Disconnected,
  Connected
};

class ConnectionManager {
public:
  explicit ConnectionManager(AsyncWebSocket& socket);

  void begin();

  void onClientConnected(AsyncWebSocketClient *client);
  void onClientDisconnected(AsyncWebSocketClient *client);

  bool sendMessage(const String& msg);
  bool isConnected() const;

  ClientConnectionState state() const;

private:
  AsyncWebSocket& _socket;
  ClientConnectionState _state;
  AsyncWebSocketClient *_client;
};

#endif
