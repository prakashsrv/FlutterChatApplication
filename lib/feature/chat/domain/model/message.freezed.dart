// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Message {
  /// Client-generated UUID — stable across optimistic send → server echo.
  String get id;

  /// Set once the server acknowledges the message.
  String? get serverId;
  String get content;
  String get senderId;

  /// UTC millis at the moment the user pressed send (used for ordering own messages).
  int get clientTimestamp;

  /// UTC millis from the server; null until the echo arrives.
  int? get serverTimestamp;
  MessageStatus get status;

  /// True when senderId matches the local user's id.
  bool get isOwn;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageCopyWith<Message> get copyWith =>
      _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Message &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.clientTimestamp, clientTimestamp) ||
                other.clientTimestamp == clientTimestamp) &&
            (identical(other.serverTimestamp, serverTimestamp) ||
                other.serverTimestamp == serverTimestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isOwn, isOwn) || other.isOwn == isOwn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, serverId, content, senderId,
      clientTimestamp, serverTimestamp, status, isOwn);

  @override
  String toString() {
    return 'Message(id: $id, serverId: $serverId, content: $content, senderId: $senderId, clientTimestamp: $clientTimestamp, serverTimestamp: $serverTimestamp, status: $status, isOwn: $isOwn)';
  }
}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) =
      _$MessageCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? serverId,
      String content,
      String senderId,
      int clientTimestamp,
      int? serverTimestamp,
      MessageStatus status,
      bool isOwn});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res> implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? content = null,
    Object? senderId = null,
    Object? clientTimestamp = null,
    Object? serverTimestamp = freezed,
    Object? status = null,
    Object? isOwn = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      clientTimestamp: null == clientTimestamp
          ? _self.clientTimestamp
          : clientTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
      serverTimestamp: freezed == serverTimestamp
          ? _self.serverTimestamp
          : serverTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      isOwn: null == isOwn
          ? _self.isOwn
          : isOwn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Message value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Message() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_Message value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Message():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Message value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Message() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String? serverId,
            String content,
            String senderId,
            int clientTimestamp,
            int? serverTimestamp,
            MessageStatus status,
            bool isOwn)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Message() when $default != null:
        return $default(
            _that.id,
            _that.serverId,
            _that.content,
            _that.senderId,
            _that.clientTimestamp,
            _that.serverTimestamp,
            _that.status,
            _that.isOwn);
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
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String? serverId,
            String content,
            String senderId,
            int clientTimestamp,
            int? serverTimestamp,
            MessageStatus status,
            bool isOwn)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Message():
        return $default(
            _that.id,
            _that.serverId,
            _that.content,
            _that.senderId,
            _that.clientTimestamp,
            _that.serverTimestamp,
            _that.status,
            _that.isOwn);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String? serverId,
            String content,
            String senderId,
            int clientTimestamp,
            int? serverTimestamp,
            MessageStatus status,
            bool isOwn)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Message() when $default != null:
        return $default(
            _that.id,
            _that.serverId,
            _that.content,
            _that.senderId,
            _that.clientTimestamp,
            _that.serverTimestamp,
            _that.status,
            _that.isOwn);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Message implements Message {
  const _Message(
      {required this.id,
      this.serverId,
      required this.content,
      required this.senderId,
      required this.clientTimestamp,
      this.serverTimestamp,
      required this.status,
      required this.isOwn});

  /// Client-generated UUID — stable across optimistic send → server echo.
  @override
  final String id;

  /// Set once the server acknowledges the message.
  @override
  final String? serverId;
  @override
  final String content;
  @override
  final String senderId;

  /// UTC millis at the moment the user pressed send (used for ordering own messages).
  @override
  final int clientTimestamp;

  /// UTC millis from the server; null until the echo arrives.
  @override
  final int? serverTimestamp;
  @override
  final MessageStatus status;

  /// True when senderId matches the local user's id.
  @override
  final bool isOwn;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MessageCopyWith<_Message> get copyWith =>
      __$MessageCopyWithImpl<_Message>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Message &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.clientTimestamp, clientTimestamp) ||
                other.clientTimestamp == clientTimestamp) &&
            (identical(other.serverTimestamp, serverTimestamp) ||
                other.serverTimestamp == serverTimestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isOwn, isOwn) || other.isOwn == isOwn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, serverId, content, senderId,
      clientTimestamp, serverTimestamp, status, isOwn);

  @override
  String toString() {
    return 'Message(id: $id, serverId: $serverId, content: $content, senderId: $senderId, clientTimestamp: $clientTimestamp, serverTimestamp: $serverTimestamp, status: $status, isOwn: $isOwn)';
  }
}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) =
      __$MessageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? serverId,
      String content,
      String senderId,
      int clientTimestamp,
      int? serverTimestamp,
      MessageStatus status,
      bool isOwn});
}

/// @nodoc
class __$MessageCopyWithImpl<$Res> implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? content = null,
    Object? senderId = null,
    Object? clientTimestamp = null,
    Object? serverTimestamp = freezed,
    Object? status = null,
    Object? isOwn = null,
  }) {
    return _then(_Message(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      clientTimestamp: null == clientTimestamp
          ? _self.clientTimestamp
          : clientTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
      serverTimestamp: freezed == serverTimestamp
          ? _self.serverTimestamp
          : serverTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      isOwn: null == isOwn
          ? _self.isOwn
          : isOwn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
