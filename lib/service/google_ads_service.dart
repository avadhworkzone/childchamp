import 'dart:io';
import 'package:childchamp/utils/const_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsService {
  static const request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  static String interstitialAdsKey = '';
  static String bannerAdsKey = '';
  static String appOpenAdsKey = '';
  static const int maxFailedLoadAttempts = 3;
  static AppOpenAd? _myAppOpenAd;
  static InterstitialAd? interstitialAd;
  static int _numInterstitialLoadAttempts = 0;

  // static BannerAd? _bannerAd;
  // static int _numBannerLoadAttempts = 0;
  // static RewardedAd? rewardedAd;
  // static int _numRewardedLoadAttempts = 0;
  // static RewardedInterstitialAd? rewardedInterstitialAd;
  // static int _numRewardedInterstitialLoadAttempts = 0;

  /// ------------------------- GET ADS KEY FROM FIREBASE -------------------------- ///

  static Future<void> getAdsKeyFromFirebase() async {
    final doc = await FirebaseFirestore.instance
        .collection(kDebugMode ? 'AdminDev' : 'Admin')
        .doc('admin')
        .get();

    if (doc.exists) {
      if (Platform.isAndroid) {
        if (doc.data()!.containsKey('androidInterstitialAdsKey')) {
          interstitialAdsKey = doc.data()!['androidInterstitialAdsKey'];
        }
        if (doc.data()!.containsKey('androidBannerAdsKey')) {
          bannerAdsKey = doc.data()!['androidBannerAdsKey'];
        }
        if (doc.data()!.containsKey('androidAppOpenAdsKey')) {
          appOpenAdsKey = doc.data()!['androidAppOpenAdsKey'];
        }
      }
      // else if (Platform.isIOS) {
      //   if (doc.data()!.containsKey('iosInterstitialAdsKey')) {
      //     interstitialAdsKey = doc.data()!['iosInterstitialAdsKey'];
      //   }
      //   if (doc.data()!.containsKey('iosBannerAdsKey')) {
      //     bannerAdsKey = doc.data()!['iosBannerAdsKey'];
      //   }
      // }
    }
    createInterstitialAd();
    // createRewardedAd();
    // createRewardedInterstitialAd();
  }

  static void disposeAdsController() {
    interstitialAd?.dispose();
    // rewardedAd?.dispose();
    // rewardedInterstitialAd?.dispose();
  }

  /// ------------------------- APP OPEN ADS ------------------------- ///
/*  static loadAppOpenAd() {
    print('appOpenAdsKey:=>$appOpenAdsKey');
    AppOpenAd.load(
        adUnitId: appOpenAdsKey, //Your ad Id from admob
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              _myAppOpenAd = ad;
              _myAppOpenAd!.show();
            },
            onAdFailedToLoad: (error) {}),
        orientation: AppOpenAd.orientationPortrait);
  }*/

  /// ------------------------- InterstitialAd ------------------------- ///
  static void createInterstitialAd() {
    logs('adsKey:=>$interstitialAdsKey');
    InterstitialAd.load(
        adUnitId: interstitialAdsKey,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            logs('$ad loaded');
            interstitialAd = ad;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            logs('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  static Future<void> showInterstitialAd() async {
    if (interstitialAd == null) {
      logs('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          logs('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        logs('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        logs('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    await interstitialAd!.show();
    interstitialAd = null;
  }

  /// ------------------------- RewardedAd ------------------------- ///
/*  static void createRewardedAd() {
    RewardedAd.load(
        adUnitId: interstitialAdsKey,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  static void showRewardedAd() {
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
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedAd = null;
  }*/

  /// ------------------------- RewardedInterstitialAd ------------------------- ///
/*  static void createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: interstitialAdsKey,
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createRewardedInterstitialAd();
            }
          },
        ));
  }

  static void showRewardedInterstitialAd() {
    if (rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedInterstitialAd();
      },
    );

    rewardedInterstitialAd!.setImmersiveMode(true);
    rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    rewardedInterstitialAd = null;
  }*/
}
