// Flutter imports:
import 'package:flutter/material.dart';

class AppColors {
  //---------------
  // 背景色
  //---------------
  // 画面
  static const mainBgGradationTop = Color(0xffa8edea);
  static const mainBgGradationBottom = Color(0xfffed6e3);
  static const mainBgGradation = [
    mainBgGradationTop,
    mainBgGradationBottom,
  ];
  // 制御系ボタンUI
  static const bgControlButton = Color.fromARGB(255, 255, 255, 255);
  // 演算子選択肢 on/off
  static const bgOperationButtonOn = Color.fromARGB(255, 255, 255, 255);
  static const bgOperationButtonOff = Color.fromARGB(255, 156, 156, 156);

  //---------------
  // 文字色
  //---------------
  // トレーニングアドバイス
  static const txAdvice = Colors.white;
  // 計算式
  static const txFormula = Color.fromARGB(255, 83, 83, 83);
  // 制御系ボタンUI
  // static const txButton = Color.fromARGB(255, 83, 83, 83);
  static const txButton = Color.fromARGB(255, 153, 95, 255);
  // 演算子選択肢 on/off
  // static const txOperationButtonOn = Color.fromARGB(255, 156, 156, 156);
  static const txOperationButtonOn = Color.fromARGB(255, 153, 95, 255);
  static const txOperationButtonOff = Color.fromARGB(255, 255, 255, 255);
  // トレーニング画面上部
  // static const txTrainingInfo = Color.fromARGB(255, 83, 83, 83);
  static const txTrainingInfo = Colors.white;

  //---------------
  // 境界線
  //---------------
  // トレーニング画面上部
  // static const borderTrainingInfo = Color.fromARGB(255, 83, 83, 83);
  static const borderTrainingInfo = Colors.white;
}
