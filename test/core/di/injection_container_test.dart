import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mower_bot/core/di/injection_container.dart' as di;
import 'package:mower_bot/core/data/repo/path_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('initDependencies', () {
    tearDown(() async {
      await GetIt.I.reset();
    });

    test('registers dev dependencies (includes MockPathRepository)', () async {
      await di.initDependencies(env: di.AppEnvironment.dev);

      final repo = GetIt.I<PathRepository>();
      expect(repo, isA<MockPathRepository>());
    });

    test('registers prod dependencies (includes PathRepositoryRemote)', () async {
      await di.initDependencies(env: di.AppEnvironment.prod);

      final repo = GetIt.I<PathRepository>();
      // Type name check avoids importing the concrete class just for test.
      expect(repo.runtimeType.toString(), contains('PathRepositoryRemote'));
    });
  });
}

