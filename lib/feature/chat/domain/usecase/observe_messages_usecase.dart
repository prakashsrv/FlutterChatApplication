import '../model/message.dart';
import '../repository/chat_repository.dart';

class ObserveMessagesUseCase {
  ObserveMessagesUseCase(this._repository);

  final ChatRepository _repository;

  /// Returns the reactive stream from the repository (Drift → ordered by clientTimestamp).
  Stream<List<Message>> call() => _repository.observeMessages();
}
