# /home/ubuntu/fitpulse_ai/backend/tests/test_main.py

from fastapi.testclient import TestClient
from ..app.main import app # Importa l'app FastAPI
import uuid
import pytest
import os

# Crea un client di test
client = TestClient(app)

# --- Fixtures (Opzionale, ma utile per setup/teardown) ---=
@pytest.fixture(scope="module", autouse=True)
def setup_onnx_model():
    """Crea un finto modello ONNX se non esiste per i test."""
    MODEL_DIR = "/home/ubuntu/fitpulse_ai/backend/model"
    MODEL_PATH = os.path.join(MODEL_DIR, "intensity_model.onnx")
    if not os.path.exists(MODEL_PATH):
        os.makedirs(MODEL_DIR, exist_ok=True)
        # Crea un file vuoto o un semplice file ONNX fittizio se necessario
        # Per ora, un file vuoto è sufficiente per evitare l'errore FileNotFoundError
        # In un test reale, potresti voler usare un modello ONNX valido ma semplice.
        with open(MODEL_PATH, "w") as f:
            f.write("fake_onnx_content") 
        print(f"Creato file ONNX fittizio per test: {MODEL_PATH}")
    yield # Esegue i test
    # Cleanup (opzionale)
    # if os.path.exists(MODEL_PATH) and "fake_onnx_content" in open(MODEL_PATH).read():
    #     os.remove(MODEL_PATH)
    #     print(f"Rimosso file ONNX fittizio: {MODEL_PATH}")

# --- Test Cases ---=

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Benvenuto nell'API FitPulse AI! Vai su /docs per la documentazione."}

def test_signup():
    user_email = f"testuser_{uuid.uuid4()}@example.com"
    response = client.post(
        "/auth/signup",
        json={"email": user_email, "password": "testpassword123"}
    )
    assert response.status_code == 201
    data = response.json()
    assert "user_id" in data
    assert data["message"] == "Utente creato con successo"
    try:
        uuid.UUID(data["user_id"])
    except ValueError:
        pytest.fail("user_id non è un UUID valido")

# Test per /workout (richiede autenticazione fittizia)
def test_get_next_workout():
    user_id = uuid.uuid4()
    request_data = {
        "user_id": str(user_id),
        "previous_session_data": {
            "previous_intensity": 3,
            "user_feedback": 1,
            "session_duration_minutes": 30.5,
            "avg_exercise_difficulty": 2.5
        }
    }
    headers = {"Authorization": "Bearer fake-token"}
    response = client.post("/workout", json=request_data, headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert "workout_id" in data
    assert "predicted_intensity" in data
    assert "exercises" in data
    assert isinstance(data["exercises"], list)
    assert data["predicted_intensity"] >= 1 and data["predicted_intensity"] <= 5

def test_get_next_workout_unauthorized():
    user_id = uuid.uuid4()
    request_data = {
        "user_id": str(user_id),
        "previous_session_data": {
            "previous_intensity": 3,
            "user_feedback": 1,
            "session_duration_minutes": 30.5,
            "avg_exercise_difficulty": 2.5
        }
    }
    response = client.post("/workout", json=request_data) # Senza header
    assert response.status_code == 403 # FastAPI restituisce 403 per dipendenze di sicurezza fallite

# Test per /posture/frame (richiede autenticazione fittizia e upload file)
def test_analyze_posture():
    user_id = uuid.uuid4()
    exercise_id = "squat_1"
    headers = {"Authorization": "Bearer fake-token"}
    # Crea un file fittizio in memoria
    fake_image_content = b"fake image data"
    files = {"frame_image": ("test_image.jpg", fake_image_content, "image/jpeg")}
    data = {"user_id": str(user_id), "exercise_id": exercise_id}
    
    response = client.post("/posture/frame", data=data, files=files, headers=headers)
    
    assert response.status_code == 200
    result = response.json()
    assert "posture_score" in result
    assert isinstance(result["posture_score"], float)
    assert result["posture_score"] >= 0 and result["posture_score"] <= 1
    # feedback_message è opzionale
    assert "feedback_message" in result 

def test_analyze_posture_unauthorized():
    user_id = uuid.uuid4()
    exercise_id = "squat_1"
    fake_image_content = b"fake image data"
    files = {"frame_image": ("test_image.jpg", fake_image_content, "image/jpeg")}
    data = {"user_id": str(user_id), "exercise_id": exercise_id}
    
    response = client.post("/posture/frame", data=data, files=files) # Senza header
    assert response.status_code == 403

# Test per /history (richiede autenticazione fittizia)
def test_get_workout_history():
    user_id = uuid.uuid4()
    headers = {"Authorization": "Bearer fake-token"}
    response = client.get(f"/history?user_id={user_id}&limit=10", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert "history" in data
    assert "total_count" in data
    assert isinstance(data["history"], list)
    # Verifica che il numero di elementi restituiti sia al massimo 'limit'
    assert len(data["history"]) <= 10 

def test_get_workout_history_unauthorized():
    user_id = uuid.uuid4()
    response = client.get(f"/history?user_id={user_id}") # Senza header
    assert response.status_code == 403


