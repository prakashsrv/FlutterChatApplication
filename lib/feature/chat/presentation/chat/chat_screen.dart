import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/message_status.dart';
import 'chat_bloc.dart';
import 'chat_effect.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/sync_status_banner.dart';
import 'widgets/typing_indicator.dart';

/// The main chat screen.
///
/// BlocBuilder  → replaces collectAsStateWithLifecycle()
/// effect stream → replaces collecting the SharedFlow<ChatEffect>
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.onBurst});

  final VoidCallback? onBurst;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  StreamSubscription<ChatEffect>? _effectSub;

  @override
  void initState() {
    super.initState();
    // Subscribe to one-shot effects after the first frame so the Bloc is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _effectSub = context.read<ChatBloc>().effects.listen(_handleEffect);
    });
  }

  @override
  void dispose() {
    _effectSub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleEffect(ChatEffect effect) {
    switch (effect) {
      case ScrollToBottom():
        _scrollToBottom();
      case ShowError(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          _DebugBar(onBurst: widget.onBurst),
        ],
      ),
      body: Column(
        children: [
          // Background-sync status banner (hidden when connected).
          BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (p, c) => p.syncStatus != c.syncStatus,
            builder: (_, state) => SyncStatusBanner(status: state.syncStatus),
          ),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount:
                      state.messages.length + (state.isTypingIndicatorVisible ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (state.isTypingIndicatorVisible &&
                        index == state.messages.length) {
                      return const TypingIndicator();
                    }
                    final message = state.messages[index];
                    return MessageBubble(
                      key: ValueKey(message.id),
                      message: message,
                      onRetry: message.status == MessageStatus.failed
                          ? () => context
                              .read<ChatBloc>()
                              .add(ChatEvent.retryMessage(message))
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          const ChatInputBar(),
        ],
      ),
    );
  }
}

/// Debug controls — visible at the top-right of the AppBar.
/// Mirrors the Android debug UI: rapid inbound burst + force failure.
class _DebugBar extends StatelessWidget {
  const _DebugBar({this.onBurst});

  final VoidCallback? onBurst;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.bug_report_outlined),
      tooltip: 'Debug',
      onSelected: (value) {
        switch (value) {
          case 'burst':
            onBurst?.call();
          case 'fail':
            context
                .read<ChatBloc>()
                .add(const ChatEvent.simulateNextFailure());
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'burst',
          child: Text('Emit 30-message burst'),
        ),
        PopupMenuItem(
          value: 'fail',
          child: Text('Force next send to fail'),
        ),
      ],
    );
  }
}
