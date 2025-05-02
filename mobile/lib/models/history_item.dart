// /home/ubuntu/fitpulse_ai/mobile/lib/models/history_item.dart

class HistoryItem {
  final String workoutId;
  final DateTime date;
  final int intensity;
  final double durationMinutes;
  final int exercisesCompleted;

  HistoryItem({
    required this.workoutId,
    required this.date,
    required this.intensity,
    required this.durationMinutes,
    required this.exercisesCompleted,
  });

  // Factory constructor to create a HistoryItem from a map (e.g., from API JSON)
  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      workoutId: map["workout_id"] ?? uuid.v4(), // Provide a default if missing
      // Ensure date parsing is robust
      date: map["date"] is String 
            ? DateTime.tryParse(map["date"]) ?? DateTime.now() 
            : (map["date"] is DateTime ? map["date"] : DateTime.now()),
      intensity: map["intensity"] ?? 0,
      durationMinutes: (map["duration_minutes"] as num?)?.toDouble() ?? 0.0,
      exercisesCompleted: map["exercises_completed"] ?? 0,
    );
  }

  // Method to convert HistoryItem instance to a map (useful for sending data)
  Map<String, dynamic> toMap() {
    return {
      "workout_id": workoutId,
      "date": date.toIso8601String(), // Use ISO 8601 format for consistency
      "intensity": intensity,
      "duration_minutes": durationMinutes,
      "exercises_completed": exercisesCompleted,
    };
  }
}

// Temporary UUID generation for default values - ideally use a proper UUID package
class uuid {
  static String v4() {
    // Basic pseudo-random UUID generation for mock purposes
    // Replace with a proper package like `uuid` in a real app
    final random = List<int>.generate(16, (i) => DateTime.now().millisecond % 256);
    random[6] = (random[6] & 0x0f) | 0x40; // Version 4
    random[8] = (random[8] & 0x3f) | 0x80; // Variant 1
    return random.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}

