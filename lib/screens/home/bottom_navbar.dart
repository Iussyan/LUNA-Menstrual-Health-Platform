import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luna_prototype/providers/loader_provider.dart';
import 'package:luna_prototype/providers/navigation_provider.dart';
import 'package:flutter/services.dart';

class BottomNavBarRaisedInsetFb1 extends ConsumerWidget {
  const BottomNavBarRaisedInsetFb1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);
    final Size size = MediaQuery.of(context).size;

    // Adjust height for better ergonomics and label space
    const double barHeight = 65;
    const primaryColor = Colors.pinkAccent;

    void navigate(int index, String label) {
      if (selectedIndex == index) return;
      HapticFeedback.lightImpact();
      ref.read(navIndexProvider.notifier).state = index;
      LoadingService.show("");
      Future.delayed(
        const Duration(milliseconds: 800),
        () => LoadingService.hide(),
      );
    }

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      // Remove default padding to let the Stack fill the space
      padding: EdgeInsets.zero,
      child: Container(
        height: barHeight + 20, // Extra space for the FAB overlap
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. The Background Curve
            CustomPaint(
              size: Size(size.width, barHeight),
              painter: BottomNavCurvePainter(backgroundColor: Colors.white),
            ),

            // 2. The Navigation Items (The Row)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: barHeight,
              child: Row(
                children: [
                  _buildTab(
                    2,
                    "Calendar",
                    Icons.date_range_outlined,
                    selectedIndex,
                    navigate,
                  ),
                  _buildTab(1, "Cycle", Icons.refresh, selectedIndex, navigate),
                  const Spacer(flex: 1), // Perfect gap for FAB
                  _buildTab(
                    3,
                    "Intensity",
                    Icons.bar_chart,
                    selectedIndex,
                    navigate,
                  ),
                  _buildTab(
                    4,
                    "Account",
                    Icons.person_outline,
                    selectedIndex,
                    navigate,
                  ),
                ],
              ),
            ),

            // 3. The Raised FAB
            Positioned(
              top:
                  -25, // Increased slightly to give the scaled-up button room to breathe
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedScale(
                  // 1.25 scale (25% increase) is the "sweet spot" for FAB animations
                  scale: selectedIndex == 0 ? 1.10 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  // ElasticOut gives that playful, springy bounce seen in high-end apps
                  curve: Curves.elasticOut,
                  child: FloatingActionButton(
                    // Animate elevation to add depth when selected
                    elevation: selectedIndex == 0 ? 12 : 6,
                    backgroundColor: primaryColor,
                    shape: const CircleBorder(),
                    onPressed: () => navigate(0, "Home"),
                    child: Icon(
                      // Toggle between filled and outlined to signal "Active" state
                      selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                      color: Colors.white,
                      size: 20, // Slightly larger icon
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    int index,
    String label,
    IconData icon,
    int current,
    Function(int, String) onTap,
  ) {
    return Expanded(
      child: NavBarIcon(
        text: label,
        icon: icon,
        selected: current == index,
        onPressed: () => onTap(index, label),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.pinkAccent : Colors.black;

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: selected ? 26 : 22, color: color),
          const SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          // More elegant indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3,
            width: selected ? 12 : 0,
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  final Color backgroundColor;
  final double insetRadius;

  BottomNavCurvePainter({
    this.backgroundColor = Colors.white,
    this.insetRadius = 40, // Slightly tighter radius
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path();

    double s = 12.0; // Smoothness factor
    double startX = size.width / 2 - insetRadius;
    double endX = size.width / 2 + insetRadius;

    path.moveTo(0, 0);
    path.lineTo(startX - s, 0);

    // Smoother cubic curve
    path.cubicTo(startX, 0, startX, 35, size.width / 2, 35);
    path.cubicTo(endX, 35, endX, 0, endX + s, 0);

    path.lineTo(size.width, 0);
    path.lineTo(
      size.width,
      size.height + 100,
    ); // EXTREMELY IMPORTANT: Fills below screen
    path.lineTo(0, size.height + 100);
    path.close();

    canvas.drawShadow(path, Colors.black26, 12, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
