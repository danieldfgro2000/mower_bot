class WsInfoDTO {
  final int clients;

  const WsInfoDTO({
    required this.clients,
  });

  factory WsInfoDTO.fromJson(Map<String, dynamic> json) {
    return WsInfoDTO(
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
    return 'WsInfoDTO${toJson()}';
  }
}