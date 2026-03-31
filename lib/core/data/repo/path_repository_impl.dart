
import 'package:mower_bot/features/paths/domain/model/path_model.dart';

abstract class PathRepository {
  Future<List<String>> fetchPaths();
  Future<void> startRecord();
  Future<void> stopRecord(String name);
  Future<void> playPath(String name);
  Future<void> stopPath(String name);
  Future<void> deletePath(String name);
}

class MockPathRepository implements PathRepository {
  final List<PathModel> _mockPaths = [
    PathModel(id: "01", name: "Front Yard"),
    PathModel(id: "02", name: "Back Yard"),
    PathModel(id: "03", name: "Side Walk"),
  ];

  @override
  Future<List<String>> fetchPaths() async {
    await Future.delayed(Duration(seconds: 1));
    return _mockPaths.map((path) => path.name).toList();
  }

  @override
  Future<void> startRecord() async {
    await Future.delayed(Duration(milliseconds: 200));
    print("Mock: startRecord");
  }

  @override
  Future<void> stopRecord(String name) async {
    await Future.delayed(Duration(milliseconds: 200));
    print("Mock: stopRecord -> $name");
    _mockPaths.add(PathModel(id: name, name: name));
  }

  @override
  Future<void> playPath(String name) async {
    await Future.delayed(Duration(seconds: 1));
    print("Playing path: $name");
  }

  @override
  Future<void> stopPath(String name) {
    return Future.delayed(Duration(seconds: 1), () {
      print("Stopping path: $name");
    });
  }

  @override
  Future<void> deletePath(String name) async {
    await Future.delayed(Duration(seconds: 1));
    print("Deleting path: $name");
    _mockPaths.removeWhere((path) => path.name == name);
  }
}