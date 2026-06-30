import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../lifecycle/app_lifecycle_observer.dart';
import '../../feature/chat/data/repository/chat_repository_impl.dart';
import '../../feature/chat/data/stream/fake_chat_stream.dart';
import '../../feature/chat/data/stream/fake_network_config.dart';
import '../../feature/chat/data/sync/background_sync_manager.dart';
import '../../feature/chat/domain/repository/chat_repository.dart';
import '../../feature/chat/domain/stream/chat_message_stream.dart';
import '../../feature/chat/domain/usecase/observe_messages_usecase.dart';
import '../../feature/chat/domain/usecase/retry_message_usecase.dart';
import '../../feature/chat/domain/usecase/send_message_usecase.dart';
import '../../feature/chat/presentation/chat/chat_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Infrastructure
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<FakeNetworkConfig>(FakeNetworkConfig());
  getIt.registerSingleton<AppLifecycleObserver>(AppLifecycleObserver());

  // Stream (registered as both concrete type + domain interface)
  final fakeStream = FakeChatStream();
  getIt.registerSingleton<FakeChatStream>(fakeStream);
  getIt.registerSingleton<ChatMessageStream>(fakeStream);

  // Background sync
  getIt.registerSingleton<BackgroundSyncManager>(
    BackgroundSyncManager(
      lifecycleObserver: getIt<AppLifecycleObserver>(),
      chatStream: getIt<FakeChatStream>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      database: getIt<AppDatabase>(),
      messageStream: getIt<ChatMessageStream>(),
      networkConfig: getIt<FakeNetworkConfig>(),
    ),
  );

  // Use cases
  getIt.registerFactory(() => SendMessageUseCase(getIt<ChatRepository>()));
  getIt.registerFactory(() => ObserveMessagesUseCase(getIt<ChatRepository>()));
  getIt.registerFactory(() => RetryMessageUseCase(getIt<ChatRepository>()));

  // Presentation
  getIt.registerFactory(
    () => ChatBloc(
      sendMessageUseCase: getIt<SendMessageUseCase>(),
      observeMessagesUseCase: getIt<ObserveMessagesUseCase>(),
      retryMessageUseCase: getIt<RetryMessageUseCase>(),
      chatMessageStream: getIt<ChatMessageStream>(),
      networkConfig: getIt<FakeNetworkConfig>(),
      syncManager: getIt<BackgroundSyncManager>(),
    ),
  );
}
