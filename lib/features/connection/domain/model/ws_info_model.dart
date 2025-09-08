
import 'package:equatable/equatable.dart';

class WsInfoModel extends Equatable{
  final int clients;

  const WsInfoModel({
    required this.clients,
  });

  @override
  List<Object?> get props => [clients];
}