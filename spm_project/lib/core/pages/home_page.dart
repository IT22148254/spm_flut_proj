import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spm_project/core/services/speech_to_text_service.dart';
import 'dart:ui';
import 'package:logger/logger.dart';
import 'package:spm_project/di/injectable.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late MySpeechToTextService _speechService;
  Logger logger = getit<Logger>();
  UserCredential? userCredential;

  @override
  void initState() {
    super.initState();
    _speechService = getit<MySpeechToTextService>();
    _speechService.initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: appbar(),
        body: Column(
          children: [
            SizedBox(height: screenSize.height * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: screenSize.height * 0.4,
                  width: screenSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/quiz');
                              },
                              style: const ButtonStyle(),
                              child: const Text("Educational quiz"),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/admin');
                              },
                              style: const ButtonStyle(),
                              child: const Text("quiz admin db"),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/notes');
                              },
                              style: const ButtonStyle(),
                              child: const Text("Voice notes"),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/options');
                              },
                              style: const ButtonStyle(),
                              child: const Text("Classroom"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    if (userCredential != null &&
                        userCredential!.user!.email == 'admin@gmail.com') {
                      context.go('/admin');
                    } else {
                      showOverlay(context);
                      startListeningAndNavigate();
                    }
                  },
                  child: Container(
                    height: screenSize.height * 0.41,
                    width: screenSize.width * 0.96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.grey[300],
                    ),
                    child: const Center(
                      child: Text(
                        "Tapping controller area",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      title: const Text(
        'Homepage',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      elevation: 0,
    );
  }

  void showOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // Use a unique key to ensure that we can close this dialog later
        final dialogContext = context;

        // Automatically close the dialog after 20 seconds
        Future.delayed(const Duration(seconds: 6), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop(); // Close the dialog
          }
        });

        return Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black
                    .withOpacity(0.5), // Semi-transparent background
              ),
            ),
            // Overlay content
            Center(
              child: Image.asset('assets/images/bird_logo.png'),
            ),
          ],
        );
      },
    );
  }

  void startListeningAndNavigate() async {
    await _speechService.startListening((String result) {
      logger.i(result);
      if (result.toLowerCase().contains('classroom')) {
        context.go('/options');
      }
      if (result.toLowerCase().contains('quiz')) {
        context.go('/quiz');
      }
      if (result.toLowerCase().contains('note')) {
        context.go('/notes');
      }
    });
  }
}
