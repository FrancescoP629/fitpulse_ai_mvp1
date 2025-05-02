# /home/ubuntu/fitpulse_ai/backend/app/main.py

from fastapi import FastAPI
# Import routers from the routers directory
from .routers import auth, workout, posture, history
# Dependencies are now loaded/managed within routers or the dependencies module

# --- App Initialization ---=
app = FastAPI(
    title="FitPulse AI Backend API",
    version="0.1.1", # Incremented version for improvements
    description="API for the FitPulse AI mobile app, now with improved structure."
)

# --- Include Routers ---=
# Include the routers defined in separate files
app.include_router(auth.router)
app.include_router(workout.router)
app.include_router(posture.router)
app.include_router(history.router)

# --- Root Endpoint (Optional) ---=
@app.get("/", tags=["Root"])
async def read_root():
    """Basic API root endpoint providing a welcome message."""
    return {"message": "Welcome to the FitPulse AI API! Go to /docs for documentation."}

# --- Removed Old Code ---=
# The endpoint definitions previously here (@app.post("/auth/signup"...), 
# @app.post("/workout"...), @app.post("/posture/frame"...), @app.get("/history"...))
# have been moved to their respective router files in the ./routers/ directory.
# The ONNX model loading and authentication dependency (get_current_user) 
# have been moved to the ./dependencies.py file and are used by the routers.

