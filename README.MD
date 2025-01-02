# UM-AI

## Backend

```sh
cd Backend
```

```sh
python manage.py runserver
```

## Frontend

```sh
flutter run
```

# frontend/README.md

# Flutter Django Project

This project is a Flutter application that connects to a Django backend to collect and store user data through onboarding and questionnaire screens.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart
- Django
- Python 3.x

### Installation

1. Clone the repository:

   ```
   git clone <repository-url>
   cd flutter_django_project
   ```

2. Navigate to the frontend directory:

   ```
   cd frontend
   ```

3. Install Flutter dependencies:

   ```
   flutter pub get
   ```

4. Navigate to the backend directory:

   ```
   cd ../backend
   ```

5. Install Django dependencies (if using a virtual environment):
   ```
   pip install -r requirements.txt
   ```

### Running the Application

1. Start the Django backend server:

   ```
   python manage.py runserver
   ```

2. In a new terminal, navigate to the frontend directory and run the Flutter application:
   ```
   cd frontend
   flutter run
   ```

### Features

- User onboarding form to collect personal information.
- Questionnaire screen to gather user responses.
- Data is sent to the Django backend and stored in JSON format.

### API Endpoints

- `GET /health_check/`: Check the health status of the server.
- `POST /api/save_user_data/`: Save user data to JSON files.

### Contributing

Feel free to submit issues or pull requests for improvements or bug fixes.

### License

This project is licensed under the MIT License.
