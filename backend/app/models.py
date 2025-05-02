# /home/ubuntu/fitpulse_ai/backend/app/models.py

from pydantic import BaseModel, EmailStr, Field
from typing import List, Optional
from uuid import UUID
import datetime

# --- Auth ---=
class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8)

class UserResponse(BaseModel):
    user_id: UUID
    message: str = "User created successfully" # Translated from Italian

# --- Workout ---=
class PreviousSessionData(BaseModel):
    previous_intensity: int = Field(..., ge=1, le=5)
    user_feedback: int = Field(..., ge=0, le=2) # 0: easy, 1: just right, 2: hard - Translated comment
    session_duration_minutes: float = Field(..., gt=0)
    avg_exercise_difficulty: float = Field(..., ge=1, le=5)

class WorkoutRequest(BaseModel):
    user_id: UUID
    previous_session_data: PreviousSessionData

class Exercise(BaseModel):
    name: str
    sets: int
    reps: str # Can be number or time, e.g., "10" or "30s" - Translated comment
    video_url: Optional[str] = None

class WorkoutResponse(BaseModel):
    workout_id: UUID
    predicted_intensity: int = Field(..., ge=1, le=5)
    exercises: List[Exercise]

# --- Posture ---=
# Note: The /posture/frame request uses multipart/form-data,
# so user_id and exercise_id fields will be passed as form data,
# and the image as a file. There isn't a direct Pydantic model for this
# in the JSON request body, but we define the response.

class PostureResponse(BaseModel):
    posture_score: float = Field(..., ge=0, le=1)
    feedback_message: Optional[str] = None

# --- History ---=
class HistoryItem(BaseModel):
    workout_id: UUID
    date: datetime.datetime
    intensity: int
    duration_minutes: float
    exercises_completed: int
    # Add other details if necessary

class HistoryResponse(BaseModel):
    history: List[HistoryItem]
    total_count: int

