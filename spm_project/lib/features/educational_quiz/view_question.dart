import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'database_helper.dart';
import 'question.dart';

class ViewQuestionScreen extends StatefulWidget {
  const ViewQuestionScreen({super.key});

  @override
  State<ViewQuestionScreen> createState() => _ViewQuestionScreenState();
}

class _ViewQuestionScreenState extends State<ViewQuestionScreen> {
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

  Future<void> _generateReport(List<Question> questions) async {
    try {
      StringBuffer buffer = StringBuffer();
      buffer.writeln('Question,Option 1,Option 2,Correct Answer');

      for (var question in questions) {
        buffer.writeln(
          '"${question.question}","${question.answer1}","${question.answer2}","${question.correctAnswer}"',
        );
      }

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-'); // Ensure valid filename
      final filePath = '${directory.path}/questions_report_$timestamp.csv';

      final file = File(filePath);
      await file.writeAsString(buffer.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report generated at: $filePath'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              await OpenFile.open(filePath);
            },
          ),
        ),
      );
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Questions"),
        automaticallyImplyLeading: true,
        actions: [
          FutureBuilder<List<Question>>(
            future: _questionsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    _generateReport(snapshot.data!);
                  },
                );
              }
              return Container();
            },
          ),
        ],
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
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
