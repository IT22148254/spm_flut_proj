// lib/update_question_screen.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'question.dart';

class UpdateQuestionScreen extends StatefulWidget {
  final Question question;

  const UpdateQuestionScreen({super.key, required this.question});

  @override
  State<UpdateQuestionScreen> createState() => _UpdateQuestionScreenState();
}

class _UpdateQuestionScreenState extends State<UpdateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _answer1Controller;
  late TextEditingController _answer2Controller;
  String? _selectedCorrectAnswer;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _answer1Controller = TextEditingController(text: widget.question.answer1);
    _answer2Controller = TextEditingController(text: widget.question.answer2);
    _selectedCorrectAnswer = widget.question.correctAnswer;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answer1Controller.dispose();
    _answer2Controller.dispose();
    super.dispose();
  }

  void _updateQuestion() async {
    if (_formKey.currentState!.validate()) {
      String questionText = _questionController.text.trim();
      String answer1 = _answer1Controller.text.trim();
      String answer2 = _answer2Controller.text.trim();
      String correctAnswer = _selectedCorrectAnswer!;

      Question updatedQuestion = Question(
        id: widget.question.id, // Use the existing ID
        question: questionText,
        answer1: answer1,
        answer2: answer2,
        correctAnswer: correctAnswer,
      );

      await _dbHelper.updateQuestion(updatedQuestion);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question updated successfully!')),
      );

      // Navigate back after updating
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Question"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    title: Text(_answer1Controller.text),
                    value: _answer1Controller.text,
                    groupValue: _selectedCorrectAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedCorrectAnswer = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(_answer2Controller.text),
                    value: _answer2Controller.text,
                    groupValue: _selectedCorrectAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedCorrectAnswer = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Update Button
              ElevatedButton(
                onPressed: _updateQuestion,
                child: const Text('Update Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
