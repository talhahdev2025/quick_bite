import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';

final routerNotifierProvider = NotifierProvider<RouterNotifier, void>(
  () => RouterNotifier(),
);

class RouterNotifier extends Notifier<void> implements Listenable {
  VoidCallback? _routerListener;

  @override
  void build() {
    ref.listen(authProvider, (previous, next) {
      if (previous?.isLoggedIn != next.isLoggedIn) {
        _routerListener?.call();
      }
    });
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}
