// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../view/home.dart';

class Question {
  Question() {
    init();
  }

  /*
   * 出題情報初期化
   */
  void init() {}

  /*
   * 計算式（足し算）の取得
   */
  String getFormula(OperationSelector? operation) {
    switch (operation) {
      case OperationSelector.plus:
        return getPlusFormula();
      case OperationSelector.minus:
        return getMinusFormula();
      case OperationSelector.multiplication:
        return getMultiFormula();
      case OperationSelector.division:
        return getDivisionFormula();
      default:
        return ""; //★
    }
  }

  /*
   * 計算式（足し算）の取得
   */
  String getPlusFormula() {
    final operand1 = getRandomOperandStr();
    final operand2 = getRandomOperandStr();

    return '$operand1 + $operand2';
  }

  /*
   * 計算式（引き算）の取得
   */
  String getMinusFormula() {
    //------------------------------------------
    // 演算値１：必ず演算値２より大きい値にする
    //------------------------------------------
    final tmpOperandNum1 = getRandomOperand();
    final tmpOperandNum2 = getRandomOperand();
    final operandNum1 = tmpOperandNum1 + tmpOperandNum2;

    // 文字列変換
    final operand1 = operandNum1.toString();
    final operand2 = tmpOperandNum2.toString();

    return '$operand1 - $operand2';
  }

  /*
   * 計算式（掛け算）の取得
   */
  String getMultiFormula() {
    final operand1 = getRandomOperandStr();
    final operand2 = getRandomOperandStr();

    return '$operand1 × $operand2';
  }

  /*
   * 計算式（割り算）の取得
   */
  String getDivisionFormula() {
    //------------------------------------------
    // 演算値１：必ず演算値２で割り切れる値にする
    //------------------------------------------
    final tmpOperandNum1 = getRandomOperand();
    // 割る数は0以外
    int tmpOperandNum2;
    do {
      tmpOperandNum2 = getRandomOperand();
    } while (tmpOperandNum2 == 0);

    final operandNum1 = tmpOperandNum1 * tmpOperandNum2;

    // 文字列変換
    final operand1 = operandNum1.toString();
    final operand2 = tmpOperandNum2.toString();

    return '$operand1 ÷ $operand2';
  }

  /*
   * 出題計算式の取得
   */
  int getRandomOperand() {
    return math.Random().nextInt(10);
  }

  String getRandomOperandStr() {
    return math.Random().nextInt(10).toString();
  }
}
