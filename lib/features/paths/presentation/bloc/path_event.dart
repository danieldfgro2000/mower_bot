import 'package:equatable/equatable.dart';

abstract class PathEvent extends Equatable {
  const PathEvent();

  @override
  List<Object?> get props => [];
}

class FetchPaths extends PathEvent {}

class PlayPath extends PathEvent {
  final String name;
  const PlayPath(this.name);

  @override
  List<Object?> get props => [name];
}

class StopPath extends PathEvent {
  final String name;
  const StopPath(this.name);

  @override
  List<Object?> get props => [name];
}

class DeletePath extends PathEvent {
  final String name;
  const DeletePath(this.name);

  @override
  List<Object?> get props => [name];
}

class PathsReceived extends PathEvent {
  final List<String> paths;
  const PathsReceived(this.paths);

  @override
  List<Object?> get props => [paths];
}