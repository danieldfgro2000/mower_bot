import 'dart:convert';

import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class TelemetryRemoteDataSource {
  Stream<TelemetryModel> streamTelemetry();
}

class TelemetryRemoteDataSourceImpl implements TelemetryRemoteDataSource {
  final WebSocketChannel channel;

  TelemetryRemoteDataSourceImpl(this.channel);

  @override
  Stream<TelemetryModel> streamTelemetry() async* {
    await for (final message in channel.stream) {
      final json = jsonDecode(message);
      yield TelemetryModel.fromJson(json);
    }
  }
}