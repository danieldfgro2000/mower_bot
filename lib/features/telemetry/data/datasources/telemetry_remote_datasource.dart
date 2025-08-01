import 'dart:convert';

import 'package:mower_bot/features/telemetry/data/models/telemetry_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class TelemetryRemoteDataSource {
  Stream<TelemetryModel> streamTelemetry(String wsUrl);
}

class TelemetryRemoteDataSourceImpl implements TelemetryRemoteDataSource {

  TelemetryRemoteDataSourceImpl();

  @override
  Stream<TelemetryModel> streamTelemetry(String wsUrl) async* {
    final channel = WebSocketService(wsUrl).connect();
    await for (final message in channel.stream) {
      final json = jsonDecode(message);
      yield TelemetryModel.fromJson(json);
    }
  }
}

class WebSocketService {
  final String url;

  WebSocketService(this.url);

  WebSocketChannel connect() {
    print('Connecting to WebSocket: $url');
    return WebSocketChannel.connect(Uri.parse(url));
  }
}