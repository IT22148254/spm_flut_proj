// lib/add_question_screen.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'question.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answer1Controller = TextEditingController();
  final TextEditingController _answer2Controller = TextEditingController();
  String? _selectedCorrectAnswer;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void dispose() {
    _questionController.dispose();
    _answer1Controller.dispose();
    _answer2Controller.dispose();
    super.dispose();
  }

  void _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      String questionText = _questionController.text.trim();
      String answer1 = _answer1Controller.text.trim();
      String answer2 = _answer2Controller.text.trim();
      String correctAnswer = _selectedCorrectAnswer!;

      Question newQuestion = Question(
        question: questionText,
        answer1: answer1,
        answer2: answer2,
        correctAnswer: correctAnswer,
      );

      await _dbHelper.insertQuestion(newQuestion);

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question added successfully!')),
      );

      // Clear the form and reset state
      _formKey.currentState!.reset();
      _questionController.clear();
      _answer1Controller.clear();
      _answer2Controller.clear();
      setState(() {
        _selectedCorrectAnswer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Questions"),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Question Text Field
                TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Answer 1 Text Field
                TextFormField(
                  controller: _answer1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Answer 1',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the first answer';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Answer 2 Text Field
                TextFormField(
                  controller: _answer2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Answer 2',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the second answer';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Correct Answer Selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select the correct answer:',
                      style: TextStyle(fontSize: 16),
                    ),
                    RadioListTile<String>(
                      title: Text(
                        _answer1Controller.text.trim().isEmpty
                            ? 'Answer 1'
                            : _answer1Controller.text.trim(),
                      ),
                      value: _answer1Controller.text.trim().isEmpty
                          ? 'Answer 1'
                          : _answer1Controller.text.trim(),
                      groupValue: _selectedCorrectAnswer,
                      onChanged: (value) {
                        setState(() {
                          _selectedCorrectAnswer = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text(
                        _answer2Controller.text.trim().isEmpty
                            ? 'Answer 2'
                            : _answer2Controller.text.trim(),
                      ),
                      value: _answer2Controller.text.trim().isEmpty
                          ? 'Answer 2'
                          : _answer2Controller.text.trim(),
                      groupValue: _selectedCorrectAnswer,
                      onChanged: (value) {
                        setState(() {
                          _selectedCorrectAnswer = value;
                        });
                      },
                    ),
                    if (_selectedCorrectAnswer == null)
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Please select the correct answer',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                // Save Button
                ElevatedButton(
                  onPressed: _saveQuestion,
                  child: const Text('Save Question'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
