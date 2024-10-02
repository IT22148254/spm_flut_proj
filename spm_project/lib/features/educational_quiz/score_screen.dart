import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final int total;

  const ScoreScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Score"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Score: $score out of $total",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Navigate back to UserDashboard
              },
              child: const Text("Back to Dashboard"),
            ),
          ],
        ),
      ),
    );
  }
}
