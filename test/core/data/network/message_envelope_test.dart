import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/data/network/message_envelope.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MessageEnvelope', () {
    test('topicFromString maps known topics and falls back to unknown', () {
      expect(topicFromString('drive'), MessageTopic.drive);
      expect(topicFromString('status'), MessageTopic.status);
      expect(topicFromString('telemetry'), MessageTopic.telemetry);
      expect(topicFromString('controlAck'), MessageTopic.controlAck);
      expect(topicFromString('pathList'), MessageTopic.pathList);
      expect(topicFromString('pathEvent'), MessageTopic.pathEvent);
      expect(topicFromString('heartbeat'), MessageTopic.heartbeat);
      expect(topicFromString('camera'), MessageTopic.camera);

      expect(topicFromString('nope'), MessageTopic.unknown);
      expect(topicFromString(''), MessageTopic.unknown);
    });

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

    test('fromJson tolerates missing topic and missing/invalid data', () {
      final env1 = MessageEnvelope.fromJson({});
      expect(env1.topic, MessageTopic.unknown);
      expect(env1.data, isEmpty);

      final env2 = MessageEnvelope.fromJson({
        'topic': 'status',
        'data': null,
      });
      expect(env2.topic, MessageTopic.status);
      expect(env2.data, isEmpty);
    });

    test('toJson uses enum name and supports round-trip', () {
      final env = MessageEnvelope(topic: MessageTopic.drive, data: {'speed': 10});
      expect(env.toJson(), {
        'topic': 'drive',
        'data': {'speed': 10},
      });

      final back = MessageEnvelope.fromJson(env.toJson());
      expect(back.topic, MessageTopic.drive);
      expect(back.data, {'speed': 10});
    });
  });
}
