import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else {
      return 'http://localhost:8000';
    }
  }

  static Future<bool> saveUserData(Map<String, String> userData) async {
    try {
      print('Sending user data to: ${baseUrl}/save_user_data/');
      final response = await http.post(
        Uri.parse('${baseUrl}/save_user_data/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(userData),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  static Future<bool> saveQuestionnaireData(
      Map<String, dynamic> data, List<String> questions) async {
    try {
      Map<String, dynamic> questionnaireData = {
        'name': data['name'],
        'responses': data['responses'].map((key, value) => MapEntry(key, {
              'question':
                  questions[int.parse(key.replaceAll('question', '')) - 1],
              'answer': value,
            })),
      };

      print('Sending questionnaire data to: ${baseUrl}/save_questionnaire/');
      final response = await http.post(
        Uri.parse('${baseUrl}/save_questionnaire/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(questionnaireData),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error saving questionnaire data: $e');
      return false;
    }
  }
}
