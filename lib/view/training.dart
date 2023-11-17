// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

// Project imports:
import './home.dart';
import '../trainingLogic/question.dart';
import 'package:simple_brain_training/configs/color.dart';

/*
 * トレーニング画面
 */
class Training extends HookConsumerWidget {
  Training({super.key}) {
    _stopWatchTimer.onStartTimer();
  }

  // ストップウォッチタイマー
  final _stopWatchTimer = StopWatchTimer();
  // 計算式リスト
  final List<String> formulaList = [
    '',
    '',
    '',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //------------------------
    // UIサイズ
    //------------------------
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    // トレーニング情報
    final trainingAreaTopMargin = deviceWidth * 0.2;
    final trainingAreaBottomMargin = deviceWidth * 0.1;
    final trainingAreaEdgePadding = deviceWidth * 0.1;
    // トレーニングUI
    final trainingUISize = deviceWidth * 0.2;
    // 計算式トップマージン
    final formulaTopMargin = calcFormulaTopMargin(deviceHeight: deviceHeight);

    //------------------------
    // 状態管理
    //------------------------
    // トレーニング情報
    final trainingInfoProvider = ref.watch(kTrainingInfoProvider);
    final operation = trainingInfoProvider.operation;
    // 回答数
    final answerCounter = useState(0);
    // 計算式位置
    final number1 = useState(3);
    final number2 = useState(2);
    final number3 = useState(1);
    final number4 = useState(0);

    // Next押下制御
    final nextTapControl = useState(true);

    //------------------------
    // 初期化
    //------------------------
    useEffect(
      () {
        // build初期処理
        initFormulaList(operation);

        // widget 終了時
        return null;
      },
      [],
    );

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
          child: Container(
            margin: EdgeInsets.fromLTRB(
              0,
              trainingAreaTopMargin,
              0,
              trainingAreaBottomMargin,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //------------------------
                // 画面上部
                //------------------------
                Container(
                  margin: EdgeInsets.fromLTRB(
                    trainingAreaEdgePadding,
                    0,
                    trainingAreaEdgePadding,
                    0,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.borderTrainingInfo,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, formulaTopMargin, 0, 0),
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: <Widget>[
                        _constrolBuildFormula(
                          formulaList,
                          number1.value,
                          nextTapControl,
                        ),
                        _constrolBuildFormula(
                          formulaList,
                          number2.value,
                          nextTapControl,
                        ),
                        _constrolBuildFormula(
                          formulaList,
                          number3.value,
                          nextTapControl,
                        ),
                        _constrolBuildFormula(
                          formulaList,
                          number4.value,
                          nextTapControl,
                        ),
                      ],
                    ),
                  ),
                ),

                //------------------------
                // 操作ボタン
                //------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // HomeUI
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
                        style: const TextStyle(
                          letterSpacing: 2,
                          color: AppColors.txButton,
                        ),
                      ),
                    ),
                    // NextUI
                    ElevatedButton(
                      onPressed: () {
                        //--------------------
                        // 計算式入れ替え中判定
                        //--------------------
                        if (!nextTapControl.value) {
                          // 入れ替え中なら処理なし
                          return;
                        }

                        //--------------------
                        // 計算式入れ替え
                        //--------------------
                        formulaList
                          ..removeAt(0)
                          ..add(Question().getFormula(operation));

                        //--------------------
                        // 回答数カウント
                        //--------------------
                        answerCounter.value++;

                        //--------------------
                        // 計算式位置の更新
                        //--------------------
                        number1.value =
                            (number1.value + 1) <= 3 ? (number1.value + 1) : 0;
                        number2.value =
                            (number2.value + 1) <= 3 ? (number2.value + 1) : 0;
                        number3.value =
                            (number3.value + 1) <= 3 ? (number3.value + 1) : 0;
                        number4.value =
                            (number4.value + 1) <= 3 ? (number4.value + 1) : 0;

                        //--------------------
                        // Next押下制御
                        //--------------------
                        // 押下不可
                        nextTapControl.value = false;
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(trainingUISize, trainingUISize),
                        shape: const CircleBorder(),
                        backgroundColor: AppColors.bgControlButton,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: AppColors.txButton,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.next,
                        style: const TextStyle(
                          letterSpacing: 2,
                          color: AppColors.txButton,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
  * 計算式widget構築制御
  */
  Widget _constrolBuildFormula(
    List<String> formulas,
    int number,
    ValueNotifier<bool> nextTapControl,
  ) {
    //-------------------------------------------
    // 位置に応じたアニメーションを行うwidgetを構築
    //-------------------------------------------
    switch (number) {
      // 一番上
      case 3:
        return _buildFormula(
          top: 0,
          form: formulas[0],
          duration: 200,
          fontSize: 50,
          nextTapControl: nextTapControl,
        );

      // 上から2番目
      case 2:
        return _buildFormula(
          top: 80,
          form: formulas[1],
          duration: 200,
          fontSize: 30,
          nextTapControl: nextTapControl,
        );

      // 上から3番目
      case 1:
        return _buildFormula(
          top: 140,
          form: formulas[2],
          duration: 200,
          fontSize: 16,
          nextTapControl: nextTapControl,
        );

      // 待機用
      case 0:
      default:
        return _buildFormula(
          top: 160,
          form: '',
          duration: 1,
          fontSize: 0,
          nextTapControl: nextTapControl,
        );
    }
  }

  /*
  * 計算式widget構築
  */
  Widget _buildFormula({
    required double top,
    required String form,
    required int duration,
    required double fontSize,
    required ValueNotifier<bool> nextTapControl,
  }) {
    //---------------------------------
    // アニメーション：テキストサイズ
    //---------------------------------
    return AnimatedDefaultTextStyle(
      style: TextStyle(fontSize: fontSize),
      duration: Duration(milliseconds: duration),
      curve: Curves.fastOutSlowIn,

      //---------------------------------
      // アニメーション：位置
      //---------------------------------
      child: AnimatedPositioned(
        top: top,
        duration: Duration(milliseconds: duration),
        curve: Curves.fastOutSlowIn,
        onEnd: () {
          if (top == 0) {
            // 最上部計算式のアニメーション終了で、NextUI押下可能にする
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
    //--------------
    // 初期設定
    //--------------
    formulaList[0] = Question().getFormula(operation);
    formulaList[1] = Question().getFormula(operation);
    formulaList[2] = Question().getFormula(operation);
  }

  /*
  * 計算式リスト初期化
  */
  double calcFormulaTopMargin({required double deviceHeight}) {
    //------------------------------
    // デバイスサイズに応じた割合を返す
    //------------------------------
    if (deviceHeight <= 700) {
      return deviceHeight * 0.12;
    }

    if (deviceHeight <= 800) {
      return deviceHeight * 0.15;
    }

    return deviceHeight * 0.2;
  }
}
