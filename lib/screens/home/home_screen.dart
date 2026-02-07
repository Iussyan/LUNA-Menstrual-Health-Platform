import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luna_prototype/providers/loader_provider.dart';
import 'package:luna_prototype/providers/navigation_provider.dart';
import 'package:luna_prototype/screens/home/bottom_navbar.dart';
import 'package:luna_prototype/screens/pages/account.dart';
import 'package:luna_prototype/screens/pages/calendar.dart';
import 'package:luna_prototype/screens/pages/cycle_tracking.dart';
import 'package:luna_prototype/screens/pages/home.dart';
import 'package:luna_prototype/screens/pages/intensity_monitoring.dart';
import 'package:luna_prototype/screens/pages/loader.dart';

// Change to ConsumerWidget
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the shared index
    final selectedIndex = ref.watch(navIndexProvider);
    final isLoading = ref.watch(isLoadingProvider);

    final List<Widget> pages = [
      const Home(),
      const Calendar(),
      const Cycle(),
      const Intensity(),
      const Account(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.white, // Switching to white for a clean, modern look
        elevation: 0,
        scrolledUnderElevation:
            2, // Adds a subtle shadow only when content scrolls under it
        systemOverlayStyle: SystemUiOverlayStyle
            .dark, // Ensures status bar icons (time/battery) are visible
        // 1. Modern Leading Avatar
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              LoadingService.show("Please wait...");
              ref.read(navIndexProvider.notifier).state =
                  4; // Navigate to Account
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
        leadingWidth: 52, // Adjusted to give the avatar some breathing room
        // 2. Styled Title
        title: const Text(
          'Luna',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 30,
            letterSpacing: 2.0,
            fontFamily: 'Lobster', // Or your custom brand font
          ),
        ),
        centerTitle: true,

        // 3. User-Friendly Actions
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Example: Show a notification sheet
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black54,
                ),
                // Small Red Dot for "Smart" feedback
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8), // Right-side padding
        ],

        // 4. Subtle Bottom Border (Optional)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withValues(alpha: 0.05), height: 1.0),
        ),
      ),
      // Switch the page based on the provider's value
      body: Stack(
        children: [
          // The actual content stretched to fill the screen
          SizedBox.expand(child: pages[selectedIndex]),

          // The Loader overlay
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.03), // Dim the background
              child: const Center(child: LoadingIndicatorFb1()),
            ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: const BottomNavBarRaisedInsetFb1(),
    );
  }
}
