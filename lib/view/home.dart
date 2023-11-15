// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_brain_training/configs/color.dart';
import 'package:simple_brain_training/gen/fonts.gen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import '../ad_helper.dart';
import './training.dart';
import './training_test.dart';
import './training_test2.dart';
import './training_anim.dart';

// 演算子
enum OperationSelector { plus, minus, multiplication, division }

// トレーニング状態管理Provider
final kTrainingInfoProvider = ChangeNotifierProvider((ref) => TrainingInfo());

class TrainingInfo extends ChangeNotifier {
  var _onTraining = false;
  bool get onTraining => _onTraining;

  OperationSelector? _operation = OperationSelector.plus;
  OperationSelector? get operation => _operation;

  /*
  * トレーニング開始／終了切り替え
  */
  void changeOnTraining() {
    _onTraining = !_onTraining;
    notifyListeners();
  }

  /*
  * 演算子の設定
  */
  void setOperation(OperationSelector? select) {
    _operation = select;
    notifyListeners();
  }
}

/*
 * App
 */
class SimpleBrainTrainingApp extends ConsumerWidget {
  const SimpleBrainTrainingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //------------------------
    // 状態管理
    //------------------------
    // 状態監視：トレーニング情報
    final trainingInfoProvider = ref.watch(kTrainingInfoProvider);

    //------------------------
    // 表示
    //------------------------
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // 英語
        Locale('ja', ''), // 日本語
        Locale('hi', ''), // ヒンディー語
      ],
      title: 'Simple BrainTraining',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 208, 180, 255),
        ),
        fontFamily: FontFamily.zenKakuGothicNew,
        useMaterial3: true,
      ),
      home: Home(),
    );
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
    final theme = Theme.of(context);

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
    final deviceWidth = MediaQuery.of(context).size.width;
    // Startボタン
    final startUIResponsiveSize = deviceWidth * 0.3;
    final startUISize =
        (startUIResponsiveSize > 150.0) ? 150.0 : startUIResponsiveSize;
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) {
                        return TrainingAnim();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      trainingInfoProvider.setOperation(OperationSelector.plus);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(operationUISize, operationUISize),
                      foregroundColor: trainingInfoProvider.operation ==
                              OperationSelector.plus
                          ? AppColors.txOperationButtonOn
                          : AppColors.txOperationButtonOff,
                      backgroundColor: trainingInfoProvider.operation ==
                              OperationSelector.plus
                          ? AppColors.bgOperationButtonOn
                          : AppColors.bgOperationButtonOff,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(operationUIRadius),
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
                      minimumSize: Size(operationUISize, operationUISize),
                      foregroundColor: trainingInfoProvider.operation ==
                              OperationSelector.minus
                          ? AppColors.txOperationButtonOn
                          : AppColors.txOperationButtonOff,
                      backgroundColor: trainingInfoProvider.operation ==
                              OperationSelector.minus
                          ? AppColors.bgOperationButtonOn
                          : AppColors.bgOperationButtonOff,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(operationUIRadius),
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
                      trainingInfoProvider
                          .setOperation(OperationSelector.multiplication);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(operationUISize, operationUISize),
                      foregroundColor: trainingInfoProvider.operation ==
                              OperationSelector.multiplication
                          ? AppColors.txOperationButtonOn
                          : AppColors.txOperationButtonOff,
                      backgroundColor: trainingInfoProvider.operation ==
                              OperationSelector.multiplication
                          ? AppColors.bgOperationButtonOn
                          : AppColors.bgOperationButtonOff,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(operationUIRadius),
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
                      minimumSize: Size(operationUISize, operationUISize),
                      foregroundColor: trainingInfoProvider.operation ==
                              OperationSelector.division
                          ? AppColors.txOperationButtonOn
                          : AppColors.txOperationButtonOff,
                      backgroundColor: trainingInfoProvider.operation ==
                              OperationSelector.division
                          ? AppColors.bgOperationButtonOn
                          : AppColors.bgOperationButtonOff,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(operationUIRadius),
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
