import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';

class LoadingState {
  final bool show;
  final String message;
  LoadingState({required this.show, this.message = "..."});
}

class LoadingService {
  static final ValueNotifier<LoadingState> state = 
      ValueNotifier(LoadingState(show: false));

  // Keep track of the active timer
  static Timer? _autoHideTimer;

  static void show([String? message, Duration timeout = const Duration(milliseconds: 300)]) {
    // 1. Cancel any existing timer before starting a new one
    _autoHideTimer?.cancel();

    // 2. Update the state to show the loader
    state.value = LoadingState(show: true, message: message ?? "...");

    // 3. Start a new timer to hide it automatically
    _autoHideTimer = Timer(timeout, () {
      hide();
    });
  }

  static void hide() {
    _autoHideTimer?.cancel(); // Stop the timer if we hide manually
    state.value = LoadingState(show: false);
  }
}