class MowerStatusEntity {
  final int uptimeMs;
  final WiFiInfo wifi;
  final WsInfo ws;
  final TelemetryInfo telemetry;

  const MowerStatusEntity({
    required this.uptimeMs,
    required this.wifi,
    required this.ws,
    required this.telemetry,
  });

  factory MowerStatusEntity.fromJson(Map<String, dynamic> json) {
    return MowerStatusEntity(
      uptimeMs: json['uptimeMs'] ?? 0,
      wifi: WiFiInfo.fromJson(json['wifi'] ?? const {}),
      ws: WsInfo.fromJson(json['ws'] ?? const {}),
      telemetry: TelemetryInfo.fromJson(json['telemetry'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uptimeMs': uptimeMs,
      'wifi': wifi.toJson(),
      'ws': ws.toJson(),
      'telemetry': telemetry.toJson(),
    };
  }

  @override
  String toString() {
    return 'MowerStatusEntity${toJson()}';
  }
}

class MowerStatusMapper {
  static MowerStatusEntity fromData(Map<String, dynamic> data) {
    return MowerStatusEntity.fromJson(data);
  }
}

class WiFiInfo {
  final bool connected;
  final String ip;

  const WiFiInfo({
    required this.connected,
    required this.ip,
  });

  factory WiFiInfo.fromJson(Map<String, dynamic> json) {
    return WiFiInfo(
      connected: json['connected'] ?? false,
      ip: json['ip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'connected': connected,
      'ip': ip,
    };
  }

  @override
  String toString() {
    return 'WiFiInfo${toJson()}';
  }
}

class WsInfo {
  final int clients;

  const WsInfo({
    required this.clients,
  });

  factory WsInfo.fromJson(Map<String, dynamic> json) {
    return WsInfo(
      clients: json['clients'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clients': clients,
    };
  }

  @override
  String toString() {
    return 'WsInfo${toJson()}';
  }
}

class TelemetryInfo {
  final bool received;
  final int? ageMs;
  final bool ok;

  const TelemetryInfo({
    required this.received,
    this.ageMs,
    required this.ok,
  });

  factory TelemetryInfo.fromJson(Map<String, dynamic> json) {
    return TelemetryInfo(
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
    return 'TelemetryInfo${toJson()}';
  }
}
