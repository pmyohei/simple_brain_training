// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import './home.dart';
// Project imports:
import '../trainingLogic/question.dart';

/*
 * Training画面Widget
 */
class Training2 extends HookConsumerWidget {
  Training2({super.key}) {
    _stopWatchTimer.onStartTimer();
  }

  // AnimatedList用キー
  final GlobalKey<AnimatedListState> _formulaListKey = GlobalKey();

  // ストップウォッチタイマー
  final _stopWatchTimer = StopWatchTimer();

  final duration = 1000;

  /*
  * 計算式の新規追加
  */
  void addFormula(List<String> formulaList, OperationSelector? operation) {
    final index = formulaList.length;
    formulaList.add(Question().getFormula(operation));
    _formulaListKey.currentState
        ?.insertItem(index, duration: Duration(milliseconds: duration));
  }

  /*
  * 計算式の削除
  */
  void deleteFormula(List<String> formulaList) {
    const topIndex = 0;

    final _styleTween = TextStyleTween(
      begin: const TextStyle(
        fontSize: 32,
        color: Colors.blue,
      ),
      end: const TextStyle(
        fontSize: 40,
        color: Colors.red,
      ),
    );

    final topFormula = formulaList.removeAt(topIndex);
    _formulaListKey.currentState?.removeItem(
      topIndex,
      (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0, 1), // degin:0.5 にすると、durationの半分の時間から始まる
          ),
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 1),
            ),
          ),
        );
        // return DefaultTextStyleTransition(
        //   style: _styleTween.animate(animation),
        //   child: _buildFormulaItem(topFormula),
        // );
        // return FadeTransition(
        //   opacity: CurvedAnimation(
        //     parent: animation,
        //     curve: const Interval(0, 1), // degin:0.5 にすると、durationの半分の時間から始まる
        //   ),
        //   child: SizeTransition(
        //     sizeFactor: CurvedAnimation(
        //       parent: animation,
        //       curve: const Interval(0, 1),
        //     ),
        //     child: DefaultTextStyleTransition(
        //       style: _styleTween.animate(animation),
        //       child: _buildFormulaItem(topFormula),
        //     ),
        //   ),
        // return FadeTransition(
        //   opacity: CurvedAnimation(
        //     parent: animation,
        //     curve: const Interval(0, 1), // degin:0.5 にすると、durationの半分の時間から始まる
        //   ),
        //   child: DefaultTextStyleTransition(
        //     style: _styleTween.animate(animation),
        //     child: _buildFormulaItem(topFormula),
        //   ),
        // );
      },
      duration: Duration(milliseconds: 1000),
    );
  }

  /*
  * 計算式Widget
  */
  Widget _buildFormulaItem(String calculate, Animation<double> animation,
      [int? index]) {
    //-----------------------
    // 計算式フォントサイズ
    //-----------------------
    MaterialColor sColor = Colors.blue;
    MaterialColor eColor = Colors.red;

    double startFontSize = 12;
    double endFontSize = 24;
    double fontSize = 24;
    if (index == 0) {
      fontSize = 40;
      startFontSize = 32;
      endFontSize = 40;

      sColor = Colors.yellow;
      eColor = Colors.green;
    } else if (index == 1) {
      fontSize = 32;
      startFontSize = 24;
      endFontSize = 32;

      sColor = Colors.blueGrey;
      eColor = Colors.orange;
    }

    print('コール数=$index');
    print('animation.value=$animation.value');

    final styleTween = TextStyleTween(
      begin: TextStyle(
        fontSize: startFontSize,
        color: sColor,
      ),
      end: TextStyle(
        fontSize: endFontSize,
        color: eColor,
      ),
    );

    // return SizedBox(
    //   height: height,
    //   width: width,
    //   child: Text(
    //     calculate,
    //     style: TextStyle(fontSize: fontSize),
    //   ),
    // );
    // return Text(
    //   calculate,
    //   style: TextStyle(fontSize: fontSize),
    // );
    // return DefaultTextStyleTransition(
    //   style: _styleTween.animate(animation),
    //   child: Text(
    //     calculate,
    //     style: TextStyle(fontSize: fontSize),
    //   ),
    // );
    // return AnimatedDefaultTextStyle(
    //   child: Text(calculate),
    //   style: TextStyle(
    //     color: Colors.blue,
    //     fontSize: fontSize,
    //   ),
    //   duration: Duration(milliseconds: 200),
    // );
    // return AnimatedDefaultTextStyle(
    //   style: _styleTween.animate(animation),
    //   child: Text(calculate),
    //   duration: Duration(milliseconds: 200),
    // );
    return DefaultTextStyleTransition(
      style: styleTween.animate(animation),
      child: Text(calculate),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 計算式リスト
    final formulaList = useState<List<String>>(['a', 'b', 'c']);
    //------------------------
    // UIサイズ
    //------------------------
    final deviceWidth = MediaQuery.of(context).size.width;
    // Startボタン
    final trainingUIResponsiveSize = deviceWidth * 0.2;
    final trainingUISize =
        (trainingUIResponsiveSize > 120.0) ? 120.0 : trainingUIResponsiveSize;

    //------------------------
    // 状態管理
    //------------------------
    // トレーニング情報
    final trainingInfoProvider = ref.watch(kTrainingInfoProvider);
    final operation = trainingInfoProvider.operation;
    // 回答数
    final answerCounter = useState(0);
    // 計算式
    final quiestion1 = useState(Question().getFormula(operation));
    final quiestion2 = useState(Question().getFormula(operation));
    final quiestion3 = useState(Question().getFormula(operation));

    //------------------------
    // 画面ライフサイクル
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
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //------------------------
              // 画面上部
              //------------------------
              Container(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 35, 35, 35),
                    ),
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
              Container(
                width: 100,
                child: AnimatedList(
                  key: _formulaListKey,
                  initialItemCount: formulaList.value.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index, animation) {
                    return Center(
                      child: _buildFormulaItem(
                        formulaList.value[index],
                        animation,
                        index,
                      ),
                    );
                    // return Center(
                    //   child: FadeTransition(
                    //     opacity: animation,
                    //     child: _buildFormulaItem(
                    //         formulaList[index], animation, index),
                    //   ),
                    // );
                  },
                ),
              ),

              // AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 200),
              //   child: Text(
              //     key: ValueKey(quiestion1.value),
              //     quiestion1.value,
              //     style: const TextStyle(
              //       fontSize: 44,
              //     ),
              //   ),
              // ),
              // Text(
              //   key: kCalculate2Key,
              //   quiestion2.value,
              //   style: const TextStyle(
              //     fontSize: 32,
              //   ),
              // ),
              // Text(
              //   key: kCalculate3Key,
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
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

                      // 回答数カウント
                      answerCounter.value++;

                      deleteFormula(formulaList.value);
                      addFormula(formulaList.value, operation);

                      // RenderBox renderbox = kCalculate1Key.currentContext!
                      //     .findRenderObject() as RenderBox;
                      // Offset position = renderbox.localToGlobal(Offset.zero);
                      // double x = position.dx;
                      // double y = position.dy;

                      // print(x); //20.0
                      // print(y); //112.36363636363637
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
