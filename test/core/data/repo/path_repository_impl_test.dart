import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/repo/path_repository_impl.dart';

void main() {
  group('MockPathRepository', () {
    test('fetchPaths returns the initial mock path names', () async {
      final repo = MockPathRepository();

      final names = await repo.fetchPaths();

      expect(names, containsAll(<String>['Front Yard', 'Back Yard', 'Side Walk']));
      expect(names.length, 3);
    });

    test('deletePath removes an item so it no longer appears in fetchPaths', () async {
      final repo = MockPathRepository();

      await repo.deletePath('Back Yard');
      final names = await repo.fetchPaths();

      expect(names, isNot(contains('Back Yard')));
      expect(names.length, 2);
    });

    test('playPath and stopPath complete without throwing', () async {
      final repo = MockPathRepository();

      await repo.playPath('Front Yard');
      await repo.stopPath('Front Yard');

      // No expectations beyond no-throw; this covers the async delay branches.
      expect(true, isTrue);
    });
  });
}

