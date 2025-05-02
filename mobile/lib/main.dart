// /home/ubuntu/fitpulse_ai/mobile/lib/main.dart

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // Will be the main screen after login

void main() {
  runApp(const FitPulseApp());
}

class FitPulseApp extends StatelessWidget {
  const FitPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitPulse AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Initially show the login screen
      // In a real app, there would be logic to check if the user is already logged in
      home: const LoginScreen(), 
      routes: {
        '/home': (context) => const HomeScreen(),
        // Add other routes if necessary
      },
    );
  }
}

