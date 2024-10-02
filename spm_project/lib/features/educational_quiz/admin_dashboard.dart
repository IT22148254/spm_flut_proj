// lib/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'add_question.dart';
import 'view_question.dart';
import 'manage_question.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        automaticallyImplyLeading: true, // This shows the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Admin Dashboard!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddQuestionScreen(),
                  ),
                );
              },
              child: const Text('Add Questions'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewQuestionScreen(),
                  ),
                );
              },
              child: const Text('View Questions'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageQuestionScreen(),
                  ),
                );
              },
              child: const Text('Manage Questions'),
            ),
          ],
        ),
      ),
    );
  }
}
