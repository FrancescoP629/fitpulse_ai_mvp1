// /home/ubuntu/fitpulse_ai/mobile/lib/screens/today_workout_screen.dart

import 'package:flutter/material.dart';
// Import necessary models and services
import '../models/exercise.dart'; // Import the Exercise model
// import '../services/api_service.dart';

class TodayWorkoutScreen extends StatefulWidget {
  const TodayWorkoutScreen({super.key});

  @override
  State<TodayWorkoutScreen> createState() => _TodayWorkoutScreenState();
}

class _TodayWorkoutScreenState extends State<TodayWorkoutScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  // Use List<Exercise> instead of List<Map<String, String>>
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkout();
  }

  Future<void> _fetchWorkout() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // --- Mock Logic to get the workout --- 
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      // In a real app, call ApiService.getWorkout() which would return List<Exercise>
      setState(() {
        // Create Exercise objects directly
        _exercises = [
          Exercise(name: 'Warm-up Jog', sets: 1, reps: '5min'),
          Exercise(name: 'Bodyweight Squats', sets: 3, reps: '12'),
          Exercise(name: 'Push-ups', sets: 3, reps: '10'),
          Exercise(name: 'Plank', sets: 3, reps: '30s'),
        ];
      });
      // --- End Mock Logic ---

    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error loading workout: ${e.toString()}";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\s Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchWorkout,
            tooltip: 'Refresh Workout',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_exercises.isEmpty) {
      return const Center(
        child: Text('No workout available for today. Tap refresh!'),
      );
    }

    // Show the list of exercises using Exercise objects
    return ListView.builder(
      itemCount: _exercises.length,
      itemBuilder: (context, index) {
        final exercise = _exercises[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            // Access properties directly from the Exercise object
            title: Text(exercise.name),
            subtitle: Text('Sets: ${exercise.sets} - Reps: ${exercise.reps}'),
            trailing: IconButton(
              icon: const Icon(Icons.play_circle_outline),
              tooltip: 'Start Exercise (not implemented)',
              onPressed: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Start exercise functionality not yet implemented.')),
                 );
              },
            ),
            // Add onTap for exercise details?
          ),
        );
      },
    );
  }
}

