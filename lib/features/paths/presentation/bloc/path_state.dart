import 'package:equatable/equatable.dart';
import '../../../../core/diffable_state.dart';

abstract class PathState extends Equatable implements DiffableState {
  const PathState();

  @override
  List<Object?> get props => [];

  @override
  Map<String, dynamic> toDiffMap() => {'_type': runtimeType.toString()};
}

class PathInitial extends PathState {}

class PathLoading extends PathState {}

class PathLoaded extends PathState {
  final List<String> paths;
  final String? activePath;

  const PathLoaded(this.paths, {required this.activePath});

  @override
  List<Object?> get props => [paths, activePath];

  @override
  Map<String, dynamic> toDiffMap() => {
        ...super.toDiffMap(),
        'pathsCount': paths.length,
        // Keep summary concise to avoid noisy logs
        'pathsPreview': paths.take(3).join(','),
        'activePath': activePath,
      };
}

class PathError extends PathState {
  final String message;

  const PathError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  Map<String, dynamic> toDiffMap() => {
        ...super.toDiffMap(),
        'error': message,
      };
}