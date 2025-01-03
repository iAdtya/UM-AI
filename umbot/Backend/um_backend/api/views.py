from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
import json
import os
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

genai_api_key = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=genai_api_key)


@api_view(["GET"])
def health_check(request):
    return Response({"healthy": "server healthy!!"})


@api_view(["POST"])
def save_user_data(request):
    try:
        user_data = request.data
        name = user_data.get("name", "unknown")

        file_path = os.path.join(BASE_DIR, "data", "users", f"{name}_profile.json")
        os.makedirs(os.path.dirname(file_path), exist_ok=True)

        with open(file_path, "w") as json_file:
            json.dump(user_data, json_file, indent=4)

        return Response({"message": "User data saved successfully!"})
    except Exception as e:
        return Response({"error": str(e)}, status=500)


@api_view(["POST"])
def save_questionnaire(request):
    try:
        data = request.data
        name = data.get("name", "unknown")

        file_path = os.path.join(
            BASE_DIR, "data", "responses", f"{name}_responses.json"
        )
        os.makedirs(os.path.dirname(file_path), exist_ok=True)

        with open(file_path, "w") as json_file:
            json.dump(data["responses"], json_file, indent=4)

        return Response({"message": "Questionnaire data saved successfully!"})
    except Exception as e:
        return Response({"error": str(e)}, status=500)


@api_view(["POST"])
def generate_message_response(request):
    try:
        user_message = request.data.get("message", "")
        user_name = request.data.get("name", "unknown")

        # Load user responses to mimic their conversational style
        file_path = os.path.join(
            BASE_DIR, "data", "responses", f"{user_name}_responses.json"
        )
        with open(file_path, "r") as json_file:
            user_responses = json.load(json_file)

        # Generate a response using the Gemini API
        model = genai.GenerativeModel("gemini-1.5-flash")
        prompt = f"{user_message}\n\nUser's conversational style based on their responses: {user_responses}"
        response = model.generate_content(prompt)

        return Response({"response": response.text})
    except Exception as e:
        return Response({"error": str(e)}, status=500)
