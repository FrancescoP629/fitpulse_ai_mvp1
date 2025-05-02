// /home/ubuntu/fitpulse_ai/mobile/lib/services/api_service.dart

import "dart:convert";
import "dart:math";
import "package:http/http.dart" as http;
import "../models/exercise.dart";
import "../models/history_item.dart";
// Import other necessary models like PostureResponse, WorkoutResponse if defined

class ApiService {
  // TODO: Replace with actual backend URL from environment variable or config
  final String _baseUrl = "http://localhost:8000"; // Default for local testing
  String? lastError;

  // --- Mock Data --- 
  final List<Exercise> _mockWorkoutExercises = [
    Exercise(name: "Warm-up Jog", sets: 1, reps: "5min"),
    Exercise(name: "Bodyweight Squats", sets: 3, reps: "12"),
    Exercise(name: "Push-ups", sets: 3, reps: "10"),
    Exercise(name: "Plank", sets: 3, reps: "30s"),
  ];

  final List<HistoryItem> _mockHistoryItems = List.generate(15, (index) => HistoryItem(
    workoutId: "uuid_${index}",
    date: DateTime.now().subtract(Duration(days: index * 2, hours: index * 3)),
    intensity: (index % 5) + 1,
    durationMinutes: 25.0 + (index * 1.5),
    exercisesCompleted: 4 + (index % 3),
  ));

  // --- Mock API Methods --- 

  Future<bool> login(String email, String password) async {
    lastError = null;
    print("ApiService: Attempting mock login for $email");
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (email == "test@example.com" && password == "password") {
      // In a real app, store the received token securely
      print("ApiService: Mock login successful");
      return true;
    } else {
      lastError = "Invalid credentials.";
      print("ApiService: Mock login failed");
      return false;
    }
    // Real implementation would look like:
    /*
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/token"), // Assuming a token endpoint
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"username": email, "password": password},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Store data["access_token"]
        return true;
      } else {
        lastError = "Login failed: ${response.reasonPhrase}";
        return false;
      }
    } catch (e) {
      lastError = "Login error: $e";
      return false;
    }
    */
  }

  Future<List<Exercise>> getWorkout(/* Pass necessary params like user_id, previous data */) async {
    lastError = null;
    print("ApiService: Fetching mock workout");
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // In a real app, make a POST request to /workout
    // final response = await http.post(Uri.parse("$_baseUrl/workout"), body: jsonEncode({...}));
    // final data = jsonDecode(response.body);
    // final List<dynamic> exerciseList = data["exercises"];
    // return exerciseList.map((item) => Exercise.fromMap(item)).toList();
    return _mockWorkoutExercises;
  }

  Future<List<HistoryItem>> getHistory(/* Pass user_id, limit, offset */) async {
    lastError = null;
    print("ApiService: Fetching mock history");
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // In a real app, make a GET request to /history?user_id=...
    // final response = await http.get(Uri.parse("$_baseUrl/history?..."));
    // final data = jsonDecode(response.body);
    // final List<dynamic> historyList = data["history"];
    // return historyList.map((item) => HistoryItem.fromMap(item)).toList();
    return _mockHistoryItems;
  }

  Future<Map<String, dynamic>> analyzePostureFrame(
      /* Pass image data, user_id, exercise_id */
      String userId, String exerciseId, /* http.MultipartFile imageFile */
      ) async {
    lastError = null;
    print("ApiService: Analyzing mock posture frame for user $userId, exercise $exerciseId");
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate processing delay

    // Mock response generation
    final random = Random();
    double mockScore = random.nextDouble();
    String? mockFeedback;
    if (mockScore < 0.5) {
      mockFeedback = "Try to keep your back straighter.";
    } else if (mockScore > 0.9) {
      mockFeedback = "Great form!";
    }

    // In a real app, construct a multipart request and send to /posture/frame
    /*
    try {
      var request = http.MultipartRequest("POST", Uri.parse("$_baseUrl/posture/frame"));
      request.fields["user_id"] = userId;
      request.fields["exercise_id"] = exerciseId;
      request.files.add(imageFile); // http.MultipartFile
      // Add authorization header if needed
      // request.headers["Authorization"] = "Bearer YOUR_TOKEN";

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Returns { "posture_score": float, "feedback_message": str | null }
      } else {
        lastError = "Posture analysis failed: ${response.reasonPhrase}";
        throw Exception(lastError);
      }
    } catch (e) {
      lastError = "Posture analysis error: $e";
      throw Exception(lastError);
    }
    */

    return {
      "posture_score": mockScore,
      "feedback_message": mockFeedback,
    };
  }
}

