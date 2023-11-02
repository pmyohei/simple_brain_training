import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './app.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    //------------------------
    // 状態管理
    //------------------------
    // 状態監視：トレーニング情報
    var trainingInfoProvider = ref.watch(TrainingInfoProvider);

    //------------------------
    // ホーム画面（トレーニング開始前）
    //------------------------
    return Container(
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
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      trainingInfoProvider.setOperation(OperationSelector.plus);
                    },
                    child: const Text('+'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(40, 40),
                        backgroundColor: trainingInfoProvider.operation ==
                                OperationSelector.plus
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      trainingInfoProvider
                          .setOperation(OperationSelector.minus);
                    },
                    child: const Text('-'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(40, 40),
                        backgroundColor: trainingInfoProvider.operation ==
                                OperationSelector.minus
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      trainingInfoProvider
                          .setOperation(OperationSelector.multiplication);
                    },
                    child: const Text('×'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(40, 40),
                        backgroundColor: trainingInfoProvider.operation ==
                                OperationSelector.multiplication
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      trainingInfoProvider
                          .setOperation(OperationSelector.division);
                    },
                    child: const Text('÷'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(40, 40),
                        backgroundColor: trainingInfoProvider.operation ==
                                OperationSelector.division
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2))),
                  ),
                  // ListTile(
                  //   leading: Radio<OperationSelector>(
                  //     value: OperationSelector.plus,
                  //     groupValue: trainingInfoProvider.operation,
                  //     onChanged: (OperationSelector? value) {
                  //       trainingInfoProvider.setOperation(value);
                  //       print("演算子設定確認 $value");
                  //     },
                  //   ),
                  //   title: const Text('+'),
                  // ),
                  // ListTile(
                  //   leading: Radio<OperationSelector>(
                  //     value: OperationSelector.minus,
                  //     groupValue: trainingInfoProvider.operation,
                  //     onChanged: (OperationSelector? value) {
                  //       trainingInfoProvider.setOperation(value);
                  //     },
                  //   ),
                  //   title: const Text('-'),
                  // ),
                  // ListTile(
                  //   leading: Radio<OperationSelector>(
                  //     value: OperationSelector.multiplication,
                  //     groupValue: trainingInfoProvider.operation,
                  //     onChanged: (OperationSelector? value) {
                  //       trainingInfoProvider.setOperation(value);
                  //     },
                  //   ),
                  //   title: const Text('×'),
                  // ),
                  // ListTile(
                  //   leading: Radio<OperationSelector>(
                  //     value: OperationSelector.division,
                  //     groupValue: trainingInfoProvider.operation,
                  //     onChanged: (OperationSelector? value) {
                  //       trainingInfoProvider.setOperation(value);
                  //     },
                  //   ),
                  //   title: const Text('÷'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
