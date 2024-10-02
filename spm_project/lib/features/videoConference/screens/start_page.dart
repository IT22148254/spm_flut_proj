import 'dart:math'; // Import for generating random numbers
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:share_plus/share_plus.dart'; // Import for sharing functionality

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final TextEditingController channelController = TextEditingController();
  String _randomNumber = '';

  @override
  void initState() {
    super.initState();
    _generateRandomNumber(); // Generate random number on init
  }

  void _generateRandomNumber() {
    final random = Random();
    _randomNumber = (random.nextInt(90000000) + 10000000).toString(); // Generate 8-digit number
    channelController.text = _randomNumber; // Set the text field to the generated number
    setState(() {}); // Update UI
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _randomNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  void _shareNumber() {
    Share.share('Here is my room number: $_randomNumber'); // Share the number
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.go('/options');
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: const Text(
            'Create the video conference',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: channelController,
                readOnly: true, // Make the text field read-only
                decoration: const InputDecoration(
                  labelText: 'Generated 8 digit number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/video_conf', extra: channelController.text);
                },
                child: const Text('Create video conference'),
              ),
            ),
            const SizedBox(height: 20), // Add some space
            ElevatedButton(
              onPressed: () {
                _copyToClipboard();
                _shareNumber();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Share Room Number'),
            ),
          ],
        ),
      ),
    );
  }
}
