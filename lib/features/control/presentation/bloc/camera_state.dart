import 'package:equatable/equatable.dart';

class CameraState extends Equatable {
  final String? streamUrl;

  const CameraState({this.streamUrl});

  bool get isAvailable => streamUrl != null && streamUrl!.trim().isNotEmpty;

  @override
  List<Object?> get props => [streamUrl];
}
