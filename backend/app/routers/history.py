# /home/ubuntu/fitpulse_ai/backend/app/routers/history.py

from fastapi import APIRouter, Depends, HTTPException, Query
import uuid
import datetime
import numpy as np
from typing import List
from .. import models
# Import the dependency function from the central dependencies file
from ..dependencies import get_current_user

router = APIRouter(
    prefix="/history",
    tags=["History"],
    dependencies=[Depends(get_current_user)] # Apply auth to all routes in this router
)

@router.get("", response_model=models.HistoryResponse)
async def get_workout_history(
    # Instead of user_id as query param, get it from the token
    # user_id: UUID = Query(...), 
    limit: int = Query(20, ge=1, le=100), # Add validation for limit
    offset: int = Query(0, ge=0), # Add validation for offset
    current_user: dict = Depends(get_current_user) # Inject authenticated user
):
    """Retrieve workout history (mock implementation)."""
    user_id_from_token = current_user["user_id"] # Use user_id from the token
    print(f"History request for user: {user_id_from_token}, limit: {limit}, offset: {offset}")

    # Mock logic to retrieve history (no DB yet)
    # Generate a consistent set of mock data for pagination testing
    total_mock_items = 50 # Dummy total count
    all_mock_items = [
        models.HistoryItem(
            workout_id=uuid.uuid4(),
            date=datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=i),
            intensity=np.random.randint(1, 6),
            duration_minutes=np.random.uniform(20, 45),
            exercises_completed=np.random.randint(4, 8)
        ) for i in range(total_mock_items)
    ]

    # Apply pagination
    start_index = offset
    end_index = offset + limit
    paginated_history = all_mock_items[start_index:end_index]

    return models.HistoryResponse(history=paginated_history, total_count=total_mock_items)

