// ignore_for_file: avoid_print

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';

  String get appOpenAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/3419835294'
      : 'ca-app-pub-3940256099942544/3419835294';

  String get appInterstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712';

  BannerAdListener get adListener => _adListener;

  AppOpenAdLoadCallback get appOpenAdLoadCallback => _appOpenAdLoadCallback;

  InterstitialAdLoadCallback get interstitialAdLoadCallback =>
      _interstitialAdLoadCallback;

  final AppOpenAdLoadCallback _appOpenAdLoadCallback = AppOpenAdLoadCallback(
    onAdLoaded: (ad) {
      print('Ad loaded: ${ad.adUnitId}');
      ad.show();
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) => ad.dispose(),
        onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose(),
      );
    },
    onAdFailedToLoad: (error) => print('Ad failed to load: ${error.message}'),
  );

  final BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad failed to load: ${ad.adUnitId}, $error'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}'),
    onAdWillDismissScreen: (ad) =>
        print('Ad will dismiss screen: ${ad.adUnitId}'),
    onAdImpression: (ad) => print('Ad impression: ${ad.adUnitId}'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}'),
    onPaidEvent: (ad, value, precision, text) =>
        print('Paid event: ${ad.adUnitId}, $value, $precision, $text'),
    onAdClicked: (ad) => print('Ad clicked: ${ad.adUnitId}'),
  );

  final InterstitialAdLoadCallback _interstitialAdLoadCallback =
      InterstitialAdLoadCallback(
    onAdLoaded: (ad) {
      print('Ad loaded: ${ad.adUnitId}');
      ad.show();
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) => ad.dispose(),
        onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose(),
      );
    },
    onAdFailedToLoad: (error) => print('Ad failed to load: ${error.message}'),
  );

  loadAdOnAppOpen() async {
    await AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: _appOpenAdLoadCallback,
      orientation: AppOpenAd.orientationPortrait,
    );
  }

  loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: appInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: _interstitialAdLoadCallback,
    );
  }
}
