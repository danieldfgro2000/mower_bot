enum MessageTopic {
  status,
  telemetry,
  controlAck,
  pathList,
  pathEvent,
  heartbeat,
  unknown,
}

MessageTopic topicFromString(String topic) {
  switch (topic) {
    case 'status':
      return MessageTopic.status;
    case 'telemetry':
      return MessageTopic.telemetry;
    case 'controlAck':
      return MessageTopic.controlAck;
    case 'pathList':
      return MessageTopic.pathList;
    case 'pathEvent':
      return MessageTopic.pathEvent;
    case 'heartbeat':
      return MessageTopic.heartbeat;
    default:
      return MessageTopic.unknown;
  }
}

class MessageEnvelope {
  final MessageTopic topic;
  final Map<String, dynamic> data;

  MessageEnvelope({
    required this.topic,
    required this.data,
  });

  factory MessageEnvelope.fromJson(Map<String, dynamic> json) {
    return MessageEnvelope(
      topic: topicFromString(json['topic'] as String),
      data: (json['data'] as Map?)?.cast<String, dynamic>() ?? const {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic.name,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'MessageEnvelope{topic: $topic, data: $data}';
  }
}