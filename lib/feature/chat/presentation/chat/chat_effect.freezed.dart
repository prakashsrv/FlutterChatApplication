// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_effect.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatEffect {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatEffect);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatEffect()';
  }
}

/// @nodoc
class $ChatEffectCopyWith<$Res> {
  $ChatEffectCopyWith(ChatEffect _, $Res Function(ChatEffect) __);
}

/// Adds pattern-matching-related methods to [ChatEffect].
extension ChatEffectPatterns on ChatEffect {
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
    TResult Function(ScrollToBottom value)? scrollToBottom,
    TResult Function(ShowError value)? showError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ScrollToBottom() when scrollToBottom != null:
        return scrollToBottom(_that);
      case ShowError() when showError != null:
        return showError(_that);
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
    required TResult Function(ScrollToBottom value) scrollToBottom,
    required TResult Function(ShowError value) showError,
  }) {
    final _that = this;
    switch (_that) {
      case ScrollToBottom():
        return scrollToBottom(_that);
      case ShowError():
        return showError(_that);
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
    TResult? Function(ScrollToBottom value)? scrollToBottom,
    TResult? Function(ShowError value)? showError,
  }) {
    final _that = this;
    switch (_that) {
      case ScrollToBottom() when scrollToBottom != null:
        return scrollToBottom(_that);
      case ShowError() when showError != null:
        return showError(_that);
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
    TResult Function()? scrollToBottom,
    TResult Function(String message)? showError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ScrollToBottom() when scrollToBottom != null:
        return scrollToBottom();
      case ShowError() when showError != null:
        return showError(_that.message);
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
    required TResult Function() scrollToBottom,
    required TResult Function(String message) showError,
  }) {
    final _that = this;
    switch (_that) {
      case ScrollToBottom():
        return scrollToBottom();
      case ShowError():
        return showError(_that.message);
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
    TResult? Function()? scrollToBottom,
    TResult? Function(String message)? showError,
  }) {
    final _that = this;
    switch (_that) {
      case ScrollToBottom() when scrollToBottom != null:
        return scrollToBottom();
      case ShowError() when showError != null:
        return showError(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ScrollToBottom implements ChatEffect {
  const ScrollToBottom();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ScrollToBottom);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatEffect.scrollToBottom()';
  }
}

/// @nodoc

class ShowError implements ChatEffect {
  const ShowError(this.message);

  final String message;

  /// Create a copy of ChatEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShowErrorCopyWith<ShowError> get copyWith =>
      _$ShowErrorCopyWithImpl<ShowError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShowError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ChatEffect.showError(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ShowErrorCopyWith<$Res>
    implements $ChatEffectCopyWith<$Res> {
  factory $ShowErrorCopyWith(ShowError value, $Res Function(ShowError) _then) =
      _$ShowErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ShowErrorCopyWithImpl<$Res> implements $ShowErrorCopyWith<$Res> {
  _$ShowErrorCopyWithImpl(this._self, this._then);

  final ShowError _self;
  final $Res Function(ShowError) _then;

  /// Create a copy of ChatEffect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ShowError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
