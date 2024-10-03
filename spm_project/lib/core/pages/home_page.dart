import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spm_project/core/services/speech_to_text_service.dart';
import 'dart:ui';
import 'package:logger/logger.dart';
import 'package:spm_project/di/injectable.dart';
import 'package:audioplayers/audioplayers.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late MySpeechToTextService _speechService;
  Logger logger = getit<Logger>();
  User? user = FirebaseAuth.instance.currentUser;
  final audioPlayer = AudioPlayer();

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
                          GestureDetector(
                            onTap:(){context.go('/');},
                            child: Container(
                              height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Feature 4",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:(){context.go('/quiz');},
                            child: Container(
                              height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Quiz",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:(){context.go('/notes');},
                            child: Container(
                              height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Notes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:(){context.go('/options');},
                            child: Container(
                              height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Class-room",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    if (user != null) {
                      logger.i(user!.email); 
                      if (user!.email == 'admin@gmail.com') {
                        context.go('/admin');
                      } else {
                        showOverlay(context);
                        startListeningAndNavigate();
                      }
                    } else {
                      logger.i('No user is logged in');
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
        final dialogContext = context;
        Future.delayed(const Duration(seconds: 6), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        });

        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black
                    .withOpacity(0.5), 
              ),
            ),
            Center(
              child: Image.asset('assets/images/mic-logo-vec.png'),
            ),
          ],
        );
      },
    );
  }

  void startListeningAndNavigate() async {
  await _speechService.startListening((String result) async {
    logger.i(result);
    if (result.toLowerCase().contains('classroom')) {
      context.go('/options');
    }
    if (result.toLowerCase().contains('game')) {
      context.go('/quiz');
    }
    if (result.toLowerCase().contains('note')) {
      context.go('/notes');
    }
    if (result.toLowerCase().contains('instruct')) {
      await audioPlayer.play(AssetSource('sounds/instructions.mp3'));  
    }
  });
}
}
