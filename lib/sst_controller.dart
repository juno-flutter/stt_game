import 'dart:html';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SstController extends GetxController {
  final _speechToText = SpeechToText().obs;
  final _speechEnabled = false.obs;
  final _lastWord = '';
  SpeechResultListener onSpeechResult;

  SstController({required this.onSpeechResult});

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled.value = await _speechToText.value.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.value.listen(onResult: onSpeechResult);
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.value.stop();
  }
}