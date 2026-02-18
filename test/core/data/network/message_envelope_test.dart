import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/network/message_envelope.dart';

void main() {
  group('MessageEnvelope', () {
    test('fromJson maps known topic strings', () {
      final env = MessageEnvelope.fromJson({
        'topic': 'telemetry',
        'data': {'a': 1},
      });

      expect(env.topic, MessageTopic.telemetry);
      expect(env.data, {'a': 1});
    });

    test('fromJson maps unknown topic strings to MessageTopic.unknown', () {
      final env = MessageEnvelope.fromJson({
        'topic': 'nope',
        'data': {'x': true},
      });

      expect(env.topic, MessageTopic.unknown);
      expect(env.data, {'x': true});
    });

    test('fromJson tolerates missing / invalid data', () {
      final env = MessageEnvelope.fromJson({
        'topic': 'status',
        'data': null,
      });

      expect(env.topic, MessageTopic.status);
      expect(env.data, isEmpty);
    });

    test('toJson uses enum name', () {
      final env = MessageEnvelope(topic: MessageTopic.drive, data: {'speed': 10});
      expect(env.toJson(), {
        'topic': 'drive',
        'data': {'speed': 10},
      });
    });
  });
}

