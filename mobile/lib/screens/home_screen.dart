// /home/ubuntu/fitpulse_ai/mobile/lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'today_workout_screen.dart';
import 'camera_posture_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index for the current screen

  // List of main screens
  static const List<Widget> _widgetOptions = <Widget>[
    TodayWorkoutScreen(), // Screen 0: Today's Workout
    CameraPostureScreen(), // Screen 1: Camera Posture
    HistoryScreen(),       // Screen 2: History
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar can be specific to each screen or common here
      // For simplicity, we'll put it specifically in each child screen
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout', // Already in English
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Posture', // Already in English
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History', // Already in English
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

