import 'package:flutter/material.dart';

import '../../../domain/sync/sync_status.dart';

/// A slim banner shown at the top of the chat list when the app is backgrounded
/// or syncing buffered messages after returning to the foreground.
///
/// Hidden when [status] is [SyncStatus.connected].
class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({required this.status, super.key});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.connected) return const SizedBox.shrink();

    final (label, color, showSpinner) = switch (status) {
      SyncStatus.background => (
          'Paused — messages will arrive when you return',
          Colors.orange.shade700,
          false,
        ),
      SyncStatus.syncing => (
          'Syncing missed messages…',
          Theme.of(context).colorScheme.primary,
          true,
        ),
      SyncStatus.connected => ('', Colors.transparent, false),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      color: color.withOpacity(0.12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (showSpinner) ...[
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            ),
            const SizedBox(width: 10),
          ] else ...[
            Icon(Icons.wifi_off_rounded, size: 16, color: color),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
