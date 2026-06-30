// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatEvent()';
  }
}

/// @nodoc
class $ChatEventCopyWith<$Res> {
  $ChatEventCopyWith(ChatEvent _, $Res Function(ChatEvent) __);
}

/// Adds pattern-matching-related methods to [ChatEvent].
extension ChatEventPatterns on ChatEvent {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputChanged value)? inputChanged,
    TResult Function(SendMessage value)? sendMessage,
    TResult Function(RetryMessage value)? retryMessage,
    TResult Function(SimulateNextFailure value)? simulateNextFailure,
    TResult Function(MessagesUpdated value)? messagesUpdated,
    TResult Function(TypingChanged value)? typingChanged,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case InputChanged() when inputChanged != null:
        return inputChanged(_that);
      case SendMessage() when sendMessage != null:
        return sendMessage(_that);
      case RetryMessage() when retryMessage != null:
        return retryMessage(_that);
      case SimulateNextFailure() when simulateNextFailure != null:
        return simulateNextFailure(_that);
      case MessagesUpdated() when messagesUpdated != null:
        return messagesUpdated(_that);
      case TypingChanged() when typingChanged != null:
        return typingChanged(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputChanged value) inputChanged,
    required TResult Function(SendMessage value) sendMessage,
    required TResult Function(RetryMessage value) retryMessage,
    required TResult Function(SimulateNextFailure value) simulateNextFailure,
    required TResult Function(MessagesUpdated value) messagesUpdated,
    required TResult Function(TypingChanged value) typingChanged,
  }) {
    final _that = this;
    switch (_that) {
      case InputChanged():
        return inputChanged(_that);
      case SendMessage():
        return sendMessage(_that);
      case RetryMessage():
        return retryMessage(_that);
      case SimulateNextFailure():
        return simulateNextFailure(_that);
      case MessagesUpdated():
        return messagesUpdated(_that);
      case TypingChanged():
        return typingChanged(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputChanged value)? inputChanged,
    TResult? Function(SendMessage value)? sendMessage,
    TResult? Function(RetryMessage value)? retryMessage,
    TResult? Function(SimulateNextFailure value)? simulateNextFailure,
    TResult? Function(MessagesUpdated value)? messagesUpdated,
    TResult? Function(TypingChanged value)? typingChanged,
  }) {
    final _that = this;
    switch (_that) {
      case InputChanged() when inputChanged != null:
        return inputChanged(_that);
      case SendMessage() when sendMessage != null:
        return sendMessage(_that);
      case RetryMessage() when retryMessage != null:
        return retryMessage(_that);
      case SimulateNextFailure() when simulateNextFailure != null:
        return simulateNextFailure(_that);
      case MessagesUpdated() when messagesUpdated != null:
        return messagesUpdated(_that);
      case TypingChanged() when typingChanged != null:
        return typingChanged(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? inputChanged,
    TResult Function()? sendMessage,
    TResult Function(Message message)? retryMessage,
    TResult Function()? simulateNextFailure,
    TResult Function(List<Message> messages)? messagesUpdated,
    TResult Function(bool isTyping)? typingChanged,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case InputChanged() when inputChanged != null:
        return inputChanged(_that.text);
      case SendMessage() when sendMessage != null:
        return sendMessage();
      case RetryMessage() when retryMessage != null:
        return retryMessage(_that.message);
      case SimulateNextFailure() when simulateNextFailure != null:
        return simulateNextFailure();
      case MessagesUpdated() when messagesUpdated != null:
        return messagesUpdated(_that.messages);
      case TypingChanged() when typingChanged != null:
        return typingChanged(_that.isTyping);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) inputChanged,
    required TResult Function() sendMessage,
    required TResult Function(Message message) retryMessage,
    required TResult Function() simulateNextFailure,
    required TResult Function(List<Message> messages) messagesUpdated,
    required TResult Function(bool isTyping) typingChanged,
  }) {
    final _that = this;
    switch (_that) {
      case InputChanged():
        return inputChanged(_that.text);
      case SendMessage():
        return sendMessage();
      case RetryMessage():
        return retryMessage(_that.message);
      case SimulateNextFailure():
        return simulateNextFailure();
      case MessagesUpdated():
        return messagesUpdated(_that.messages);
      case TypingChanged():
        return typingChanged(_that.isTyping);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? inputChanged,
    TResult? Function()? sendMessage,
    TResult? Function(Message message)? retryMessage,
    TResult? Function()? simulateNextFailure,
    TResult? Function(List<Message> messages)? messagesUpdated,
    TResult? Function(bool isTyping)? typingChanged,
  }) {
    final _that = this;
    switch (_that) {
      case InputChanged() when inputChanged != null:
        return inputChanged(_that.text);
      case SendMessage() when sendMessage != null:
        return sendMessage();
      case RetryMessage() when retryMessage != null:
        return retryMessage(_that.message);
      case SimulateNextFailure() when simulateNextFailure != null:
        return simulateNextFailure();
      case MessagesUpdated() when messagesUpdated != null:
        return messagesUpdated(_that.messages);
      case TypingChanged() when typingChanged != null:
        return typingChanged(_that.isTyping);
      case _:
        return null;
    }
  }
}

