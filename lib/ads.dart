
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class ads{

  static BannerAd? myBanner;
  static InterstitialAd? interstitialAd;
  static RewardedAd? rewardedAd;
  static int numRewardedLoadAttempts = 0;

  static int numInterstitialLoadAttempts = 0;
  static int maxFailedLoadAttempts = 3;

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  static bannerad() {
     myBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );

  }
  static loodinterad(){
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              loodinterad();
            }
          },
        ));
  }
  static showInterstitialAd(){
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loodinterad();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loodinterad();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }
  static createRewardeAd(){
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
            numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            rewardedAd = null;
            numRewardedLoadAttempts += 1;
            if (numRewardedLoadAttempts < maxFailedLoadAttempts) {
              createRewardeAd();
            }
          },
        ));
  }
  static showRewardedAd() {
   if (rewardedAd == null) {
     print('Warning: attempt to show rewarded before loaded.');
     return;
   }
   rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
     onAdShowedFullScreenContent: (RewardedAd ad) =>
         print('ad onAdShowedFullScreenContent.'),
     onAdDismissedFullScreenContent: (RewardedAd ad) {
       print('$ad onAdDismissedFullScreenContent.');
       ad.dispose();
       createRewardeAd();
     },
     onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
       print('$ad onAdFailedToShowFullScreenContent: $error');
       ad.dispose();
       createRewardeAd();
     },
   );

   rewardedAd!.setImmersiveMode(true);
   rewardedAd!.show(
       onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
         print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
       });
   rewardedAd = null;
 }

}