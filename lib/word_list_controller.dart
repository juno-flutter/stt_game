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

  var editWord = "".obs;
  var indexEditWord = 0.obs;


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
    '동네방네',
    '오비이락',
    '조중동',
    '지피지기',
    '공공의적',
    '듄',
    '지하경제',
    '용호상박',
    '위화도회군',
    '맥북',
    '경상북도 울릉군',
    'Not123콩고',
    'MacBookAir-3',
    'iPhone13',
    '아이폰13',
    'iPad',
    '아이파드',
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

  bool removeWordList ({required int index}) {
    if (wordItems.length <= index) {
      return false;
    }
    wordItems.removeAt(index);
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
