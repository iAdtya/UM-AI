from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
import json
import os
from dotenv import load_dotenv
import google.generativeai as genai
from rest_framework import status
from .models import UserProfile, UserResponse

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
        
        # Save to UserProfile model
        user_profile = UserProfile.objects.create(
            name=user_data.get("name", "unknown"),
            age=user_data.get("age", ""),
            sex=user_data.get("sex", ""),
            location=user_data.get("location", ""),
            education=user_data.get("education", ""),
            professional_details=user_data.get("professionalDetails", "")
        )

        # Also save to JSON file (keeping existing functionality)
        file_path = os.path.join(BASE_DIR, "data", "users", f"{user_profile.name}_profile.json")
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

        # Get user profile
        user_profile = UserProfile.objects.get(name=name)

        # Save responses to UserResponse model
        for key, value in data["responses"].items():
            UserResponse.objects.create(
                user=user_profile,
                question=value["question"],
                answer=value["answer"]
            )

        # Also save to JSON file (keeping existing functionality)
        file_path = os.path.join(BASE_DIR, "data", "responses", f"{name}_responses.json")
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

        user_profile = UserProfile.objects.get(name=user_name)

        # Load user responses
        file_path = os.path.join(
            BASE_DIR, "data", "responses", f"{user_name}_responses.json"
        )
        with open(file_path, "r") as json_file:
            user_responses = json.load(json_file)

        # Create a more focused prompt
        style_analysis = """
        You are responding as a chatbot that matches this user's style. Their questionnaire showed:
        - They are casual and friendly: "{intro_style}"
        - They like talking to: "{convo_pref}"
        - They start conversations with: "{conv_starter}"
        
        Respond to this message briefly and naturally, matching their style: {message}
        Only provide the direct answer, no explanations, previous context needed.
        """.format(
            intro_style=user_responses["question1"]["answer"],
            convo_pref=user_responses["question2"]["answer"],
            conv_starter=user_responses["question4"]["answer"],
            message=user_message
        )

        # Generate response using Gemini API
        model = genai.GenerativeModel("gemini-1.5-flash")
        response = model.generate_content(style_analysis)
        
        UserResponse.objects.create(
            user=user_profile,
            question=user_message,
            answer=response.text.strip()
        )


        # Return just the generated response
        return Response({"response": response.text.strip()})
    except Exception as e:
        print(f"Error generating response: {e}")
        return Response({"error": str(e)}, status=500)
    

@api_view(['GET'])
def get_all_users(request):
    try:
        users = UserProfile.objects.all()
        data = [{
            'id': user.id,
            'name': user.name,
            'age': user.age,
            'location': user.location,
            'created_at': user.created_at
        } for user in users]
        return Response(data)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
def get_user_responses(request, user_id):
    try:
        responses = UserResponse.objects.filter(user_id=user_id)
        data = [{
            'question': response.question,
            'answer': response.answer,
            'created_at': response.created_at
        } for response in responses]
        return Response(data)
    except Exception as e:
        return Response({'error': str(e)}, status=500)