import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/platform/mower_reachability_service.dart';

void main() {
  test('waitUntilReachable returns true for a reachable local TCP port', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() async {
      await server.close();
    });

    final service = MowerReachabilityService();
    final reachable = await service.waitUntilReachable(
      '127.0.0.1',
      port: server.port,
      totalTimeout: const Duration(seconds: 2),
      perAttemptTimeout: const Duration(milliseconds: 500),
      retryDelay: const Duration(milliseconds: 100),
    );

    expect(reachable, isTrue);
  });
}
