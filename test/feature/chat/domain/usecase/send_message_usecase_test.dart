import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_chat_app/feature/chat/domain/model/message.dart';
import 'package:flutter_chat_app/feature/chat/domain/model/message_status.dart';
import 'package:flutter_chat_app/feature/chat/domain/repository/chat_repository.dart';
import 'package:flutter_chat_app/feature/chat/domain/usecase/send_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository repository;
  late SendMessageUseCase useCase;

  setUp(() {
    repository = MockChatRepository();
    useCase = SendMessageUseCase(repository);

    // Default stubs
    when(() => repository.insertPendingMessage(any())).thenAnswer((_) async {});
    when(() => repository.updateMessage(any())).thenAnswer((_) async {});
  });

  group('SendMessageUseCase', () {
    test('optimistic ordering: insertPending called before sendToServer', () async {
      final callOrder = <String>[];

      when(() => repository.insertPendingMessage(any())).thenAnswer((_) async {
        callOrder.add('insert');
      });
      when(() => repository.sendMessageToServer(any())).thenAnswer((_) async {
        callOrder.add('send');
        return 'srv-1';
      });

      await useCase(content: 'Hello', senderId: 'me');

      expect(callOrder, ['insert', 'send']);
    });

    test('builds a pending message with correct content, senderId, isOwn, non-zero timestamp',
        () async {
      Message? captured;

      when(() => repository.insertPendingMessage(any())).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as Message;
      });
      when(() => repository.sendMessageToServer(any()))
          .thenAnswer((_) async => 'srv-2');

      await useCase(content: 'Test message', senderId: 'user-42');

      expect(captured, isNotNull);
      expect(captured!.content, 'Test message');
      expect(captured!.senderId, 'user-42');
      expect(captured!.isOwn, isTrue);
      expect(captured!.status, MessageStatus.pending);
      expect(captured!.clientTimestamp, isNonZero);
      expect(captured!.id, isNotEmpty);
    });

    test('success path: updateMessage called with sent status and serverId on same id',
        () async {
      const serverId = 'srv-abc';
      Message? pendingMsg;
      Message? updatedMsg;

      when(() => repository.insertPendingMessage(any())).thenAnswer((inv) async {
        pendingMsg = inv.positionalArguments.first as Message;
      });
      when(() => repository.sendMessageToServer(any()))
          .thenAnswer((_) async => serverId);
      when(() => repository.updateMessage(any())).thenAnswer((inv) async {
        updatedMsg = inv.positionalArguments.first as Message;
      });

      await useCase(content: 'Hello', senderId: 'me');

      expect(updatedMsg, isNotNull);
      expect(updatedMsg!.id, pendingMsg!.id); // same row
      expect(updatedMsg!.status, MessageStatus.sent);
      expect(updatedMsg!.serverId, serverId);
    });

    test('failure path: updateMessage called with failed status', () async {
      when(() => repository.sendMessageToServer(any()))
          .thenThrow(Exception('network error'));

      Message? updatedMsg;
      when(() => repository.updateMessage(any())).thenAnswer((inv) async {
        updatedMsg = inv.positionalArguments.first as Message;
      });

      await useCase(content: 'Oops', senderId: 'me');

      expect(updatedMsg!.status, MessageStatus.failed);
    });

    test('two sends produce unique client ids', () async {
      final ids = <String>[];

      when(() => repository.insertPendingMessage(any())).thenAnswer((inv) async {
        ids.add((inv.positionalArguments.first as Message).id);
      });
      when(() => repository.sendMessageToServer(any()))
          .thenAnswer((_) async => 'srv-x');

      await useCase(content: 'A', senderId: 'me');
      await useCase(content: 'B', senderId: 'me');

      expect(ids.length, 2);
      expect(ids[0], isNot(ids[1]));
    });
  });
}
