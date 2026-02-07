import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Primary Theme Color
  final Color primaryPink = const Color(0xFFD67070);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The lower part is now the primary pink color
      backgroundColor: primaryPink,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. TOP SECTION: White Header (Oval/Wave)
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                padding: const EdgeInsets.only(top: 60, bottom: 60),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white, // Swapped to White
                ),
                child: Column(
                  children: [
                    _buildGlassCalendar(),
                    const SizedBox(height: 25),
                    Text(
                      "Your Next Period starts in:",
                      style: TextStyle(
                        color: primaryPink.withValues(alpha: 0.8), 
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "4 Days",
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: primaryPink, // Text is now Pink
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _statusRow(Icons.water_drop, "Cycle Status: Pre-period Status", primaryPink),
                    _statusRow(Icons.pregnant_woman, "Pregnancy Chance: Low", primaryPink),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _topActionButton("Log Period", Icons.calendar_today),
                        const SizedBox(width: 15),
                        _topActionButton("Log Symptoms", Icons.add_chart),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 2. BOTTOM SECTION: Insights with Pink Background
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Daily Insights:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 18, 
                      color: Colors.white, // Text is now White
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Insights Grid
                  Row(
                    children: [
                      _insightCard("Sex Drive", "Sign In to View", Icons.lock_outline, (){}),
                      const SizedBox(width: 10),
                      _insightCard("Symptoms", "Hormones", Icons.mood, (){}),
                      const SizedBox(width: 10),
                      _insightCard("Cycle Day", "26", Icons.water_drop_outlined, (){}),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Illustration Cards
                  _wideIllustrationCard(
                    "Pre-period Overview", 
                    Colors.white.withValues(alpha: 0.1), // Subtle white tint
                    true,
                  ),
                  _wideIllustrationCard(
                    "Am I Pregnant?", 
                    Colors.white.withValues(alpha: 0.1),
                    false,
                  ),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildGlassCalendar() {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Adjust horizontal margin based on screen width
      double horizontalMargin = constraints.maxWidth > 600 ? 40 : 20;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: primaryPink.withValues(alpha: 0.1),
          border: Border.all(color: primaryPink.withValues(alpha: 0.1)),
        ),
        child: TableCalendar(
          // --- Interactive Logic ---
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          
          // This tells the calendar which day is currently selected
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          
          // Updates the state when a user taps a day
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },

          // Updates the state when the user switches between Week/Month view
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },

          // Handles page swipes
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },

          // --- Styling ---
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: primaryPink, 
              fontWeight: FontWeight.bold,
              fontSize: constraints.maxWidth > 600 ? 20 : 16, // Responsive font
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: primaryPink),
            rightChevronIcon: Icon(Icons.chevron_right, color: primaryPink),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(color: primaryPink.withValues(alpha: 0.7)),
            weekendTextStyle: TextStyle(color: primaryPink.withValues(alpha: 0.7)),
            selectedDecoration: BoxDecoration(color: primaryPink, shape: BoxShape.circle),
            selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            todayDecoration: BoxDecoration(
              color: primaryPink.withValues(alpha: 0.2), 
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(color: primaryPink),
            // Makes the markers/dots responsive
            markerSize: 6,
          ),
        ),
      );
    },
  );
}

  Widget _statusRow(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _topActionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  Widget _insightCard(String title, String value, IconData? icon, VoidCallback onTap) {
  return Expanded(
    child: Ink(
      height: 100, // 🔒 Strict height enforcement
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: primaryPink.withValues(alpha: 0.2),
        highlightColor: primaryPink.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Keeps content centered vertically
            children: [
              Text(
                title,
                maxLines: 1, // Prevents text from pushing height
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (icon != null) 
                Icon(icon, size: 22, color: primaryPink),
              const SizedBox(height: 4),
              Text(
                value,
                textAlign: TextAlign.center,
                maxLines: 2, // Allows two lines if the value is long
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _wideIllustrationCard(String title, Color illustrationBg, bool alignRight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2), // Transparent white cards
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
          ),
          Positioned(
            right: alignRight ? 0 : null,
            left: alignRight ? null : 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 150,
                height: 120,
                color: illustrationBg,
                child: const Icon(Icons.spa, color: Colors.white70, size: 40),
              ),
            ),
          ),
          if (!alignRight)
            Positioned(
              bottom: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Stop Guessing", 
                  style: TextStyle(color: primaryPink, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    var firstControlPoint = Offset(size.width / 2, size.height + 20);
    var firstEndPoint = Offset(size.width, size.height - 80);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}