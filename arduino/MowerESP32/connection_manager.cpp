#include "connection_manager.h"

ConnectionManager::ConnectionManager(AsyncWebSocket& socket)
  : _socket(socket), _state(ClientConnectionState::Disconnected), _client(nullptr) {}

void ConnectionManager::begin() {}

void ConnectionManager::onClientConnected(AsyncWebSocketClient *client) {
  _client = client;
  _state = ClientConnectionState::Connected;
}

void ConnectionManager::onClientDisconnected(AsyncWebSocketClient *client) {
  if(_client == client) {
    _client == nullptr;
    _state = ClientConnectionState::Disconnected;
  }
}

bool ConnectionManager::sendMessage(const String& msg) {
  if(_state == ClientConnectionState::Connected && _client) {
    _client->text(msg);
    return true;
  }
  return false;
}

bool ConnectionManager::isConnected() const {
  return _state == ClientConnectionState::Connected;
}

ClientConnectionState ConnectionManager::state() const {
  return _state;
}
