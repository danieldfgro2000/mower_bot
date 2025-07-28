class MowerConnectionEntity {
  final String name;
  final String ipAddress;
  final int port;
  final bool isConnected;

  MowerConnectionEntity({
    required this.name,
    required this.ipAddress,
    required this.port,
    this.isConnected = false,
  });

  @override
  String toString() {
    return 'MowerConnectionEntity(name: $name, ipAddress: $ipAddress, port: $port, isConnected: $isConnected)';
  }
}