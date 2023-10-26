import 'package:flutter/material.dart';
import 'package:simple_brain_training/trainingLogic/question.dart';

class PlayHome extends StatefulWidget {
  const PlayHome({super.key, required this.title});

  final String title;

  @override
  State<PlayHome> createState() => _PlayHomeState();
}

class _PlayHomeState extends State<PlayHome> {
  String _quiestion1 = '';
  String _quiestion2 = '';
  String _quiestion3 = '';

  _PlayHomeState() {
    _initPlayData();
  }

  /*
   * 初期化
   */
  void _initPlayData() {
    _quiestion1 = Question().getQuestion();
    _quiestion2 = Question().getQuestion();
    _quiestion3 = Question().getQuestion();
  }

  /*
   * 次の問題へ
   */
  void _nextQuestion() {
    setState(() {
      // 出題の問題を入れ替え
      _quiestion1 = _quiestion2;
      _quiestion2 = _quiestion3;
      _quiestion3 = Question().getQuestion();
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
