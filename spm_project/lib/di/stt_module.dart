import 'package:speech_to_text/speech_to_text.dart';
import 'package:injectable/injectable.dart';

@module
abstract class SpeechToTextModule {
  @lazySingleton
  SpeechToText get speechToText => SpeechToText();
}
