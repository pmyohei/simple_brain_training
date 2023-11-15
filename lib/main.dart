// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'ad_helper.dart';
import 'view/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // AdHelper.initialization();
  runApp(const ProviderScope(child: SimpleBrainTrainingApp()));
}
