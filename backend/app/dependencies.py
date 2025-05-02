# /home/ubuntu/fitpulse_ai/backend/app/dependencies.py

from fastapi import Depends, HTTPException, Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import onnxruntime as rt
import os

# --- Security (Placeholder) ---=
# In a real app, implement proper JWT authentication
auth_scheme = HTTPBearer()

def get_current_user(credentials: HTTPAuthorizationCredentials = Security(auth_scheme)) -> dict:
    """Placeholder dependency to simulate user authentication."""
    # Placeholder: verify dummy token
    if credentials.scheme != "Bearer" or credentials.credentials != "fake-token":
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    # In a real app, it would decode the token and return the user ID or user object
    # For mock purposes, return a dictionary with a placeholder ID
    return {"user_id": "user-placeholder-id"}

# --- ONNX Model Loading ---=
MODEL_PATH = "/home/ubuntu/fitpulse_ai/backend/model/intensity_model.onnx"
onnx_session = None

def load_onnx_model():
    """Loads the ONNX model into a global variable."""
    global onnx_session
    if os.path.exists(MODEL_PATH):
        try:
            onnx_session = rt.InferenceSession(MODEL_PATH)
            print(f"ONNX model loaded successfully from: {MODEL_PATH}")
        except Exception as e:
            print(f"Error loading ONNX model: {e}")
            onnx_session = None # Ensure it's None if loading fails
    else:
        print(f"Warning: ONNX model file not found at {MODEL_PATH}. Dependent endpoints will use default values.")
        onnx_session = None

# Load the model when the module is imported
load_onnx_model()

def get_onnx_session() -> rt.InferenceSession | None:
    """Dependency to get the loaded ONNX session."""
    # This simply returns the global variable. 
    # Could be enhanced for more complex session management if needed.
    return onnx_session

