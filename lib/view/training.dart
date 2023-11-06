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
          break;

        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.hidden:
          print('LOG: バックグラウンドになりました');
          _stopWatchTimer.onStopTimer();
          break;

        case AppLifecycleState.detached:
          print('LOG: 終了しました');
          await _stopWatchTimer.dispose();
          break;
      }
    });

    //------------------------
    // トレーニング画面
    //------------------------
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //------------------------
            // 画面上部
            //------------------------
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
              ),
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

                      return Center(
                        child: SizedBox(
                          width: 144,
                          child: Text(
                            displayTime,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  const Text(
                    'Answers',
                  ),
                  Text(
                    answerCounter.value.toString(),
                  ),
                ],
              ),
            ),

            //------------------------
            // 計算問題
            //------------------------
            Text(
              quiestion1.value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              // counter.value.toString(),
              quiestion2.value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              // counter.value.toString(),
              quiestion3.value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            //------------------------
            // 操作ボタン
            //------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: trainingInfoProvider.changeOnTraining,
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
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
