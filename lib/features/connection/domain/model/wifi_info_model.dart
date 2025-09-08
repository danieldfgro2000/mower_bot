
import 'package:equatable/equatable.dart';

class WiFiInfoModel extends Equatable {
  final bool connected;
  final String ip;

  const WiFiInfoModel({
    required this.connected,
    required this.ip,
  });

  @override
  List<Object?> get props => [connected, ip];
}