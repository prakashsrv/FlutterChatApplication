import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_effect.freezed.dart';

/// One-shot effects — mirrors Android's ChatEffect / SharedFlow.
/// Consumed once via [ChatBloc.effects]; never replayed on rebuild.
@freezed
sealed class ChatEffect with _$ChatEffect {
  const factory ChatEffect.scrollToBottom() = ScrollToBottom;
  const factory ChatEffect.showError(String message) = ShowError;
}
