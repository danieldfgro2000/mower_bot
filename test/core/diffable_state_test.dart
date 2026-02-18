import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/diffable_state.dart';

class _S implements DiffableState {
  _S(this.map);
  final Map<String, dynamic> map;

  @override
  Map<String, dynamic> toDiffMap() => map;
}

void main() {
  group('StateDiffUtil', () {
    test('diff detects changes across primitives, lists, and maps and shortens long values', () {
      final prev = _S({
        'a': 1,
        'b': [1, 2],
        'c': {'x': 1},
        'long': 'x' * 100,
      });
      final next = _S({
        'a': 2,
        'b': [1, 2, 3],
        'c': {'x': 2},
        'long': 'y' * 100,
      });

      final changes = StateDiffUtil.diff(prev, next);

      expect(changes, isNotEmpty);
      expect(changes.join('\n'), contains('a: 1 -> 2'));
      expect(changes.join('\n'), contains('b:'));
      expect(changes.join('\n'), contains('c:'));
      // Ensure long value branch truncates with ellipsis.
      expect(changes.join('\n'), contains('…'));
    });

    test('diff returns empty when values are equal (deep list/map equality)', () {
      final prev = _S({
        'a': [1, {'x': 1}],
        'b': {'k': [1, 2]},
      });
      final next = _S({
        'a': [1, {'x': 1}],
        'b': {'k': [1, 2]},
      });

      expect(StateDiffUtil.diff(prev, next), isEmpty);
    });

    test('diff treats missing keys as a change (null vs value)', () {
      final prev = _S({'a': 1});
      final next = _S({'b': 2});

      final changes = StateDiffUtil.diff(prev, next);
      expect(changes.length, 2);
      expect(changes.join('\n'), contains('a: 1 -> null'));
      expect(changes.join('\n'), contains('b: null -> 2'));
    });
  });
}

