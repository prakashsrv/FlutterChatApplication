import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_chat_app/feature/chat/data/stream/fake_chat_stream.dart';
import 'package:flutter_chat_app/feature/chat/domain/model/message_status.dart';

void main() {
  late FakeChatStream stream;

  setUp(() => stream = FakeChatStream());
  tearDown(() => stream.dispose());

  group('FakeChatStream', () {
    test('emit delivers a single message', () async {
      final future = stream.messages.first;
      stream.emit('Hello');
      final msg = await future;

      expect(msg.content, 'Hello');
      expect(msg.isOwn, isFalse);
      expect(msg.status, MessageStatus.sent);
      expect(msg.id, isNotEmpty);
    });

    test('emit delivers messages in order', () async {
      final received = <String>[];
      final sub = stream.messages.listen((m) => received.add(m.content));

      stream.emit('First');
      stream.emit('Second');
      stream.emit('Third');

      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub.cancel();

      expect(received, ['First', 'Second', 'Third']);
    });

    test('emitBurst delivers 20 messages in order', () async {
      final received = <String>[];
      final sub = stream.messages.listen((m) => received.add(m.content));

      await stream.emitBurst(20);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await sub.cancel();

      expect(received.length, 20);
      // Check the content pattern
      for (var i = 0; i < 20; i++) {
        expect(received[i], 'Burst message ${i + 1}');
      }
    });

    test('typing indicator defaults to no emission before setTyping', () async {
      final received = <bool>[];
      final sub = stream.isTyping.listen(received.add);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub.cancel();
      // Hot stream — no value emitted until setTyping is called
      expect(received, isEmpty);
    });

    test('setTyping toggles the indicator', () async {
      final received = <bool>[];
      final sub = stream.isTyping.listen(received.add);

      stream.setTyping(isTyping: true);
      stream.setTyping(isTyping: false);
      stream.setTyping(isTyping: true);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub.cancel();

      expect(received, [true, false, true]);
    });

    test('multiple listeners each receive every message', () async {
      final a = <String>[];
      final b = <String>[];

      final subA = stream.messages.listen((m) => a.add(m.content));
      final subB = stream.messages.listen((m) => b.add(m.content));

      stream.emit('shared');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await subA.cancel();
      await subB.cancel();

      expect(a, ['shared']);
      expect(b, ['shared']);
    });
  });
}
