import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartPage extends StatelessWidget {
  final TextEditingController channelController = TextEditingController();

  StartPage({super.key});

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
                decoration: const InputDecoration(
                  labelText: 'Enter a 8 digit number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () =>
                    context.go('/video_conf', extra: channelController.text),
                child: const Text('Create video conference'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
