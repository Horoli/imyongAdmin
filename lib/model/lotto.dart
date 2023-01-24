part of '../../common.dart';

class Lotto {
  int number = 46;
  late List<int> lottoSet;

  List<int> lottoFirst = [];
  List<int> lottoSecond = [];
  List<int> lottoThird = [];
  List<int> lottoFourth = [];
  List<int> lottoFifth = [];

  void createLottoSet() {
    lottoSet = [];
    for (int i = 1; i < number; i++) {
      lottoSet.add(i);
    }
  }

  void shuffleLottoSet() {
    createLottoSet();
    lottoSet.shuffle();
    // print(lottoSet);
  }

  void remove() {
    lottoFirst = [];
    lottoSecond = [];
    lottoThird = [];
    lottoFourth = [];
    lottoFifth = [];
  }

  void createNumber() {
    if (lottoFirst.isNotEmpty) {
      remove();
    }
    if (lottoFirst.isEmpty) {
      shuffleLottoSet();
      for (int i = 0; i < 6; i++) {
        lottoFirst.add(lottoSet.last);
        lottoFirst.sort();
        lottoSet.removeLast();
      }
    }

    if (lottoSecond.isEmpty) {
      shuffleLottoSet();
      for (int i = 0; i < 6; i++) {
        lottoSecond.add(lottoSet.last);
        lottoSecond.sort();
        lottoSet.removeLast();
      }
    }

    if (lottoThird.isEmpty) {
      shuffleLottoSet();
      for (int i = 0; i < 6; i++) {
        lottoThird.add(lottoSet.last);
        lottoThird.sort();
        lottoSet.removeLast();
      }
    }

    if (lottoFourth.isEmpty) {
      shuffleLottoSet();
      for (int i = 0; i < 6; i++) {
        lottoFourth.add(lottoSet.last);
        lottoFourth.sort();
        lottoSet.removeLast();
      }
    }

    if (lottoFifth.isEmpty) {
      shuffleLottoSet();
      for (int i = 0; i < 6; i++) {
        lottoFifth.add(lottoSet.last);
        lottoFifth.sort();
        lottoSet.removeLast();
      }
    }
  }
}