/// @nodoc

class InputChanged implements ChatEvent {
  const InputChanged(this.text);

  final String text;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InputChangedCopyWith<InputChanged> get copyWith =>
      _$InputChangedCopyWithImpl<InputChanged>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InputChanged &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @override
  String toString() {
    return 'ChatEvent.inputChanged(text: $text)';
  }
}

/// @nodoc
abstract mixin class $InputChangedCopyWith<$Res>
    implements $ChatEventCopyWith<$Res> {
  factory $InputChangedCopyWith(
          InputChanged value, $Res Function(InputChanged) _then) =
      _$InputChangedCopyWithImpl;
  @useResult
  $Res call({String text});
}

/// @nodoc
class _$InputChangedCopyWithImpl<$Res> implements $InputChangedCopyWith<$Res> {
  _$InputChangedCopyWithImpl(this._self, this._then);

  final InputChanged _self;
  final $Res Function(InputChanged) _then;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = null,
  }) {
    return _then(InputChanged(
      null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class SendMessage implements ChatEvent {
  const SendMessage();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SendMessage);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatEvent.sendMessage()';
  }
}

/// @nodoc

class RetryMessage implements ChatEvent {
  const RetryMessage(this.message);

  final Message message;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RetryMessageCopyWith<RetryMessage> get copyWith =>
      _$RetryMessageCopyWithImpl<RetryMessage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RetryMessage &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ChatEvent.retryMessage(message: $message)';
  }
}

/// @nodoc
abstract mixin class $RetryMessageCopyWith<$Res>
    implements $ChatEventCopyWith<$Res> {
  factory $RetryMessageCopyWith(
          RetryMessage value, $Res Function(RetryMessage) _then) =
      _$RetryMessageCopyWithImpl;
  @useResult
  $Res call({Message message});

  $MessageCopyWith<$Res> get message;
}

/// @nodoc
class _$RetryMessageCopyWithImpl<$Res> implements $RetryMessageCopyWith<$Res> {
  _$RetryMessageCopyWithImpl(this._self, this._then);

  final RetryMessage _self;
  final $Res Function(RetryMessage) _then;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(RetryMessage(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as Message,
    ));
  }

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageCopyWith<$Res> get message {
    return $MessageCopyWith<$Res>(_self.message, (value) {
      return _then(_self.copyWith(message: value));
    });
  }
}

/// @nodoc

class SimulateNextFailure implements ChatEvent {
  const SimulateNextFailure();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SimulateNextFailure);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatEvent.simulateNextFailure()';
  }
}

/// @nodoc

class MessagesUpdated implements ChatEvent {
  const MessagesUpdated(final List<Message> messages) : _messages = messages;

  final List<Message> _messages;
  List<Message> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessagesUpdatedCopyWith<MessagesUpdated> get copyWith =>
      _$MessagesUpdatedCopyWithImpl<MessagesUpdated>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessagesUpdated &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_messages));

  @override
  String toString() {
    return 'ChatEvent.messagesUpdated(messages: $messages)';
  }
}

/// @nodoc
abstract mixin class $MessagesUpdatedCopyWith<$Res>
    implements $ChatEventCopyWith<$Res> {
  factory $MessagesUpdatedCopyWith(
          MessagesUpdated value, $Res Function(MessagesUpdated) _then) =
      _$MessagesUpdatedCopyWithImpl;
  @useResult
  $Res call({List<Message> messages});
}

/// @nodoc
class _$MessagesUpdatedCopyWithImpl<$Res>
    implements $MessagesUpdatedCopyWith<$Res> {
  _$MessagesUpdatedCopyWithImpl(this._self, this._then);

  final MessagesUpdated _self;
  final $Res Function(MessagesUpdated) _then;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? messages = null,
  }) {
    return _then(MessagesUpdated(
      null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
    ));
  }
}

/// @nodoc

class TypingChanged implements ChatEvent {
  const TypingChanged(this.isTyping);

  final bool isTyping;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TypingChangedCopyWith<TypingChanged> get copyWith =>
      _$TypingChangedCopyWithImpl<TypingChanged>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TypingChanged &&
            (identical(other.isTyping, isTyping) ||
                other.isTyping == isTyping));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isTyping);

  @override
  String toString() {
    return 'ChatEvent.typingChanged(isTyping: $isTyping)';
  }
}

/// @nodoc
abstract mixin class $TypingChangedCopyWith<$Res>
    implements $ChatEventCopyWith<$Res> {
  factory $TypingChangedCopyWith(
          TypingChanged value, $Res Function(TypingChanged) _then) =
      _$TypingChangedCopyWithImpl;
  @useResult
  $Res call({bool isTyping});
}

/// @nodoc
class _$TypingChangedCopyWithImpl<$Res>
    implements $TypingChangedCopyWith<$Res> {
  _$TypingChangedCopyWithImpl(this._self, this._then);

  final TypingChanged _self;
  final $Res Function(TypingChanged) _then;

  /// Create a copy of ChatEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isTyping = null,
  }) {
    return _then(TypingChanged(
      null == isTyping
          ? _self.isTyping
          : isTyping // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
