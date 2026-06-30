import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_chat_app/feature/chat/domain/model/message.dart';
import 'package:flutter_chat_app/feature/chat/domain/model/message_status.dart';
import 'package:flutter_chat_app/feature/chat/domain/repository/chat_repository.dart';
import 'package:flutter_chat_app/feature/chat/domain/usecase/observe_messages_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

Message _msg(String id, {int ts = 0}) => Message(
      id: id,
      content: 'msg $id',
      senderId: 'user',
      clientTimestamp: ts,
      status: MessageStatus.sent,
      isOwn: false,
    );

void main() {
  late MockChatRepository repository;
  late ObserveMessagesUseCase useCase;

  setUp(() {
    repository = MockChatRepository();
    useCase = ObserveMessagesUseCase(repository);
  });

  group('ObserveMessagesUseCase', () {
    test('returns messages from repository', () async {
      final messages = [_msg('1', ts: 1), _msg('2', ts: 2)];
      when(() => repository.observeMessages())
          .thenAnswer((_) => Stream.value(messages));

      await expectLater(
        useCase(),
        emitsInOrder([messages]),
      );
    });

    test('returns empty list when repository emits empty', () async {
      when(() => repository.observeMessages())
          .thenAnswer((_) => Stream.value([]));

      await expectLater(useCase(), emitsInOrder([[]]));
    });

    test('emits multiple updates in order', () async {
      final first = [_msg('1')];
      final second = [_msg('1'), _msg('2')];

      when(() => repository.observeMessages()).thenAnswer(
        (_) => Stream.fromIterable([first, second]),
      );

      await expectLater(useCase(), emitsInOrder([first, second]));
    });

    test('messages already ordered by clientTimestamp ascending', () async {
      final ordered = [
        _msg('a', ts: 100),
        _msg('b', ts: 200),
        _msg('c', ts: 300),
      ];
      when(() => repository.observeMessages())
          .thenAnswer((_) => Stream.value(ordered));

      final result = await useCase().first;
      expect(result.map((m) => m.clientTimestamp).toList(),
          [100, 200, 300]);
    });
  });
}
