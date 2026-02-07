import 'package:flutter/material.dart';

class LoadingIndicatorFb1 extends StatelessWidget {
  final String message;
  const LoadingIndicatorFb1({super.key, this.message = "..."});

  @override
  Widget build(BuildContext context) {
    // We remove AbsorbPointer from here because you already have it in main.dart
    return Container(
      color: Colors.black.withValues(
        alpha: 0.05,
      ), // Essential for the blur to "grab" onto something
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withValues(alpha: 0.2 * value),
                        blurRadius: 20,
                        spreadRadius: 5 * value,
                      ),
                    ],
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.pinkAccent,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              message, // FIXED: Now uses the dynamic message
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
