import 'package:flutter_riverpod/flutter_riverpod.dart';

// This holds the current index globally
final navIndexProvider = StateProvider<int>((ref) => 0);
final isLoadingProvider = StateProvider<bool>((ref) => false);