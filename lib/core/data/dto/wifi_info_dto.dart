class WiFiInfoDTO {
  final bool connected;
  final String ip;

  const WiFiInfoDTO({
    required this.connected,
    required this.ip,
  });

  factory WiFiInfoDTO.fromJson(Map<String, dynamic> json) {
    return WiFiInfoDTO(
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
    return 'WiFiInfoDTO${toJson()}';
  }
}