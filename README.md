# FitPulse AI - Adaptive Mobile Fitness Coach (MVP)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python Version](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/)
[![Flutter Version](https://img.shields.io/badge/flutter-3.x-blue.svg)](https://flutter.dev/)
[![Backend Framework](https://img.shields.io/badge/backend-FastAPI-green.svg)](https://fastapi.tiangolo.com/)
[![CI Status](https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>/actions/workflows/ci.yml/badge.svg)](https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>/actions/workflows/ci.yml) <!-- Update with real URL -->

FitPulse AI is a Minimum Viable Product (MVP) of a mobile fitness app aiming to provide personalized daily workouts using smartphone sensor data, camera-based posture analysis, and wearable data (post-MVP).

**(Placeholder for Demo GIF)**

<!-- Insert GIF showing the app in action here -->

## ✨ Features (MVP)

*   **Personalized Workouts (Mock):** Generates a daily exercise list based on a mock ONNX model considering user feedback and previous session data.
*   **Posture Analysis (Mock):** Simulates posture analysis by sending camera frames to a mock backend endpoint.
*   **History Tracking (Mock):** Displays a mock history of completed workouts.
*   **Backend API:** RESTful API built with FastAPI (Python) to manage users, workouts, posture, and history (now structured with routers).
*   **Mobile App:** Cross-platform UI built with Flutter (Dart) (now using model classes).
*   **Sensor Integration:** Uses `sensors_plus` to access the accelerometer.
*   **AI Model (Mock):** A simple ONNX model (trained on mock data) for intensity adjustment.
*   **CI/CD:** GitHub Actions workflow for linting (placeholder), testing (pytest), and Docker build of the backend.

## 🚀 Quick Start

### Prerequisites

*   Python 3.11+
*   Flutter SDK 3.x+
*   Docker & Docker Compose
*   Render.com Account (for deployment)

### Backend Setup (Local)

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/
    ```
2.  **Create and activate a virtual environment (recommended):**
    ```bash
    python3 -m venv backend/venv
    source backend/venv/bin/activate 
    # On Windows: backend\venv\Scripts\activate
    ```
3.  **Install dependencies:**
    ```bash
    pip install -r backend/requirements.txt
    ```
4.  **(Optional) Train the mock ONNX model:**
    *   Install additional dependencies: `pip install scikit-learn joblib pandas onnx skl2onnx`
    *   Run the notebook (or an equivalent script): `python notebooks/train_intensity_model_script.py` (assuming script creation from notebook)
5.  **Start the PostgreSQL database (using Docker Compose):**
    ```bash
    docker-compose up -d db 
    ```
6.  **Configure environment variables:**
    *   Copy `backend/.env.example` to `backend/.env`.
    *   Modify `backend/.env` with the database credentials (from `docker-compose.yml` for local environment).
    ```dotenv
    # backend/.env
    DATABASE_URL=postgresql://user:password@localhost:5432/fitpulsedb 
    # SECRET_KEY=your_jwt_secret_key # Add if implementing JWT
    ```
7.  **Start the FastAPI server:**
    ```bash
    cd backend
    uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
    ```
    The API will be accessible at `http://localhost:8000` and the documentation at `http://localhost:8000/docs`.

### Mobile App Setup (Local)

1.  **Navigate to the mobile directory:**
    ```bash
    cd ../mobile 
    ```
2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Update Backend URL:**
    *   Modify the `_baseUrl` variable in `lib/services/api_service.dart` to point to your local backend (`http://<YOUR_LOCAL_IP>:8000` - not `localhost` if using a physical device).
4.  **Run the app on an emulator or device:**
    ```bash
    flutter run
    ```

### Deployment

Refer to the Render.com deployment instructions in the `phase6_deliverable.md` file or follow the steps outlined in section 6.1 of that file.

## 🛠️ Tech Stack

*   **Backend:** Python, FastAPI, PostgreSQL, ONNX Runtime
*   **Mobile:** Dart, Flutter
*   **AI/ML:** Scikit-learn (for mock training), ONNX
*   **CI/CD:** GitHub Actions
*   **Hosting:** Render.com

##  Project Phases (MVP)

*   ✅ **Phase 0:** Requirements Recap
*   ✅ **Phase 1:** Architecture
*   ✅ **Phase 2:** AI / Modeling (Mock)
*   ✅ **Phase 3:** Backend API (FastAPI)
*   ✅ **Phase 4:** Mobile App (Flutter Mock)
*   ✅ **Phase 5:** Monetisation Logic (Description)
*   ✅ **Phase 6:** Deploy & README
*   ✅ **Phase 7:** Next Steps
*   ✅ **Phase 8:** Translate Project to English
*   ✅ **Phase 9:** Improve Project Implementation

## 🤝 Contributing

Contributions are welcome! Please open an issue to discuss proposed changes or submit a pull request.

1.  Fork the Project.
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the Branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📧 Contact

Project Link: https://github.com/FrancescoP629/fitpulse_ai_mvp1

