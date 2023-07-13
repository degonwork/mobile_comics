import 'package:google_mobile_ads/google_mobile_ads.dart';

class ADSRepo {
  static RewardedAd? rewardedAd;

  static void loadADS() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) {
              rewardedAd = ad;
            },
            onAdFailedToLoad: (error) {}));
  }

  static void showADS() async {
    rewardedAd!.show(onUserEarnedReward: (ad, reward) {});
    await rewardedAd!.dispose();
    loadADS();
  }
}
