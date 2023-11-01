import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './app.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //------------------------
    // 状態管理
    //------------------------
    // 状態監視：トレーニング情報
    var trainingInfoProvider = ref.watch(TrainingInfoProvider);

    //------------------------
    // ホーム画面（トレーニング開始前）
    //------------------------
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("widget.title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '脳トレについて色々記述',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                trainingInfoProvider.changeOnTraining();
              },
              child: const Text('Start'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 100),
                shape: const CircleBorder(),
              ),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Radio<OperationSelector>(
                    value: OperationSelector.plus,
                    groupValue: trainingInfoProvider.operation,
                    onChanged: (OperationSelector? value) {
                      trainingInfoProvider.setOperation(value);
                      print("演算子設定確認 $value");
                    },
                  ),
                  title: const Text('+'),
                ),
                ListTile(
                  leading: Radio<OperationSelector>(
                    value: OperationSelector.minus,
                    groupValue: trainingInfoProvider.operation,
                    onChanged: (OperationSelector? value) {
                      trainingInfoProvider.setOperation(value);
                    },
                  ),
                  title: const Text('-'),
                ),
                ListTile(
                  leading: Radio<OperationSelector>(
                    value: OperationSelector.multiplication,
                    groupValue: trainingInfoProvider.operation,
                    onChanged: (OperationSelector? value) {
                      trainingInfoProvider.setOperation(value);
                    },
                  ),
                  title: const Text('×'),
                ),
                ListTile(
                  leading: Radio<OperationSelector>(
                    value: OperationSelector.division,
                    groupValue: trainingInfoProvider.operation,
                    onChanged: (OperationSelector? value) {
                      trainingInfoProvider.setOperation(value);
                    },
                  ),
                  title: const Text('÷'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
