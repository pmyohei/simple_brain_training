import 'dart:math' as math;

class Question {
  Question() {
    init();
  }

  List<String> questions = List.filled(3, '');

  /*
   * 出題情報初期化
   */
  void init() {
    questions[0] = '1 + 1';
    questions[1] = '2 + 2';
    questions[2] = '3 + 3';
  }

  /*
   * 出題計算式の取得
   */
  String getQuestion() {
    String operand1 = getRandomOperand();
    String operand2 = getRandomOperand();

    return '$operand1 + $operand2';
  }

  /*
   * 出題計算式の取得
   */
  String getRandomOperand() {
    int operand = math.Random().nextInt(10);
    return operand.toString();
  }
}
