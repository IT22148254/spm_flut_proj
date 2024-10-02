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
                              onPressed: () {},
                              style: const ButtonStyle(),
                              child: const Text("First feature"),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: const ButtonStyle(),
                              child: const Text("First feature"),
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
                              onPressed: () {},
                              style: const ButtonStyle(),
                              child: const Text("First feature"),
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
                              child: const Text("Interactive classroom"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    showOverlay(context);
                    startListeningAndNavigate();
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
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
              ),
            ),
            // Overlay content
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.5,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Overlay Content",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xd0ff0000),
                        fontFamily: 'monospace',
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xffffff00),
                        decorationStyle: TextDecorationStyle.double,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("This layout appears on long press"),
                  ],
                ),
              ),
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
    });
  }
}
