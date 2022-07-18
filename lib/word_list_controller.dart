import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'word_item.dart';
import 'dart:async';
// import 'package:intl/intl.dart';

class WordListController extends GetxController {
  var wordItems = <WordItem>[].obs;
  final _isSortByTime = true.obs;

  set isSortByTime(bool bb) {
    _isSortByTime.value = bb;
    _isSortByTime.isTrue ? sortByTime() : sortByAlpha();
  }

  bool get isSortByTime => _isSortByTime.isTrue;


  @override
  void onInit() {
    super.onInit();
    fetchWordItems();
  }

  List<String> sampleWordList = <String>[
    '해피',
    '우렁각시',
    '화양연화',
    '부산',
    '정형돈',
    '동네방네떠들ABC',
    '오비이락',
    '조중동',
    '지피지기',
    '공공의적',
  ];

  void fetchWordItems() {
    var wordsResult = List.generate(
      sampleWordList.length,
      (index) {
        Timer(const Duration(milliseconds: 100), () {});
        var time = DateTime.now();
        return WordItem(
          word: sampleWordList[index],
          createdTime: time,
        );
      },
    );
    wordItems.assignAll(wordsResult);
  }

  bool addWordList ({required String word}) {
    int index = wordItems.indexWhere((p0) => p0.word == word);
    if (kDebugMode) {
      print('\'$word\' 검색 결과는 $index');
    }
    if (-1 < index) { // 입력받은 문자열이 이미 등록되어 있는가?
      return false;
    }
    var tt = DateTime.now();
    wordItems.add(WordItem(word: word, createdTime: tt));
    return true;
  }

  void sortWordList(){
    _isSortByTime.isTrue ? sortByTime() : sortByAlpha();
  }

  void sortByTime() {
    wordItems.sort((a, b) => a.createdTime.compareTo(b.createdTime));
  }

  void sortByAlpha() {
    wordItems.sort((a, b) => a.word.compareTo(b.word));
  }
}