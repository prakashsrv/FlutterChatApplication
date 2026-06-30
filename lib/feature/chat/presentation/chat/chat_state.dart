import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/message.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const ChatState._(); // prevents IDE from injecting abstract getter stubs

  const factory ChatState({
    @Default([]) List<Message> messages,
    @Default('') String inputText,
    @Default(false) bool isTypingIndicatorVisible,
  }) = _ChatState;

  @override
  // TODO: implement inputText
  String get inputText => throw UnimplementedError();

  @override
  // TODO: implement isTypingIndicatorVisible
  bool get isTypingIndicatorVisible => throw UnimplementedError();

  @override
  // TODO: implement messages
  List<Message> get messages => throw UnimplementedError();
}
