import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spm_project/di/injectable.dart';
import 'package:spm_project/features/videoConference/services/my_agora_service.dart';
import 'package:flutter/services.dart'; // For haptic feedback
//import 'package:audioplayers/audioplayers.dart'; // For playing audio feedback
import 'dart:math';

class VideoConferencePage extends StatefulWidget {
  final String channelName;

  const VideoConferencePage({super.key, required this.channelName});

  @override
  VideoConferencePageState createState() => VideoConferencePageState();
}

class VideoConferencePageState extends State<VideoConferencePage> {
  final AgoraClient _client = getit<AgoraClient>();
  final Logger _logger = getit<Logger>();
  final MyAgoraService _myAgoraService = getit<MyAgoraService>();
  //final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAgoraClientInitiated = false;
  int uid = Random().nextInt(1 << 32);
  bool _isCameraOff = false;
  bool _isMicrophoneOff = false;

  Future<void> _initializeAgora() async {
    try {
      await _myAgoraService.initialize();
      setState(() {
        _isAgoraClientInitiated = true;
      });
    } catch (e) {
      _logger.e('Failed to initialize Agora: $e');
    }
  }

  Future<void> _endCall() async {
    try {
      _logger.i("Ending the call");
      await _myAgoraService.endCall(context);
    } catch (e) {
      _logger.e('Failed to end the call: $e');
    }
  }

  void _handleLongPress() async {
    try {
      HapticFeedback.heavyImpact();
      if (mounted) {
        await _client.engine.enableLocalAudio(false);
        await _client.engine.enableLocalVideo(false);
      }
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: const Text('Camera and microphone disabled !'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      _logger.e("Failed to toggle camera and microphone");
    }
  }

  void _handleDoubleTap() async {
    try {
      HapticFeedback.mediumImpact();
      _client.engine.enableLocalVideo(!_isCameraOff);
      if (_isCameraOff) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text('Camera is disabled !'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text('Camera is enabled !'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      _logger.e("Failed to toggle camera $e");
    }
  }

  void _handleTap() {
    try {
      HapticFeedback.mediumImpact();
      _client.engine.enableLocalAudio(!_isMicrophoneOff);
      if (_isMicrophoneOff) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text('Microphone is disabled !'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text('Microphone is enabled !'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on Exception catch (e) {
      _logger.e("Failed to toggle microphone $e");
    }
  }

  // Future<void> _playAudioFeedback(String fileName) async {
  //   await _audioPlayer.play(AssetSource(fileName));
  // }

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onLongPress: _handleLongPress,
          onTap: () {
            _handleTap();
            _isMicrophoneOff = !_isMicrophoneOff;
          },
          onDoubleTap: () {
            _handleDoubleTap();
            _isCameraOff = !_isCameraOff;
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _endCall();
            }
            if (details.primaryVelocity! < 0) {
              _handleTap();
              _isMicrophoneOff = !_isMicrophoneOff;
            }
          },
          child: _isAgoraClientInitiated
              ? Stack(
                  children: [
                    AgoraVideoViewer(
                      client: _client,
                      layoutType: Layout.floating,
                      enableHostControls: true,
                    ),
                    AgoraVideoButtons(
                      client: _client,
                      onDisconnect: _endCall,
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
