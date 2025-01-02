from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
import json
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


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
        
        file_path = os.path.join(BASE_DIR, "data", "responses", f"{name}_responses.json")
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        
        with open(file_path, "w") as json_file:
            json.dump(data["responses"], json_file, indent=4)
        
        return Response({"message": "Questionnaire data saved successfully!"})
    except Exception as e:
        return Response({"error": str(e)}, status=500)