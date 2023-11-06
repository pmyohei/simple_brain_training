// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:simple_brain_training/trainingLogic/question.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

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

// 演算子：文字
// Map<OperationSelector, String> operationCharacter = {
//   OperationSelector.plus: '+',
//   OperationSelector.minus: '-',
//   OperationSelector.multiplication: '×',
//   OperationSelector.division: '÷'
// };

class _HomeState extends State<Home> {
  // ユーザー選択演算子
  OperationSelector? _operation = OperationSelector.plus;

  // 問題となる計算式
  String _quiestion1 = '';
  String _quiestion2 = '';
  String _quiestion3 = '';

  // 回答数
  int _answer_counter = 0;

  _HomeState() {
    _initPlayData();
  }

  /*
   * 初期化
   */
  void _initPlayData() {
    _quiestion1 = Question().getPlusFormula();
    _quiestion2 = Question().getPlusFormula();
    _quiestion3 = Question().getPlusFormula();
  }

  /*
   * 次の問題へ
   */
  void _nextQuestion() {
    setState(() {
      //-------------------
      // 回答カウント
      //-------------------
      _answer_counter++;

      //-------------------
      // 新しい計算式
      //-------------------
      String newFormula;

      switch (_operation) {
        case OperationSelector.plus:
          newFormula = Question().getPlusFormula();
          break;

        case OperationSelector.minus:
          newFormula = Question().getMinusFormula();
          break;

        case OperationSelector.multiplication:
          newFormula = Question().getMultiFormula();
          break;

        case OperationSelector.division:
          newFormula = Question().getDivisionFormula();
          break;

        default:
          newFormula = Question().getPlusFormula();
          break;
      }

      // 問題入れ替え
      _quiestion1 = _quiestion2;
      _quiestion2 = _quiestion3;
      _quiestion3 = newFormula;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_answer_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$_quiestion1',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$_quiestion2',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$_quiestion3',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: const Text('+'),
                  leading: Radio<OperationSelector>(
                    value: OperationSelector.plus,
                    groupValue: _operation,
                    onChanged: (OperationSelector? value) {
                      setState(() {
                        _operation = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('-'),
                  leading: Radio<OperationSelector>(
                    value: OperationSelector.minus,
                    groupValue: _operation,
                    onChanged: (OperationSelector? value) {
                      setState(() {
                        _operation = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('×'),
                  leading: Radio<OperationSelector>(
                    value: OperationSelector.multiplication,
                    groupValue: _operation,
                    onChanged: (OperationSelector? value) {
                      setState(() {
                        _operation = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('÷'),
                  leading: Radio<OperationSelector>(
                    value: OperationSelector.division,
                    groupValue: _operation,
                    onChanged: (OperationSelector? value) {
                      setState(() {
                        _operation = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextQuestion,
        tooltip: '次の問題へ',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
