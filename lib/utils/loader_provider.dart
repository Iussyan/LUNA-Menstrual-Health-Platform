// lib/utils/app_observer.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luna_prototype/providers/navigation_provider.dart';

class AppObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    // If ANY provider in the app enters a 'Loading' state, show the global loader
    if (newValue is AsyncLoading) {
      container.read(isLoadingProvider.notifier).state = true;
    } else if (previousValue is AsyncLoading) {
       container.read(isLoadingProvider.notifier).state = false;
    }
  }
}