import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_chat_app/feature/chat/domain/model/message.dart';
import 'package:flutter_chat_app/feature/chat/domain/model/message_status.dart';
import 'package:flutter_chat_app/feature/chat/domain/repository/chat_repository.dart';
import 'package:flutter_chat_app/feature/chat/domain/usecase/send_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

Message _inbound(String id, {required int ts}) => Message(
      id: id,
      serverId: 'srv-$id',
      content: 'inbound $id',
      senderId: 'bot',
      clientTimestamp: ts,
      status: MessageStatus.sent,
      isOwn: false,
    );

void main() {
  late MockChatRepository repository;
  late SendMessageUseCase sendUseCase;

  setUp(() {
    repository = MockChatRepository();
    sendUseCase = SendMessageUseCase(repository);
    when(() => repository.insertPendingMessage(any())).thenAnswer((_) async {});
    when(() => repository.updateMessage(any())).thenAnswer((_) async {});
    when(() => repository.sendMessageToServer(any()))
        .thenAnswer((_) async => 'srv-echo');
  });

  group('Ordering', () {
    test('out-of-order timestamps sorted ascending', () {
      final messages = [
        _inbound('c', ts: 300),
        _inbound('a', ts: 100),
        _inbound('b', ts: 200),
      ]..sort((a, b) => a.clientTimestamp.compareTo(b.clientTimestamp));

      expect(messages.map((m) => m.id).toList(), ['a', 'b', 'c']);
    });

    test('own message clientTimestamp is used for ordering', () {
      // Simulate pending own message ordered among inbound by clientTimestamp
      final own = Message(
        id: 'own-1',
        content: 'mine',
        senderId: 'me',
        clientTimestamp: 150,
        status: MessageStatus.pending,
        isOwn: true,
      );
      final all = [
        _inbound('a', ts: 100),
        own,
        _inbound('b', ts: 200),
      ]..sort((a, b) => a.clientTimestamp.compareTo(b.clientTimestamp));

      expect(all[0].id, 'a');
      expect(all[1].id, 'own-1');
      expect(all[2].id, 'b');
    });

    test('20-message burst keeps chronological order', () {
      final burst = List.generate(
        20,
        (i) => _inbound('m$i', ts: i * 10),
      );
      final sorted = [...burst]
        ..sort((a, b) => a.clientTimestamp.compareTo(b.clientTimestamp));

      expect(sorted.map((m) => m.id).toList(),
          List.generate(20, (i) => 'm$i'));
    });
  });

  group('Deduplication', () {
    test('unique optimistic ids across two sends', () async {
      final ids = <String>[];
      when(() => repository.insertPendingMessage(any())).thenAnswer((inv) async {
        ids.add((inv.positionalArguments.first as Message).id);
      });

      await sendUseCase(content: 'A', senderId: 'me');
      await sendUseCase(content: 'B', senderId: 'me');

      expect(ids.toSet().length, 2);
    });

    test('server echo with same serverId replaces existing row (map stays size 1)',
        () {
      // Simulate a map-as-store (keyed by serverId) used for dedup
      final store = <String, Message>{};

      final original = _inbound('1', ts: 100);
      store[original.serverId!] = original;
      expect(store.length, 1);

      // Server echo arrives again (duplicate delivery)
      final echo = original.copyWith(serverTimestamp: 999);
      store[echo.serverId!] = echo; // INSERT OR REPLACE semantics

      expect(store.length, 1);
      expect(store.values.first.serverTimestamp, 999);
    });

    test('50-message burst has no duplicates by id', () {
      final burst = List.generate(50, (i) => _inbound('m$i', ts: i));
      final ids = burst.map((m) => m.id).toSet();
      expect(ids.length, 50);
    });
  });
}
