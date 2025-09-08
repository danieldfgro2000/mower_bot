import 'package:equatable/equatable.dart';

class PathModel extends Equatable{
  final String id;
  final String name;

  const PathModel({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}