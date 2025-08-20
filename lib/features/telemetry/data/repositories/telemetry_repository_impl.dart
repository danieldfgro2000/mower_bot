import 'package:mower_bot/features/telemetry/data/datasources/telemetry_remote_datasource.dart';
import 'package:mower_bot/features/telemetry/domain/entities/telemetry_entity.dart';
import 'package:mower_bot/features/telemetry/domain/repository/telemetry_repository.dart';

class TelemetryRepositoryImpl implements TelemetryRepository {
  final TelemetryRemoteDataSource remoteDataSource;

  TelemetryRepositoryImpl(this.remoteDataSource);

  @override
  Stream<TelemetryEntity> getTelemetryStream(Uri wsUrl) {
    return remoteDataSource.observeTelemetry();
  }
}