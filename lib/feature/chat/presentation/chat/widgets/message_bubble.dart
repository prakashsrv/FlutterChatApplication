import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/model/message.dart';
import '../../../domain/model/message_status.dart';

/// A single chat bubble — own messages sit on the right, others on the left.
/// Failed messages show a red error indicator with a retry tap target.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    this.onRetry,
    super.key,
  });

  final Message message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isOwn = message.isOwn;
    final theme = Theme.of(context);

    return Align(
      alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: isOwn ? 48 : 12,
            right: isOwn ? 12 : 48,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isOwn
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isOwn ? 16 : 4),
              bottomRight: Radius.circular(isOwn ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isOwn
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.clientTimestamp),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: (isOwn
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant)
                          .withOpacity(0.7),
                    ),
                  ),
                  if (isOwn) ...[
                    const SizedBox(width: 4),
                    _StatusIcon(status: message.status, onRetry: onRetry),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int millisSinceEpoch) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch);
    return DateFormat.jm().format(dt);
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status, this.onRetry});

  final MessageStatus status;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.pending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 1.5),
        );
      case MessageStatus.sent:
        return const Icon(Icons.done_all, size: 14, color: Colors.white70);
      case MessageStatus.failed:
        return GestureDetector(
          onTap: onRetry,
          child: const Icon(Icons.error_outline, size: 14, color: Colors.red),
        );
    }
  }
}
