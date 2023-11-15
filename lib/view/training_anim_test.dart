// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

// import './app.dart';
// Project imports:
import './home.dart';
import '../trainingLogic/question.dart';

class TrainingAnim extends HookConsumerWidget {
  // ストップウォッチタイマー
  final _stopWatchTimer = StopWatchTimer();

  final List<String> listFor = [
    '',
    '',
    '',
  ];

  TrainingAnim({super.key}) {
    _stopWatchTimer.onStartTimer();
  }

  Widget _buildFormula(List<String> formulas, int number) {
    double top;
    String form;
    int duration;
    double fontSize;
    if (number == 0) {
      top = 100;
      form = formulas[2];
      duration = 600;
      fontSize = 8;
      fontSize = 30;

      return _buildFormulaUp(top, form, duration, fontSize);
      // return _buildFormulaLast(top, form, duration, fontSize);
    } else if (number == 1) {
      top = 50;
      form = formulas[1];
      duration = 1000;
      fontSize = 30;
      fontSize = 30;

      return _buildFormulaUp(top, form, duration, fontSize);
    } else {
      top = 0;
      form = formulas[0];
      duration = 1000;
      fontSize = 50;
      fontSize = 30;

      return _buildFormulaUp(top, form, duration, fontSize);
    }

    // return AnimatedPositioned(
    //   top: top,
    //   duration: Duration(milliseconds: duration),
    //   curve: Curves.fastOutSlowIn,
    //   child: GestureDetector(
    //     child: Text(
    //       form,
    //       style: const TextStyle(
    //         fontSize: 44,
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _buildFormulaUp(
    double top,
    String form,
    int duration,
    double fontSize,
  ) {
    return AnimatedDefaultTextStyle(
      style: TextStyle(fontSize: fontSize),
      duration: Duration(milliseconds: duration),
      curve: Curves.fastOutSlowIn,
      child: AnimatedPositioned(
        top: top,
        duration: Duration(milliseconds: duration),
        curve: Curves.fastOutSlowIn,
        child: Text(
          form,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildTest(bool flg) {
    return AnimatedDefaultTextStyle(
      style: flg ? TextStyle(fontSize: 10) : TextStyle(fontSize: 20),
      duration: Duration(seconds: 1),
      child: AnimatedPositioned(
        top: flg ? 0 : 30,
        duration: Duration(seconds: 1),
        child: Text(
          'A + B',
          // style: TextStyle(
          //   fontSize: fontSize,
          // ),
        ),
      ),
    );
  }

  Widget _buildFormulaLast(
    double top,
    String form,
    int duration,
    double fontSize,
  ) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: fontSize),
      child: Positioned(
        top: top,
        child: Text(
          form,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    //------------------------
    // UIサイズ
    //------------------------
    final deviceWidth = MediaQuery.of(context).size.width;
    final trainingUISize = deviceWidth * 0.2;
    final trainingUIRadius = trainingUISize * 0.1;

    //------------------------
    // 状態管理
    //------------------------
    // トレーニング情報
    final trainingInfoProvider = ref.watch(kTrainingInfoProvider);
    final operation = trainingInfoProvider.operation;
    // タイマー
    // final timerDisplay = useState('00:00:00.000');
    // 回答数
    final answerCounter = useState(0);
    // 計算式
    final quiestion1 = useState(Question().getFormula(operation));
    final quiestion2 = useState(Question().getFormula(operation));
    final quiestion3 = useState(Question().getFormula(operation));

    // 計算式位置番号
    final number1 = useState(2);
    final number2 = useState(1);
    final number3 = useState(0);

    var changeFlg = useState(false);

    // print('$listFor');

    //------------------------
    // トレーニング画面
    //------------------------
    useOnAppLifecycleStateChange((beforeState, currState) async {
      switch (currState) {
        case AppLifecycleState.resumed:
          print('LOG: バックグラウンドから復帰しました');
          _stopWatchTimer.onStartTimer();

        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.hidden:
          print('LOG: バックグラウンドになりました');
          _stopWatchTimer.onStopTimer();

        case AppLifecycleState.detached:
          print('LOG: 終了しました');
          await _stopWatchTimer.dispose();
      }
    });

    //------------------------
    // トレーニング画面
    //------------------------
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.9],
          colors: [
            Color(0xffa8edea),
            Color(0xfffed6e3),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //------------------------
              // 画面上部
              //------------------------
              Container(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 35, 35, 35)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Training Time',
                        ),
                        StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: _stopWatchTimer.rawTime.value,
                          builder: (context, snapshot) {
                            // ストップウオッチ時間を取得「hh:mm:ss.ms」
                            final timerTime = StopWatchTimer.getDisplayTime(
                              snapshot.data!,
                            );
                            // ms部分をカット：「hh:mm:ss.ms」⇒「hh:mm:ss」
                            final displayTime = timerTime.substring(0, 8);

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
                              child: Text(
                                displayTime,
                                style: const TextStyle(fontSize: 24),
                              ),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Divider(
                            color: Color.fromARGB(255, 196, 19, 19),
                          ),
                        ),
                        const Text(
                          'Answers',
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: Text(
                            answerCounter.value.toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //------------------------
              // 計算問題
              //------------------------
              SizedBox(
                height: 300,
                width: 300,
                child: Stack(
                  children: <Widget>[
                    _buildTest(changeFlg.value),
                  ],
                ),
              ),
              // Text(
              //   quiestion1.value,
              //   style: const TextStyle(
              //     fontSize: 44,
              //   ),
              // ),
              // Text(
              //   quiestion2.value,
              //   style: const TextStyle(
              //     fontSize: 32,
              //   ),
              // ),
              // Text(
              //   quiestion3.value,
              //   style: const TextStyle(
              //     fontSize: 24,
              //   ),
              // ),
              //------------------------
              // 操作ボタン
              //------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: trainingInfoProvider.changeOnTraining,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(trainingUISize, trainingUISize),
                      shape: const CircleBorder(),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    child: const Text('Home'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 計算問題入れ替え
                      quiestion1.value = quiestion2.value;
                      quiestion2.value = quiestion3.value;
                      quiestion3.value = Question().getFormula(operation);

                      String for1 = listFor[1];
                      String for2 = listFor[2];

                      listFor[0] = for1;
                      listFor[1] = for2;
                      listFor[2] = Question().getFormula(operation);

                      // 回答数カウント
                      answerCounter.value++;

                      number1.value =
                          (number1.value + 1) <= 2 ? (number1.value + 1) : 0;
                      number2.value =
                          (number2.value + 1) <= 2 ? (number2.value + 1) : 0;
                      number3.value =
                          (number3.value + 1) <= 2 ? (number3.value + 1) : 0;

                      changeFlg.value = !changeFlg.value;
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(trainingUISize, trainingUISize),
                      shape: const CircleBorder(),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
