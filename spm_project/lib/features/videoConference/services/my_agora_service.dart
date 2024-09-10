import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:spm_project/di/injectable.dart';
import 'package:go_router/go_router.dart';

abstract class MyAgoraService {
  Future<void> initialize();
  Future<void> endCall(BuildContext context);
}

@LazySingleton(as: MyAgoraService)
class MyAgoraServiceImpl implements MyAgoraService {
  final AgoraClient _client = getit<AgoraClient>();
  final _logger = getit<Logger>();

  @override
  Future<void> initialize() async {
    try {
      await _client.initialize();
      _logger.i('Agora client initialized');
    } catch (e) {
      _logger.e('Error initializing agora client $e');
      rethrow;
    }
  }

  @override
  Future<void> endCall(BuildContext context) async {
    try {
      await _client.engine.leaveChannel();
      await _client.engine.disableAudio();
      await _client.engine.disableVideo();

      _logger.i('Agora client ended call');

      if (context.mounted) {
        context.go('/');
      }
    } catch (e) {
      _logger.e('Error ending call $e');
    }
  }
}
