// /home/ubuntu/fitpulse_ai/mobile/lib/models/exercise.dart

class Exercise {
  final String name;
  final int sets;
  final String reps; // Can be number or time, e.g., "10" or "30s"
  final String? videoUrl;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.videoUrl,
  });

  // Factory constructor to create an Exercise from a map (e.g., from API JSON)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map["name"] ?? "Unknown Exercise",
      sets: map["sets"] ?? 0,
      reps: map["reps"] ?? "0",
      videoUrl: map["video_url"],
    );
  }

  // Method to convert Exercise instance to a map (useful for sending data)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "sets": sets,
      "reps": reps,
      "video_url": videoUrl,
    };
  }
}

