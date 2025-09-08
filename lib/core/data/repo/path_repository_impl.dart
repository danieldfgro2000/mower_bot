
import 'package:mower_bot/features/paths/domain/model/path_model.dart';

abstract class PathRepository {
  Future<List<String>> fetchPaths();
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
    // Simulate a network delay
    await Future.delayed(Duration(seconds: 1));
    return _mockPaths.map((path) => path.name).toList();
  }
  
  @override
  Future<void> playPath(String name) async {
    // Simulate a network delay
    await Future.delayed(Duration(seconds: 1));
    // Here you would normally send a command to the mower bot to play the path
    print("Playing path: $name");
  }

  @override
  Future<void> stopPath(String name) {
    // Simulate a network delay
    return Future.delayed(Duration(seconds: 1), () {
      // Here you would normally send a command to the mower bot to stop the path
      print("Stopping path: $name");
    });
  }

  @override
  Future<void> deletePath(String name) async {
    // Simulate a network delay
    await Future.delayed(Duration(seconds: 1));
    // Here you would normally send a command to the mower bot to delete the path
    print("Deleting path: $name");
    _mockPaths.removeWhere((path) => path.name == name);
  }
}