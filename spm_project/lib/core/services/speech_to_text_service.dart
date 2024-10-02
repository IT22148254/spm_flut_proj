import 'package:speech_to_text/speech_to_text.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:injectable/injectable.dart';
import 'package:spm_project/di/injectable.dart';

abstract class MySpeechToTextService {
  Future<void> initSpeech();
  Future<void> startListening(Function(String) onResult);
  Future<void> stopListening();
}

@LazySingleton(as: MySpeechToTextService)
class MySpeechToTextServiceImpl extends MySpeechToTextService {
  final SpeechToText _speechToText = getit<SpeechToText>();
  bool _speechEnabled = false;
  String _lastWords = "";
  Logger logger = getit<Logger>();

  @override
  Future<void> initSpeech() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      try {
        _speechEnabled = await _speechToText.initialize();
        if (!_speechEnabled) {
          logger.e("Speech recognition is not available on this device");
        }
      } catch (e) {
        logger.e("Error initializing speech recognition: $e");
      }
    } else {
      logger.e("Microphone permission not granted");
    }
  }

  @override
  Future<void> startListening(Function(String) onResult) async {
    if (_speechEnabled) {
      try {
        await _speechToText.listen(
          onResult: (result) {
            _lastWords = result.recognizedWords;
            logger.i("Recognized words: $_lastWords");
            onResult(_lastWords);
          },
          listenFor: const Duration(seconds: 20),
          localeId: 'en_US',
          onSoundLevelChange: (level) {
            logger.i("Sound level: $level");
          },
        );
      } catch (e) {
        logger.e("Error while starting to listen: $e");
      }
    } else {
      logger.w("Speech recognition is not initialized");
    }
  }

  @override
  Future<void> stopListening() async {
    await _speechToText.stop();
    logger.i("Stopped listening");
  }
}
