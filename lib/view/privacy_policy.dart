/* ==================================
  プライバシーポリシー誠意画面
    ※現在未使用
   ================================== */

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:simple_brain_training/configs/color.dart';
import '../ad_helper.dart';
import 'training.dart';

/*
 * PrivacyPolicy画面Widget
 */
class PrivacyPolicy extends HookConsumerWidget {
  PrivacyPolicy({super.key});

  // バナー広告
  final bannerAD = AdHelper.getBannerAd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //--------------------------------
    // ホーム画面（トレーニング開始前）
    //--------------------------------
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.9],
          colors: AppColors.mainBgGradation,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.privacy_policy_link,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.txAdvice,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
