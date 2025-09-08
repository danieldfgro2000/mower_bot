import 'package:mower_bot/features/connection/domain/model/telemetry_age_model.dart';

class TelemetryAgeDTO {
  final bool received;
  final int? ageMs;
  final bool ok;

  const TelemetryAgeDTO({
    required this.received,
    this.ageMs,
    required this.ok,
  });

  factory TelemetryAgeDTO.fromJson(Map<String, dynamic> json) {
    return TelemetryAgeDTO(
      received: json['received'] ?? false,
      ageMs: json['ageMs'],
      ok: json['ok'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'received': received,
      'ageMs': ageMs,
      'ok': ok,
    };
  }

  @override
  String toString() {
    return 'TelemetryAgeDTO${toJson()}';
  }
}

extension TelemetryAgeDTOx on TelemetryAgeDTO {
   TelemetryAgeModel toDomain() => TelemetryAgeModel(
        received: received,
        ageMs: ageMs,
        ok: ok,
   );
}
