# UM-AI-BOT

The application should simulate a "Digital Twin" that can
mimic a user's conversational style and provide responses to incoming messages

## System Design

![system design](/umbot/sys.png)

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

- the llm will automatical answer the text but you also can generate a response edit it and send
![Simulation](/umbot/Simulation.png)
![response](/umbot/response.png)
![admin](/umbot/admin.png)

### License

MIT License

Copyright (c) 2024 UMBOT

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE