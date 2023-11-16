// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:simple_brain_training/configs/color.dart';
import '../ad_helper.dart';
import 'training.dart';

//------------------
// 外部変数
//------------------
// 演算子
enum OperationSelector { plus, minus, multiplication, division }

// トレーニング状態管理Provider
final kTrainingInfoProvider = ChangeNotifierProvider((ref) => TrainingInfo());

/*
 * トレーニング情報：状態管理
 */
class TrainingInfo extends ChangeNotifier {
  OperationSelector? _operation = OperationSelector.plus;
  OperationSelector? get operation => _operation;

  /*
  * 演算子の設定
  */
  void setOperation(OperationSelector? select) {
    _operation = select;
    notifyListeners();
  }
}

/*
 * Home画面Widget
 */
class Home extends HookConsumerWidget {
  Home({super.key});

  // バナー広告
  final bannerAD = AdHelper.getBannerAd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //------------------------
    // 広告
    //------------------------
    useEffect(
      () {
        // build初期処理
        bannerAD.load();

        // widget 終了時
        return bannerAD.dispose;
      },
      [],
    );

    //------------------------
    // UIサイズ
    //------------------------
    // 端末サイズ
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    print("deviceHeight=$deviceHeight");
    // ページ
    final homeTopMargin = deviceHeight * 0.1;
    final homeBottomMargin = deviceHeight * 0.05;
    // トレーニング説明エリア
    final trainingExplanationHeight = deviceHeight * 0.2;
    final trainingExplanationEdgePadding = deviceWidth * 0.1;
    // Startボタン
    final startUIResponsiveSize = deviceWidth * 0.3;
    final startUISize =
        (startUIResponsiveSize > 150.0) ? 150.0 : startUIResponsiveSize;
    final startUICottomMargin = deviceHeight * 0.1;
    // 演算子選択ボタン
    final operationUIResponsiveSize = (deviceWidth * 0.7) / 4;
    final operationUISize =
        (operationUIResponsiveSize > 90.0) ? 90.0 : operationUIResponsiveSize;
    final operationUIRadius = operationUISize * 0.1;

    //------------------------
    // 状態管理
    //------------------------
    // 状態監視：トレーニング情報
    final trainingInfoProvider = ref.watch(kTrainingInfoProvider);

    //--------------------------------
    // ホーム画面（トレーニング開始前）
    //--------------------------------
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
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0,
                    homeTopMargin,
                    0,
                    homeBottomMargin,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: trainingExplanationHeight,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              trainingExplanationEdgePadding,
                              0,
                              trainingExplanationEdgePadding,
                              0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.training_message,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.txAdvice,
                                height: 1.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          0,
                          0,
                          0,
                          startUICottomMargin,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) {
                                  return Training();
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(startUISize, startUISize),
                            shape: const CircleBorder(),
                            backgroundColor: AppColors.bgControlButton,
                            textStyle: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.start,
                            style: const TextStyle(
                              letterSpacing: 2,
                              color: AppColors.txButton,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              trainingInfoProvider
                                  .setOperation(OperationSelector.plus);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(operationUISize, operationUISize),
                              foregroundColor: trainingInfoProvider.operation ==
                                      OperationSelector.plus
                                  ? AppColors.txOperationButtonOn
                                  : AppColors.txOperationButtonOff,
                              backgroundColor: trainingInfoProvider.operation ==
                                      OperationSelector.plus
                                  ? AppColors.bgOperationButtonOn
                                  : AppColors.bgOperationButtonOff,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(operationUIRadius),
                              ),
                              textStyle: TextStyle(
                                fontSize: 32,
                                color: trainingInfoProvider.operation ==
                                        OperationSelector.plus
                                    ? AppColors.txOperationButtonOn
                                    : AppColors.txOperationButtonOff,
                              ),
                              alignment: Alignment.center,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.plus,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              trainingInfoProvider
                                  .setOperation(OperationSelector.minus);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(operationUISize, operationUISize),
                              foregroundColor: trainingInfoProvider.operation ==
                                      OperationSelector.minus
                                  ? AppColors.txOperationButtonOn
                                  : AppColors.txOperationButtonOff,
                              backgroundColor: trainingInfoProvider.operation ==
                                      OperationSelector.minus
                                  ? AppColors.bgOperationButtonOn
                                  : AppColors.bgOperationButtonOff,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(operationUIRadius),
                              ),
                              textStyle: TextStyle(
                                fontSize: 32,
                                color: trainingInfoProvider.operation ==
                                        OperationSelector.minus
                                    ? AppColors.txOperationButtonOn
                                    : AppColors.txOperationButtonOff,
                              ),
                              alignment: Alignment.center,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.minus,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              trainingInfoProvider.setOperation(
                                  OperationSelector.multiplication);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(operationUISize, operationUISize),
                              foregroundColor: trainingInfoProvider.operation ==
                                      OperationSelector.multiplication
                                  ? AppColors.txOperationButtonOn
                                  : AppColors.txOperationButtonOff,
                              backgroundColor: trainingInfoProvider.operation ==
                                      OperationSelector.multiplication
                                  ? AppColors.bgOperationButtonOn
                                  : AppColors.bgOperationButtonOff,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(operationUIRadius),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 32,
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.multiplication,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              trainingInfoProvider
                                  .setOperation(OperationSelector.division);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(operationUISize, operationUISize),
                              foregroundColor: trainingInfoProvider.operation ==
                                      OperationSelector.division
                                  ? AppColors.txOperationButtonOn
                                  : AppColors.txOperationButtonOff,
                              backgroundColor: trainingInfoProvider.operation ==
                                      OperationSelector.division
                                  ? AppColors.bgOperationButtonOn
                                  : AppColors.bgOperationButtonOff,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(operationUIRadius),
                              ),
                              textStyle: TextStyle(
                                fontSize: 32,
                                color: trainingInfoProvider.operation ==
                                        OperationSelector.division
                                    ? AppColors.txOperationButtonOn
                                    : AppColors.txOperationButtonOff,
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.division,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: bannerAD.size.width.toDouble(),
                height: bannerAD.size.height.toDouble(),
                child: AdWidget(
                  ad: bannerAD,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
