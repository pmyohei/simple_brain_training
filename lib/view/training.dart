// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import './app.dart';
// Project imports:
import '../trainingLogic/question.dart';

class Training extends HookConsumerWidget {
  // ストップウォッチタイマー
  final _stopWatchTimer = StopWatchTimer();

  Training({super.key}) {
    _stopWatchTimer.onStartTimer();
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
              Text(
                quiestion1.value,
                style: const TextStyle(
                  fontSize: 44,
                ),
              ),
              Text(
                quiestion2.value,
                style: const TextStyle(
                  fontSize: 32,
                ),
              ),
              Text(
                quiestion3.value,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
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

                      // 回答数カウント
                      answerCounter.value++;
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
