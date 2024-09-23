import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';
// import 'package:flutter/services.dart';

class VoiceController extends StatefulWidget {
  const VoiceController({super.key});

  @override
  State<VoiceController> createState() => _VoiceControllerState();
}

class _VoiceControllerState extends State<VoiceController> {
  final _record = AudioRecorder();
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  stt.SpeechToText _speech = stt.SpeechToText();
  final AudioPlayer _alertPlayer = AudioPlayer();

  Timer? _timer;
  int _time = 0;
  bool _isRecording = false;
  String? _audiopath;
  List<String> _recordings = [];
  String? _playingPath;
  bool _isPlaying = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    requestPermission();
    requestSpeechPermission();
    _loadRecordings();
    _initSpeech();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        _isPaused = state == PlayerState.paused;
      });
    });
  }

  //play sound when user press the record button
  Future<void> _playAlertSound() async {
    try {
      await _alertPlayer.play(AssetSource('sounds/recording-start.mp3'));
    } catch (e) {
      log('Error playing alert sound: $e');
    }
  }

  //request microphone permissions
  requestPermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      log('Permission granted');
    } else {
      log('Permission denied');
    }
  }

  //request speech permission
  requestSpeechPermission() async {
    var status = await Permission.speech.request();
    if (status.isGranted) {
      log('Speech recognition permission granted');
    } else {
      log('Speech recognition permission denied');
    }
  }

  //initialize speech to text
  Future<void> _initSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      _startListening();
    } else {
      log('The user has denied the use of speech recognition.');
    }
  }

  //start listening to speech
  void _startListening() {
    _speech.listen(onResult: (result) {
      String recognizedWords = result.recognizedWords.toLowerCase();
      if (recognizedWords.contains("start recording") && !_isRecording) {
        _startRecording();
      } else if (recognizedWords.contains("stop recording") && _isRecording) {
        _stopRecording();
      }
    });
  }

  //load existing recordings
  Future<void> _loadRecordings() async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        dir = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    }

    if (dir != null) {
      final List<FileSystemEntity> files = dir.listSync();
      setState(() {
        _recordings = files
            .where((file) => file.path.endsWith('.m4a'))
            .map((file) => file.path)
            .toList();
      });
    }
  }

  //start the timer when recording starts
  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _time++;
      });
    });
  }

  //stop the timer when recording stops
  void _stopTimer() {
    _timer?.cancel();
    _time = 0;
  }

  //start recording
  Future<void> _startRecording() async {
    if (await _record.hasPermission()) {
      _playAlertSound(); // Play the alert sound

      Directory? dir;

      // Get the storage directory
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      }

      if (dir != null) {
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}.m4a'; // Generate unique filename
        String filePath = '${dir.path}/$fileName';

        await _record.start(
          const RecordConfig(),
          path: filePath, // Provide the file path
          //methana encoder eka thibba eka blnna aulak unoth
        );

        setState(() {
          _isRecording = true;
          _audiopath = filePath;
        });

        _startTimer(); // Start the timer
      } else {
        log('Directory is null');
      }
    }
  }

  // Stop recording
  Future<void> _stopRecording() async {
    final path = await _record.stop();
    if (path != null) {
      log('Recording saved to: $path');
    }

    setState(() {
      _isRecording = false;
      _recordings.add(path!);
    });

    _stopTimer(); // Stop the timer
  }

  //delete recording
  Future<void> _deleteRecording(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();

        // Trigger vibration feedback
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator != null && hasVibrator) {
          Vibration.vibrate(duration: 200); // Adjust the duration as needed
        }

        setState(() {
          _recordings.remove(path); // Remove the file path from the list
        });
        log('Recording deleted: $path');
      }
    } catch (e) {
      log('Error deleting recording: $e');
    }
  }

  //update recording
  Future<void> _updateRecording(String path) async {
    if (await _record.hasPermission()) {
      // Stop the current recording if any
      if (_isRecording) {
        await _stopRecording();
      }

      // Start a new recording at the same path to overwrite the existing file
      await _record.start(
        const RecordConfig(),
        path: path, // Use the same file path to overwrite
        // Use the same audio encoding format
      );

      setState(() {
        _isRecording = true;
        _audiopath = path; // Update the current path
      });

      _startTimer(); // Start the timer for the new recording
    } else {
      log('Permission not granted');
    }
  }

  //play recording
  Future<void> _playRecording(String path) async {
    try {
      await _audioPlayer.play(DeviceFileSource(path));
      setState(() {
        _playingPath = path;
        _isPlaying = true;
        _isPaused = false;
      });
    } catch (e) {
      log('Error playing recording: $e');
    }
  }

//pause recording
  Future<void> _pauseRecording() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      log('Error pausing recording: $e');
    }
  }

  //resume recording
  Future<void> _resumeRecording() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      log('Error resuming recording: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _audioPlayer.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 25, 73, 156),
        title: const Text(
          'Voice Notes',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isRecording ? 'Recording...' : 'Press or say "Start Recording"',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Semantics(
              label: _isRecording ? 'Stop Recording' : 'Start Recording',
              child: SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    backgroundColor: _isRecording
                        ? Colors.red
                        : const Color.fromARGB(255, 25, 73, 156),
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Recording Time: $_time seconds',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            if (_audiopath != null)
              Text(
                'Saved at: $_audiopath',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _recordings.length,
                itemBuilder: (context, index) {
                  final path = _recordings[index];
                  final isCurrentPlaying = _playingPath == path;
                  return Dismissible(
                    key: ValueKey(path),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete,
                          color: Colors.white, size: 32),
                    ),
                    onDismissed: (direction) {
                      _deleteRecording(path);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 25, 73, 156),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        title: Text(
                          'Recording ${index + 1}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          path,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                isCurrentPlaying
                                    ? (_isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow)
                                    : Icons.play_arrow,
                              ),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                if (isCurrentPlaying) {
                                  if (_isPlaying) {
                                    _pauseRecording();
                                  } else if (_isPaused) {
                                    _resumeRecording();
                                  }
                                } else {
                                  _playRecording(path);
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.update,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                              onPressed: () {
                                _updateRecording(
                                    path); // Implement this function
                              },
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
        ),
      ),
    );
  }
}
