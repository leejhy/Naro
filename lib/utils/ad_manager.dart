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
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          _setCallbacks(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          rewardedAd = null;
        },
      ),
    );
  }

  void _setCallbacks(RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => {},
      onAdImpression: (ad) => {},
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        rewardedAd = null;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        rewardedAd = null;
        loadRewardedAd();
      },
      onAdClicked: (ad) => {},
    );
  }

  void showRewardedAd(VoidCallback onRewardEarned) {
    if (rewardedAd != null) {
      rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onRewardEarned();
        },
      );
    } else {
    }
  }
}
