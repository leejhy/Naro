import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naro/const.dart';

class AdManager {
  static final AdManager instance = AdManager._internal();
  RewardedAd? rewardedAd;

  AdManager._internal();

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: testAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('RewardedAd loaded');
          rewardedAd = ad;
          _setCallbacks(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          rewardedAd = null;
        },
      ),
    );
  }

  void _setCallbacks(RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => debugPrint('Ad shown'),
      onAdImpression: (ad) => debugPrint('Ad impression'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('Ad dismissed');
        ad.dispose();
        rewardedAd = null;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        debugPrint('Ad failed to show: $err');
        ad.dispose();
        rewardedAd = null;
        loadRewardedAd();
      },
      onAdClicked: (ad) => debugPrint('Ad clicked'),
    );
  }

  void showRewardedAd(VoidCallback onRewardEarned) {
    if (rewardedAd != null) {
      rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('Reward earned: ${reward.amount} ${reward.type}');
          onRewardEarned();
        },
      );
    } else {
      debugPrint('RewardedAd not ready yet.');
    }
  }
}
