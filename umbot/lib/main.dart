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
                decoration:
                    const InputDecoration(labelText: 'Professional Details'),
                onSaved: (value) => _userData['professionalDetails'] = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuestionnaireScreen(userData: _userData),
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
      'How would you politely decline an offer you\'re not interested in?',
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
                    decoration:
                        const InputDecoration(labelText: 'Your response'),
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
                  bool userDataSaved =
                      await ApiService.saveUserData(widget.userData);

                  // Save questionnaire data
                  Map<String, dynamic> questionnaireData = {
                    'name': widget.userData['name'],
                    'responses': _responses,
                  };
                  bool questionnaireSaved =
                      await ApiService.saveQuestionnaireData(
                          questionnaireData, questions);

                  if (userDataSaved && questionnaireSaved) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data saved successfully!')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MessageScreen(userName: widget.userData['name']!),
                      ),
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

class MessageScreen extends StatefulWidget {
  final String userName;
  const MessageScreen({super.key, required this.userName});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageController = TextEditingController();
  List<Map<String, String>> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Simulation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['type'] == 'user';

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color:
                          isUserMessage ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(message['text']!),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _messageController,
                  key: const Key('messageInput'),
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          String botSuggestion =
                              await ApiService.generateMessageResponse(
                            "Generate a response for the next message",
                            widget.userName,
                          );
                          setState(() {
                            _messageController.text = botSuggestion;
                          });
                        },
                        child: const Text('Answer with AI'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_messageController.text.trim().isEmpty) return;

                          final userMessage = _messageController.text;
                          setState(() {
                            _messages.add({
                              'type': 'user',
                              'text': userMessage,
                            });
                            _messageController.clear();
                          });

                          String response =
                              await ApiService.generateMessageResponse(
                            userMessage,
                            widget.userName,
                          );

                          setState(() {
                            _messages.add({
                              'type': 'bot',
                              'text': response,
                            });
                          });
                        },
                        child: const Text('Send'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
