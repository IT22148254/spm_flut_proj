import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spm_project/di/injectable.dart';
import 'package:spm_project/features/videoConference/services/my_agora_service.dart';

class VideoConferencePage extends StatefulWidget {
  const VideoConferencePage({super.key});

  @override
  VideoConferencePageState createState() => VideoConferencePageState();
}

class VideoConferencePageState extends State<VideoConferencePage> {
  final AgoraClient _client = getit<AgoraClient>();
  final Logger _logger = getit<Logger>();
  bool _isAgoraClientInitiated = false;
  final MyAgoraService _myAgoraService = getit<MyAgoraService>();

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

      _myAgoraService.endCall(context);
    } catch (e) {
      _logger.e('failed to end the call $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isAgoraClientInitiated
            ? Stack(
                children: [
                  AgoraVideoViewer(
                    client: _client,
                    layoutType: Layout.floating,
                    enableHostControls:
                        true, // Add this to enable host controls
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
    );
  }
}
