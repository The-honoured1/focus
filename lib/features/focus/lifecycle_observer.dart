import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'focus_provider.dart';

class LifecycleObserver extends WidgetsBindingObserver {
  final Ref ref;

  LifecycleObserver(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Strict Mode: Fail session if user leaves the app
      final focusState = ref.read(focusProvider);
      if (focusState.status == FocusStatus.running) {
        ref.read(focusProvider.notifier).failSession();
      }
    }
  }
}

final lifecycleObserverProvider = Provider<LifecycleObserver>((ref) {
  return LifecycleObserver(ref);
});
