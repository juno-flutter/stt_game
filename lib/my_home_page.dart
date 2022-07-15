import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stt_game/word_list_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  final wordListController = Get.put(WordListController());

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    // setState(() {
    if (result.finalResult) {
      _lastWords = result.recognizedWords;
      bool ret = wordListController.addWordList(word: _lastWords);
      if (ret == false) {
        Get.defaultDialog(
          title: '\'$_lastWords\'',
          content: Row(
            children: const [
              Icon(Icons.error_outline),
              SizedBox(
                width: 2,
              ),
              Text('이미 있습니다. 다른 낱말을 말해 보세요.'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        );
      }
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '낱말 게임',
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              wordListController.wordItems.clear();
            },
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            wordListController.isSortByTime = !wordListController.isSortByTime;
          },
          icon: GetX<WordListController>(
            builder: (_) =>
                _.isSortByTime ? const Icon(Icons.access_time_rounded) : const Icon(Icons.sort_by_alpha_rounded),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: GetX<WordListController>(builder: (controller) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: controller.wordItems.length,
            itemBuilder: (_, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.color,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.yellow.shade50,
                      Colors.green.shade50,
                      Colors.teal.shade50,
                      Colors.blue.shade50,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(_).colorScheme.primary.withOpacity(0.5),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: Theme.of(_).colorScheme.onPrimary),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        controller.wordItems[index].word,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontSize: 18, color: Theme.of(_).colorScheme.onPrimaryContainer),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Container(
      //         padding: const EdgeInsets.all(16),
      //         child: const Text(
      //           'Recognized words:',
      //           style: TextStyle(fontSize: 20.0),
      //         ),
      //       ),
      //       Expanded(
      //         child: Container(
      //           padding: const EdgeInsets.all(16),
      //           child: Text(
      //             // If listening is active show the recognized words
      //             _speechToText.isListening
      //                 ? _lastWords
      //             // If listening isn't active but could be tell the user
      //             // how to start it, otherwise indicate that speech
      //             // recognition is not yet ready or not supported on
      //             // the target device
      //                 : _speechEnabled
      //                 ? 'Tap the microphone to start listening...'
      //                 : 'Speech not available',
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: fabAction,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  void fabAction() {
    // If not yet listening for speech start, otherwise stop
    if (_speechToText.isNotListening) {
      _startListening();
    } else {
      _stopListening();
    }
  }
}
