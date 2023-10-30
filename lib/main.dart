import 'package:flutter/material.dart';
import 'view/play_home.dart';

void main() {
  runApp(const SimpleBrainTrainingApp());
}

class SimpleBrainTrainingApp extends StatelessWidget {
  const SimpleBrainTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple BrainTraining',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PlayHome(title: 'Simple BrainTraining'),
    );
  }
}
