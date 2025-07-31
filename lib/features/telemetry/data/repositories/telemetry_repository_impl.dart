import 'package:mower_bot/features/telemetry/data/datasources/telemetry_remote_datasource.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';

abstract class TelemetryRepository {
  Stream<TelemetryEntity> streamTelemetry();
}

class TelemetryRepositoryImpl implements TelemetryRepository {
  final TelemetryRemoteDataSource remoteDataSource;

  TelemetryRepositoryImpl(this.remoteDataSource);

  @override
  Stream<TelemetryEntity> streamTelemetry() {
    return remoteDataSource.streamTelemetry();
  }
}