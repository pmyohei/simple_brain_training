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

//
GlobalKey kCalculate1Key = GlobalKey();
GlobalKey kCalculate2Key = GlobalKey();
GlobalKey kCalculate3Key = GlobalKey();

/*
 * Training画面Widget
 */
class TrainingABC extends HookConsumerWidget {
  // AnimatedList用キー
  final GlobalKey<AnimatedListState> _caluculateListKey = GlobalKey();
  // 計算式リスト
  final List<String> listData = ['a', 'b', 'c'];

  // ストップウォッチタイマー
  final _stopWatchTimer = StopWatchTimer();

  TrainingABC({super.key}) {
    _stopWatchTimer.onStartTimer();
  }

  void addUser() {
    final index = listData.length;
    listData.add('d');
    _caluculateListKey.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 500));
  }

  void deleteUser() {
    final user = listData.removeAt(0);
    _caluculateListKey.currentState?.removeItem(
      0,
      (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity: CurvedAnimation(
              parent: animation, curve: const Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: animation, curve: const Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: _buildItem(user),
          ),
        );
      },
      duration: Duration(milliseconds: 600),
    );
  }

  Widget _buildItem(String calculate, [int? index]) {
    return Text(
      calculate,
      // style: TextStyle(fontSize: index == 0 ? 32 : 10),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    return Scaffold(
      body: SafeArea(
        child: AnimatedList(
          key: _caluculateListKey,
          initialItemCount: listData.length,
          itemBuilder: (context, index, animation) {
            return FadeTransition(
              opacity: animation,
              child: _buildItem(listData[index], index),
            );
          },
        ),
      ),
    );
  }
}
