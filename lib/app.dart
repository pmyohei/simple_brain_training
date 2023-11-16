// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:simple_brain_training/gen/fonts.gen.dart';
import 'view/home.dart';

/*
 * App
 */
class SimpleBrainTrainingApp extends ConsumerWidget {
  const SimpleBrainTrainingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //------------------------
    // 表示
    //------------------------
    return MaterialApp(
      // "debug"非表示
      debugShowCheckedModeBanner: false,
      // 多言語対応
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
        Locale('ko', ''), // 韓国語
      ],
      // タイトル／テーマ
      title: 'SimpleBrainTraining',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 208, 180, 255),
        ),
        fontFamily: FontFamily.zenKakuGothicNew,
        useMaterial3: true,
      ),
      // トップページ
      home: Home(),
    );
  }
}
