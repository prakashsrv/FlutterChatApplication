import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_status.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const Message._(); // allows custom methods; also prevents IDE from injecting stubs

  const factory Message({
    /// Client-generated UUID — stable across optimistic send → server echo.
    required String id,

    /// Set once the server acknowledges the message.
    String? serverId,

    required String content,
    required String senderId,

    /// UTC millis at the moment the user pressed send (used for ordering own messages).
    required int clientTimestamp,

    /// UTC millis from the server; null until the echo arrives.
    int? serverTimestamp,

    required MessageStatus status,

    /// True when senderId matches the local user's id.
    required bool isOwn,
  }) = _Message;

  @override
  // TODO: implement clientTimestamp
  int get clientTimestamp => throw UnimplementedError();

  @override
  // TODO: implement content
  String get content => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement isOwn
  bool get isOwn => throw UnimplementedError();

  @override
  // TODO: implement senderId
  String get senderId => throw UnimplementedError();

  @override
  // TODO: implement serverId
  String? get serverId => throw UnimplementedError();

  @override
  // TODO: implement serverTimestamp
  int? get serverTimestamp => throw UnimplementedError();

  @override
  // TODO: implement status
  MessageStatus get status => throw UnimplementedError();
}
