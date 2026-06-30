import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat_bloc.dart';
import '../chat_event.dart';
import '../chat_state.dart';

/// The bottom input row — text field + send button.
/// Dispatches [InputChanged] and [SendMessage] events to [ChatBloc].
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> with RestorationMixin {
  final _restorable = RestorableTextEditingController();

  @override
  String get restorationId => 'chat_input_bar';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_restorable, 'input_text');
  }

  @override
  void dispose() {
    _restorable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (prev, curr) => curr.inputText.isEmpty && prev.inputText.isNotEmpty,
      listener: (_, __) {
        // Bloc cleared the input (after send) — sync the text field.
        _restorable.value.clear();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _restorable.value,
                  onChanged: (text) =>
                      context.read<ChatBloc>().add(ChatEvent.inputChanged(text)),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Message…',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) =>
                      context.read<ChatBloc>().add(const ChatEvent.sendMessage()),
                ),
              ),
              const SizedBox(width: 6),
              BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (p, c) => p.inputText != c.inputText,
                builder: (context, state) => IconButton.filled(
                  onPressed: state.inputText.trim().isEmpty
                      ? null
                      : () => context
                          .read<ChatBloc>()
                          .add(const ChatEvent.sendMessage()),
                  icon: const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
