import 'package:equatable/equatable.dart';

abstract class PathState extends Equatable {
  const PathState();

  @override
  List<Object?> get props => [];
}

class PathInitial extends PathState {}

class PathLoading extends PathState {}

class PathLoaded extends PathState {
  final List<String> paths;
  final String? activePath;

  const PathLoaded(this.paths, {required this.activePath});

  @override
  List<Object?> get props => [paths, activePath];
}

class PathError extends PathState {
  final String message;

  const PathError(this.message);

  @override
  List<Object?> get props => [message];
}