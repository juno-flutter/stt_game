import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stt_game/color_schemes.g.dart';
import 'package:stt_game/word_list_controller.dart';
// import 'color_schemes.g.dart';

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

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
  }

  void _toEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() {
    _speechToText.listen(
      onResult: _onSpeechResult,
      cancelOnError: true,
      partialResults: false,
    );
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
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
                Text('?????? ????????????. ?????? ????????? ?????? ?????????.'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          );
        } else {
          _toEnd();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20.0,
        scrolledUnderElevation: 20.0,
        shadowColor: Colors.grey,
        title: const Center(
          child: Text(
            '?????? ??????',
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
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: GetX<WordListController>(builder: (controller) {
          return GridView.builder(
            controller: _scrollController,
            // shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
            itemCount: controller.wordItems.length,
            itemBuilder: (_, index) {
              return Material(
                child: InkWell(
                  onTap: () {},
                  onLongPress: () {
                    Get.defaultDialog(
                      title: '\'${controller.wordItems[index].word}\'',
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.error_outline),
                          SizedBox(
                            width: 10,
                          ),
                          Text('??? ????????? ??????????????????????'),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            controller.removeWordList(index: index);
                            Get.back();
                          },
                          child: const Text('OK'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  radius: 50.0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 5, right: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // color: Colors.yellow,
                      // backgroundBlendMode: BlendMode.difference,
                      border: Border.all(color: Colors.blue.shade300),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                          spreadRadius: 0.5,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          // Colors.white,
                          // Colors.yellow.shade50,
                          // Colors.blue.shade50,
                          // Colors.orange.shade50,
                          Colors.deepOrange.shade50,
                          // Colors.pink.shade50,
                          // Colors.lightBlue.shade50,
                          Colors.blue.shade50,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.mirror,
                      ),
                    ),

                    /*Dismissible(
                  key: ValueKey(index),
                  // onDismissed: ,
                  dragStartBehavior: DragStartBehavior.down,
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (DismissDirection dir) async => dir == DismissDirection.endToStart,
                  background: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.red[300],
                    ),
                    child: const Icon(
                      Icons.delete_rounded,
                      size: 40,
                    ),
                  )*/
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
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
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(
                              controller.wordItems[index].word,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(fontSize: 18,
                                  color: lightColorScheme.onPrimaryContainer),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: SizedBox(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: Colors.transparent.withOpacity(0.2),
              // backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
              // disabledElevation: 1,
              elevation: 0,
              onPressed: fabAction,
              child: Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                color: _speechToText.isListening
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.error,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void fabAction() {
    // If not yet listening for speech start, otherwise stop
    if (ThemeMode.system == ThemeMode.dark) {

    }
    if (_speechToText.isNotListening) {
      _startListening();
    } else {
      _stopListening();
    }
    setState(() {});
  }
}
