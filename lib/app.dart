import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'feature/chat/data/stream/fake_chat_stream.dart';
import 'feature/chat/presentation/chat/chat_bloc.dart';
import 'feature/chat/presentation/chat/chat_screen.dart';

/// Root application widget.
/// Sets up MaterialApp.router with go_router, provides ChatBloc via BlocProvider.
class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ChatBloc>(),
            child: Builder(
              builder: (ctx) => ChatScreen(
                key: const ValueKey('chat_screen'),
                onBurst: () => getIt<FakeChatStream>().emitBurst(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Chat',
      restorationScopeId: 'app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
