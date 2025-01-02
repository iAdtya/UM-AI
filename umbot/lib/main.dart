import 'package:flutter/material.dart';
import 'api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UM-AI Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _userData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Onboarding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _userData['name'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                onSaved: (value) => _userData['age'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sex'),
                onSaved: (value) => _userData['sex'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                onSaved: (value) => _userData['location'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Education'),
                onSaved: (value) => _userData['education'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Professional Details'),
                onSaved: (value) => _userData['professionalDetails'] = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionnaireScreen(userData: _userData),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class QuestionnaireScreen extends StatefulWidget {
  final Map<String, String> userData;
  const QuestionnaireScreen({super.key, required this.userData});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _responses = {};

  @override
  Widget build(BuildContext context) {
    final List<String> questions = [
      'How do you introduce yourself to new people?',
      'What kind of people do you like to talk to?',
      'How would you politely decline an offer youre not interested in?',
      'What\'s your favorite way to start a conversation?',
      'How do you respond to compliments?',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questionnaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ...questions.asMap().entries.map((entry) {
                return ListTile(
                  title: Text(entry.value),
                  subtitle: TextFormField(
                    decoration: const InputDecoration(labelText: 'Your response'),
                    onSaved: (value) {
                      _responses['question${entry.key + 1}'] = value ?? '';
                    },
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  
                  // Save user data
                  bool userDataSaved = await ApiService.saveUserData(widget.userData);
                  
                  // Save questionnaire data
                  Map<String, dynamic> questionnaireData = {
                    'name': widget.userData['name'],
                    'responses': _responses,
                  };
                  bool questionnaireSaved = await ApiService.saveQuestionnaireData(questionnaireData,questions);

                  if (userDataSaved && questionnaireSaved) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data saved successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error saving data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}