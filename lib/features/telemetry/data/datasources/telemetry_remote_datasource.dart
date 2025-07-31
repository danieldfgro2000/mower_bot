import 'dart:convert';

import 'package:mower_bot/features/telemetry/data/models/telemetry_model.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class TelemetryRemoteDataSource {
  Stream<TelemetryModel> streamTelemetry();
}

class TelemetryRemoteDataSourceImpl implements TelemetryRemoteDataSource {

  TelemetryRemoteDataSourceImpl();

  @override
  Stream<TelemetryModel> streamTelemetry() async* {
    final channel = WebSocketService('ws://192.168.4.1').connect();
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
    return WebSocketChannel.connect(Uri.parse(url));
  }
}