# /home/ubuntu/fitpulse_ai/backend/app/routers/workout.py

from fastapi import APIRouter, Depends, HTTPException
import uuid
import numpy as np
import onnxruntime as rt
from typing import List
from .. import models
# Import dependencies from the central dependencies file
from ..dependencies import get_current_user, get_onnx_session

router = APIRouter(
    prefix="/workout",
    tags=["Workouts"],
    dependencies=[Depends(get_current_user)] # Apply auth to all routes in this router
)

@router.post("", response_model=models.WorkoutResponse)
async def get_next_workout(
    workout_request: models.WorkoutRequest,
    onnx_session: rt.InferenceSession | None = Depends(get_onnx_session)
    # current_user is implicitly available due to router dependency
):
    """Generate the next personalized workout (mock implementation with basic ONNX inference)."""
    # user_id = current_user["user_id"] # Can get user_id from dependency if needed
    print(f"Workout request for user: {workout_request.user_id}")
    print(f"Previous session data: {workout_request.previous_session_data}")

    predicted_intensity = 3 # Default intensity

    if onnx_session:
        try:
            input_data = workout_request.previous_session_data
            input_array = np.array([[
                input_data.previous_intensity,
                input_data.user_feedback,
                input_data.session_duration_minutes,
                input_data.avg_exercise_difficulty
            ]], dtype=np.float32)

            input_name = onnx_session.get_inputs()[0].name
            output_name = onnx_session.get_outputs()[0].name

            prediction = onnx_session.run([output_name], {input_name: input_array})[0]
            predicted_intensity = int(prediction[0])
            predicted_intensity = max(1, min(5, predicted_intensity))
            print(f"Intensity predicted by ONNX model: {predicted_intensity}")

        except Exception as e:
            print(f"Error during ONNX inference: {e}. Using default intensity.")
            # Consider raising an HTTPException or logging more formally
            predicted_intensity = 3
    else:
        print("ONNX model not loaded. Using default intensity.")

    # Mock logic to generate exercises based on intensity
    # TODO: Move this logic to a separate service/utility function
    exercises = []
    if predicted_intensity <= 2:
        exercises = [
            models.Exercise(name="Warm-up Jog", sets=1, reps="5min", video_url=None),
            models.Exercise(name="Bodyweight Squats", sets=3, reps="12", video_url=None),
            models.Exercise(name="Push-ups (knees)", sets=3, reps="10", video_url=None),
            models.Exercise(name="Plank", sets=3, reps="30s", video_url=None),
        ]
    elif predicted_intensity == 3:
         exercises = [
            models.Exercise(name="Jumping Jacks", sets=1, reps="2min", video_url=None),
            models.Exercise(name="Lunges", sets=3, reps="10 per leg", video_url=None),
            models.Exercise(name="Push-ups", sets=3, reps="12", video_url=None),
            models.Exercise(name="Crunches", sets=3, reps="15", video_url=None),
        ]
    else: # Intensity 4-5
        exercises = [
            models.Exercise(name="Burpees", sets=3, reps="10", video_url=None),
            models.Exercise(name="Pull-ups (assisted or band)", sets=3, reps="8", video_url=None),
            models.Exercise(name="Squat Jumps", sets=3, reps="15", video_url=None),
            models.Exercise(name="Hanging Leg Raises", sets=3, reps="12", video_url=None),
        ]

    workout_id = uuid.uuid4()
    return models.WorkoutResponse(
        workout_id=workout_id,
        predicted_intensity=predicted_intensity,
        exercises=exercises
    )

