// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_brain_training/configs/color.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import './home.dart';
import '../trainingLogic/question.dart';

class TrainingAnim extends HookConsumerWidget {
  // ストップウォッチタイマー
  final _stopWatchTimer = StopWatchTimer();

  final List<String> formulaList = [
    '',
    '',
    '',
  ];

  TrainingAnim({super.key}) {
    _stopWatchTimer.onStartTimer();
  }

  Widget _buildFormula(
    List<String> formulas,
    int number,
    ValueNotifier<bool> nextTapControl,
  ) {
    switch (number) {
      case 3:
        return _buildFormulaUp(0, formulas[0], 200, 50, nextTapControl);

      case 2:
        return _buildFormulaUp(80, formulas[1], 200, 30, nextTapControl);

      case 1:
        return _buildFormulaUp(140, formulas[2], 200, 16, nextTapControl);

      case 0:
      default:
        return _buildFormulaUp(160, '', 1, 0, nextTapControl);
    }
  }

  Widget _buildFormulaUp(
    double top,
    String form,
    int duration,
    double fontSize,
    ValueNotifier<bool> nextTapControl,
  ) {
    return AnimatedDefaultTextStyle(
      style: TextStyle(fontSize: fontSize),
      duration: Duration(milliseconds: duration),
      curve: Curves.fastOutSlowIn,
      child: AnimatedPositioned(
        top: top,
        duration: Duration(milliseconds: duration),
        curve: Curves.fastOutSlowIn,
        onEnd: () {
          if (top == 0) {
            nextTapControl.value = true;
          }
        },
        child: Text(
          form,
          style: const TextStyle(
            color: AppColors.txFormula,
          ),
        ),
      ),
    );
  }

  /*
  * 計算式リスト初期化
  */
  void initFormulaList(OperationSelector? operation) {
    // 設定済みなら何もしない
    if (formulaList[0] != '') {
      return;
    }

    //--------------
    // 初期設定
    //--------------
    formulaList[0] = Question().getFormula(operation);
    formulaList[1] = Question().getFormula(operation);
    formulaList[2] = Question().getFormula(operation);
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
    // 回答数
    final answerCounter = useState(0);
    // 計算式
    final quiestion1 = useState(Question().getFormula(operation));
    final quiestion2 = useState(Question().getFormula(operation));
    final quiestion3 = useState(Question().getFormula(operation));

    // 計算式位置
    final number1 = useState(3);
    final number2 = useState(2);
    final number3 = useState(1);
    final number4 = useState(0);

    // Next押下制御
    final nextTapControl = useState(true);

    initFormulaList(operation);

    //------------------------
    // トレーニング画面
    //------------------------
    useOnAppLifecycleStateChange((beforeState, currState) async {
      switch (currState) {
        case AppLifecycleState.resumed:
          // print('LOG: バックグラウンドから復帰しました');
          _stopWatchTimer.onStartTimer();

        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.hidden:
          // print('LOG: バックグラウンドになりました');
          _stopWatchTimer.onStopTimer();

        case AppLifecycleState.detached:
          // print('LOG: 終了しました');
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
          colors: AppColors.mainBgGradation,
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
                      color: AppColors.borderTrainingInfo,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // タイム見出し
                        Text(
                          AppLocalizations.of(context)!.training_time,
                          style: const TextStyle(
                            letterSpacing: 1.4,
                            color: AppColors.txTrainingInfo,
                          ),
                        ),
                        // タイマー
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
                                style: const TextStyle(
                                  fontSize: 24,
                                  letterSpacing: 1.4,
                                  color: AppColors.txTrainingInfo,
                                ),
                              ),
                            );
                          },
                        ),
                        // 境界線
                        const Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Divider(
                            color: AppColors.borderTrainingInfo,
                          ),
                        ),
                        // 回答数見出し
                        Text(
                          AppLocalizations.of(context)!.answers,
                          style: const TextStyle(
                            letterSpacing: 1.4,
                            color: AppColors.txTrainingInfo,
                          ),
                        ),
                        // 回答数
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: Text(
                            answerCounter.value.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              letterSpacing: 1.4,
                              color: AppColors.txTrainingInfo,
                            ),
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
                width: 200,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    _buildFormula(formulaList, number1.value, nextTapControl),
                    _buildFormula(formulaList, number2.value, nextTapControl),
                    _buildFormula(formulaList, number3.value, nextTapControl),
                    _buildFormula(formulaList, number4.value, nextTapControl),
                  ],
                ),
              ),
              //------------------------
              // 操作ボタン
              //------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(trainingUISize, trainingUISize),
                      shape: const CircleBorder(),
                      backgroundColor: AppColors.bgControlButton,
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.home,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!nextTapControl.value) {
                        return;
                      }

                      // 計算問題入れ替え
                      quiestion1.value = quiestion2.value;
                      quiestion2.value = quiestion3.value;
                      quiestion3.value = Question().getFormula(operation);

                      String for1 = formulaList[1];
                      String for2 = formulaList[2];

                      formulaList[0] = for1;
                      formulaList[1] = for2;
                      formulaList[2] = Question().getFormula(operation);

                      // 回答数カウント
                      answerCounter.value++;

                      number1.value =
                          (number1.value + 1) <= 3 ? (number1.value + 1) : 0;
                      number2.value =
                          (number2.value + 1) <= 3 ? (number2.value + 1) : 0;
                      number3.value =
                          (number3.value + 1) <= 3 ? (number3.value + 1) : 0;
                      number4.value =
                          (number4.value + 1) <= 3 ? (number4.value + 1) : 0;

                      // Next押下不可に設定
                      nextTapControl.value = false;
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(trainingUISize, trainingUISize),
                      shape: const CircleBorder(),
                      backgroundColor: AppColors.bgControlButton,
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.next,
                    ),
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
