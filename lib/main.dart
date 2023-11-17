// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //-----------
  // Admob
  //-----------
  MobileAds.instance.initialize();
  //-----------
  // 画面向き
  //-----------
  SystemChrome.setPreferredOrientations([
    // 縦向きのみ許可
    DeviceOrientation.portraitUp,
  ]).then((_) {
    //-----------
    // App 起動
    //-----------
    runApp(const ProviderScope(child: SimpleBrainTrainingApp()));
  });
}
