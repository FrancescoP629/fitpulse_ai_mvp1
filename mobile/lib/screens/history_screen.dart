// /home/ubuntu/fitpulse_ai/mobile/lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
// Import necessary models and services
import '../models/history_item.dart'; // Import the HistoryItem model
// import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  // Use List<HistoryItem> instead of List<Map<String, dynamic>>
  List<HistoryItem> _historyItems = [];
  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // --- Mock Logic to get history --- 
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      // In a real app, call ApiService.getHistory() which would return List<HistoryItem>
      setState(() {
        // Create HistoryItem objects directly
        _historyItems = List.generate(15, (index) => HistoryItem(
          workoutId: 'uuid_${index}',
          date: DateTime.now().subtract(Duration(days: index * 2, hours: index * 3)),
          intensity: (index % 5) + 1, // Cycle intensity 1-5
          durationMinutes: 25.0 + (index * 1.5),
          exercisesCompleted: 4 + (index % 3),
        ));
      });
      // --- End Mock Logic ---

    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error loading history: ${e.toString()}";
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
        title: const Text('Workout History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchHistory,
            tooltip: 'Refresh History',
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

    if (_historyItems.isEmpty) {
      return const Center(
        child: Text('No workouts in history.'),
      );
    }

    // Show the history list using HistoryItem objects
    return ListView.builder(
      itemCount: _historyItems.length,
      itemBuilder: (context, index) {
        final item = _historyItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              // Access properties directly from the HistoryItem object
              child: Text('${item.intensity}'), 
              backgroundColor: _getIntensityColor(item.intensity),
              foregroundColor: Colors.white,
            ),
            title: Text('Workout - ${_dateFormatter.format(item.date)}'),
            subtitle: Text('Duration: ${item.durationMinutes.toStringAsFixed(1)} min - Exercises: ${item.exercisesCompleted}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to a workout detail screen (not implemented)
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Workout detail ${item.workoutId} not yet implemented.')),
              );
            },
          ),
        );
      },
    );
  }

  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 1: return Colors.green.shade300;
      case 2: return Colors.lightGreen;
      case 3: return Colors.amber.shade600;
      case 4: return Colors.orange.shade800;
      case 5: return Colors.red.shade700;
      default: return Colors.grey;
    }
  }
}

