import 'dart:async';

import 'package:flutter/widgets.dart';

/// Wraps [WidgetsBindingObserver] and exposes lifecycle transitions as a
/// broadcast [Stream<AppLifecycleState>].
///
/// Register once at startup (via DI); any component can subscribe without
/// needing its own [WidgetsBindingObserver] mixin.
class AppLifecycleObserver with WidgetsBindingObserver {
  AppLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  final _controller = StreamController<AppLifecycleState>.broadcast();

  /// Hot broadcast stream of lifecycle transitions.
  Stream<AppLifecycleState> get stream => _controller.stream;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.add(state);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.close();
  }
}
