import 'package:flutter/material.dart';
import 'package:luna_prototype/screens/pages/account.dart';
import 'package:luna_prototype/screens/pages/calendar.dart';
import 'package:luna_prototype/screens/pages/cycle_tracking.dart';
import 'package:luna_prototype/screens/pages/intensity_monitoring.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Calendar(),
    const Cycle(),
    const Intensity(),
    const Account(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: const Text('LUNA'),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,          
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_outlined),
              label: 'Cycle Tracking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor_heart_sharp),
              label: 'Intensity Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
        drawer: const Drawer(),
      ),
    );
  }
}