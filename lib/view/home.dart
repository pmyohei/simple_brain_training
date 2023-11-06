// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import './app.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    //------------------------
    // UIサイズ
    //------------------------
    final deviceWidth = MediaQuery.of(context).size.width;
    final startUISize = deviceWidth * 0.3;
    final operationUISize = (deviceWidth * 0.7) / 4;
    final operationUIRadius = operationUISize * 0.1;

    //------------------------
    // 状態管理
    //------------------------
    // 状態監視：トレーニング情報
    final trainingInfoProvider = ref.watch(kTrainingInfoProvider);

    //------------------------
    // ホーム画面（トレーニング開始前）
    //------------------------
    return DecoratedBox(
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
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   title: const Text('widget.title'),
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                // margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text(
                  '脳トレについて色々記述',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              ElevatedButton(
                onPressed: trainingInfoProvider.changeOnTraining,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(startUISize, startUISize),
                  shape: const CircleBorder(),
                  textStyle: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                child: const Text('Start'),
              ),
              Container(
                // margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        trainingInfoProvider
                            .setOperation(OperationSelector.plus);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(operationUISize, operationUISize),
                        backgroundColor: trainingInfoProvider.operation ==
                                OperationSelector.plus
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(operationUIRadius),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      child: const Text('+'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        trainingInfoProvider
                            .setOperation(OperationSelector.minus);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(operationUISize, operationUISize),
                        backgroundColor: trainingInfoProvider.operation ==
                                OperationSelector.minus
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(operationUIRadius),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      child: const Text('-'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        trainingInfoProvider
                            .setOperation(OperationSelector.multiplication);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(operationUISize, operationUISize),
                        backgroundColor: trainingInfoProvider.operation ==
                                OperationSelector.multiplication
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(operationUIRadius),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      child: const Text('×'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        trainingInfoProvider
                            .setOperation(OperationSelector.division);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(operationUISize, operationUISize),
                        backgroundColor: trainingInfoProvider.operation ==
                                OperationSelector.division
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(operationUIRadius),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      child: const Text('÷'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
