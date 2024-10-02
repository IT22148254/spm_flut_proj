// lib/manage_question_screen.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'question.dart';
import 'update_question_screen.dart'; // Import the UpdateQuestionScreen

class ManageQuestionScreen extends StatefulWidget {
  const ManageQuestionScreen({super.key});

  @override
  State<ManageQuestionScreen> createState() => _ManageQuestionScreenState();
}

class _ManageQuestionScreenState extends State<ManageQuestionScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Question>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _refreshQuestions();
  }

  void _refreshQuestions() {
    setState(() {
      _questionsFuture = _dbHelper.getQuestions();
    });
  }

  void _deleteQuestion(int id) async {
    await _dbHelper.deleteQuestion(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question deleted successfully!')),
    );
    _refreshQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Questions"),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available.'));
          } else {
            List<Question> questions = snapshot.data!;
            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                Question question = questions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4, // Adds shadow to the card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('1. ${question.answer1}'),
                          Text('2. ${question.answer2}'),
                          const SizedBox(height: 10),
                          Text(
                            'Correct Answer: ${question.correctAnswer}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Edit and Delete buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Navigate to UpdateQuestionScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateQuestionScreen(
                                        question: question,
                                      ),
                                    ),
                                  ).then((_) {
                                    _refreshQuestions(); // Refresh the list after update
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteQuestion(question.id!);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
