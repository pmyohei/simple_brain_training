import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home.dart';
import 'training.dart';

// 演算子
enum OperationSelector { plus, minus, multiplication, division }

extension OperationSelectorExt on OperationSelector {
  String get name {
    switch (this) {
      case OperationSelector.plus:
        return '+';
      case OperationSelector.minus:
        return '-';
      case OperationSelector.multiplication:
        return '×';
      case OperationSelector.division:
        return '÷';
    }
  }
}

final TrainingInfoProvider = ChangeNotifierProvider((ref) => TrainingInfo());

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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //------------------------
    // 状態管理
    //------------------------
    // 状態監視：トレーニング情報
    var trainingInfoProvider = ref.watch(TrainingInfoProvider);

    //------------------------
    // 表示
    //------------------------
    // 表示ページを取得
    Widget page = getPage(trainingInfoProvider.onTraining);

    return MaterialApp(
      title: 'Simple BrainTraining',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 208, 180, 255)),
        useMaterial3: true,
      ),
      home: page,
    );
  }

  /*
  * 表示ページの取得
  */
  Widget getPage(bool onTraining) {
    // print("getPage() $operation");
    return (onTraining) ? Training() : Home();
  }
}
