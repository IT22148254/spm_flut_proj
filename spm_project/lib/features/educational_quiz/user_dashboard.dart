import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import the flutter_tts package
import 'database_helper.dart'; // Import your database helper
import 'question.dart'; // Import your Question model
import 'score_screen.dart'; // Import the ScoreScreen
import 'package:go_router/go_router.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Question>> _questionsFuture;
  int currentQuestionIndex = 0;
  int score = 0;
  late FlutterTts flutterTts; // Declare a FlutterTts instance

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    flutterTts = FlutterTts(); // Initialize TTS
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
  }

  void _loadQuestions() {
    setState(() {
      _questionsFuture = _dbHelper.getQuestions();
    });
  }

  Future<void> _speak(String text) async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(text);
      await flutterTts.awaitSpeakCompletion(true); // Wait for completion before moving on
    } catch (e) {
      print("Error in speaking: $e");
    }
  }

  Future<void> _speakQuestionAndAnswers(Question currentQuestion) async {
    // Speak the current question and await completion
    await _speak("Question: ${currentQuestion.question}");

    // Speak the answer options and await completion for each
    await _speak("Here are the answer options:");
    await _speak("Option 1: ${currentQuestion.answer1}");
    await _speak("Option 2: ${currentQuestion.answer2}");
  }

  void _checkAnswer(String selectedAnswer, Question currentQuestion, List<Question> questions) async {
    // Speak the selected answer and await completion
    await _speak("You selected: $selectedAnswer");

    // Check if the selected answer is correct
    if (selectedAnswer == currentQuestion.correctAnswer) {
      setState(() {
        score++;
      });
    }

    // Move to the next question or show score dialog if it's the last question
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      // Speak the next question and answers
      await _speakQuestionAndAnswers(questions[currentQuestionIndex]);
    } else {
      _showScoreDialog();
    }
  }

  void _showScoreDialog() async {
  String scoreText;
  if (score == currentQuestionIndex + 1) {
    scoreText = "Excellent! You scored $score out of ${currentQuestionIndex + 1}.";
  } else if (score > (currentQuestionIndex + 1) / 2) {
    scoreText = "Good job! You scored $score out of ${currentQuestionIndex + 1}.";
  } else {
    scoreText = "You scored $score out of ${currentQuestionIndex + 1}. Better luck next time!";
  }
  
  await _speak(scoreText); // Announce the score

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Quiz Finished"),
        content: Text(scoreText),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
              });
              Navigator.of(context).pop(); // Close the dialog
              _speak("Welcome to the quiz. Let's start again!"); // Announce the restart
            },
            child: const Text("Retry"),
          ),
          TextButton(
            onPressed: () {
              // Navigate to the ScoreScreen and pass the score
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ScoreScreen(score: score, total: currentQuestionIndex + 1),
                ),
              );
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}


  void _onSingleTap(Question currentQuestion, List<Question> questions) {
    // Single-tap means the user selects Option 1
    _checkAnswer(currentQuestion.answer1, currentQuestion, questions);
  }

  void _onDoubleTap(Question currentQuestion, List<Question> questions) {
    // Double-tap means the user selects Option 2
    _checkAnswer(currentQuestion.answer2, currentQuestion, questions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.go('/');
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        title: const Text("User Dashboard"),
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
            final currentQuestion = questions[currentQuestionIndex];

            // Speak the current question and answers when the widget is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _speakQuestionAndAnswers(currentQuestion);
            });

            return GestureDetector(
              onTap: () {
                // Handle single-tap for Option 1
                _onSingleTap(currentQuestion, questions);
              },
              onDoubleTap: () {
                // Handle double-tap for Option 2
                _onDoubleTap(currentQuestion, questions);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display question number and text
                    Text(
                      "Question ${currentQuestionIndex + 1}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      currentQuestion.question,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Tap once for Option 1, Tap twice for Option 2.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    // Placeholder text for Option 1 and Option 2
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Option 1: ${currentQuestion.answer1}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Option 2: ${currentQuestion.answer2}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
