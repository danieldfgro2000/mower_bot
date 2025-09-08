import 'package:equatable/equatable.dart';

class MowerConnectionModel  extends Equatable{
  final String name;
  final String ipAddress;
  final int port;
  final bool isConnected;

  const MowerConnectionModel({
    required this.name,
    required this.ipAddress,
    required this.port,
    this.isConnected = false,
  });

  @override
  List<Object?> get props => [name, ipAddress, port, isConnected];
}