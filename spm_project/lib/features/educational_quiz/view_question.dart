import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
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

  Future<void> _generatePdfReport(List<Question> questions) async {
    try {
      final pdf = pw.Document();

      // Add a title and content to the PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Questions Report',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Question', 'Option 1', 'Option 2', 'Correct Answer'],
                  data: questions.map((q) {
                    return [q.question, q.answer1, q.answer2, q.correctAnswer];
                  }).toList(),
                ),
              ],
            );
          },
        ),
      );

      // Save the PDF to a file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filePath = '${directory.path}/questions_report_$timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Show a message and provide an option to open the file
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF report generated at: $filePath'),
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
        SnackBar(content: Text('Failed to generate PDF report: $e')),
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
                return Row(
                  children: [
                    Text("Total: ${snapshot.data!.length}"), // Display the total count
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        _generatePdfReport(snapshot.data!);
                      },
                    ),
                  ],
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
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
