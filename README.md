# UM-AI-BOT

The application simulate a "Digital Twin" that can
mimic a user's conversational style and provide responses to incoming messages

## System Design

![system design](/umbot/sys.png)

``Data Collection``

- User profile data is stored via UserProfile
- Communication preferences are captured through questionnaire responses in UserResponse

``In Context Learning``

```python
style_analysis = """
        You are responding as a chatbot that matches this user's style. Their questionnaire showed:
        - They are casual and friendly: "{intro_style}"
        - They like talking to: "{convo_pref}"
        - They start conversations with: "{conv_starter}"
        Respond to this message briefly and naturally, matching their style: {message}
        Only provide the direct answer, no explanations, previous context needed.
"""
```

``Generate response using Gemini API``

```python
model = genai.GenerativeModel("gemini-1.5-flash")
response = model.generate_content(style_analysis)
```

## Improvements

- Implement Federated Learing to improve response accuracy based on users personality
- securely fine-tune large language models with private data using federated learning
  
## Backend

```sh
cd Backend
```

```sh
pip install -r requirements.txt
```

```sh
cp .env.example .env
```

```sh
python manage.py runserver
```

## Frontend

```sh
flutter pub get
```

- try sticking to chrome browsers

```sh
flutter run 
```

## Create SuperUser for Admin page

```sh
cd Backend
python manage.py makemigrations
python manage.py migrate
```

```sh
python manage.py createsuperuser
```

- Username
- Email (optional)
- Password (will not be visible when typing)
- Password confirmation

``http://localhost:8000/admin/login/``

## Postman-API

Import ``um-bot.postman_collection.json`` in postman and test the api

## Output

![Questionnaire](/umbot/Questionnaire.png)

### the llm will automatical answer the text but you also can generate a response edit it and send

![Simulation](/umbot/Simulation.png)
![response](/umbot/response.png)
![admin](/umbot/admin.png)

### License

MIT License

Copyright (c) 2024 UMBOT
