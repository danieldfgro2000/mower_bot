import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/network/websocket_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('handleBinary', () {
    test('returns the same bytes and updates stats', () {
      final msg = Uint8List.fromList([1, 2, 3, 4]);

      final beforeRx = stats.rxThisSec;
      final out = handleBinary(msg);

      expect(out, same(msg));
      expect(stats.rxThisSec, beforeRx + 1);
      expect(stats.lastArrivalMs, isNotNull);
    });

    test('tolerates multiple calls (arrival delta branch)', () {
      final msg1 = Uint8List.fromList([9]);
      final msg2 = Uint8List.fromList([10]);

      handleBinary(msg1);
      final out2 = handleBinary(msg2);

      expect(out2, same(msg2));
      expect(stats.lastArrivalMs, isNotNull);
    });
  });
}

