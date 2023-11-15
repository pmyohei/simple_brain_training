// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'home.dart';
import 'training.dart';

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
    // 表示ページを取得
    final page = getPage(onTraining: trainingInfoProvider.onTraining);

    return MaterialApp(
      title: 'Simple BrainTraining',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 208, 180, 255),
        ),
        useMaterial3: true,
      ),
      home: page,
    );
  }

  /*
  * 表示ページの取得
  */
  Widget getPage({required bool onTraining}) {
    return onTraining ? Training() : Home();
  }
}
