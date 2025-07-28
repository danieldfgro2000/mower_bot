class PathEntity {
  final String id;
  final String name;

  PathEntity({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'PathEntity(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PathEntity &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}