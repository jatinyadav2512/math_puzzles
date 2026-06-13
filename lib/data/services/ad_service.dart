import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

/// Manages the lifecycle of rewarded ads: preload → show → reload.
///
/// Uses Google's test ad unit IDs by default.
/// Replace with your real ad unit IDs before publishing.
class AdService {
  AdService();

  // Rewarded ad unit ID from AdMob.
  static const _rewardedAdUnitId = 'ca-app-pub-3100693371058056/1190525836';

  RewardedAd? _rewardedAd;
  Future<void>? _initFuture;
  Future<void>? _loadFuture;

  /// Initialize the Mobile Ads SDK and preload the first rewarded ad.
  Future<void> init() {
    _initFuture ??= _doInit();
    return _initFuture!;
  }

  Future<void> _doInit() async {
    await MobileAds.instance.initialize();
    await _loadRewardedAd();
  }

  /// Whether a rewarded ad is ready to show.
  bool get isRewardedAdReady => _rewardedAd != null;

  /// Load a rewarded ad into memory.
  Future<void> _loadRewardedAd() {
    if (_loadFuture != null) return _loadFuture!;

    final completer = Completer<void>();
    _loadFuture = completer.future;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _loadFuture = null;
          debugPrint('AdService: Rewarded ad loaded.');
          completer.complete();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _loadFuture = null;
          debugPrint('AdService: Rewarded ad failed to load: $error');
          completer.complete();
        },
      ),
    );

    return completer.future;
  }

  /// Show a rewarded ad. Returns `true` if the user earned the reward
  /// (watched to completion), `false` if they dismissed or no ad was ready.
  Future<bool> showRewardedAd() async {
    await init();
    
    if (_rewardedAd == null) {
      debugPrint('AdService: No rewarded ad ready. Attempting to load...');
      await _loadRewardedAd();
      if (_rewardedAd == null) return false;
    }

    final ad = _rewardedAd!;
    _rewardedAd = null;

    final Completer<bool> rewardCompleter = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(false);
        }
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdService: Ad failed to show: $error');
        ad.dispose();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(false);
        }
        _loadRewardedAd();
      },
    );

    await ad.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('AdService: User earned reward: ${reward.amount} ${reward.type}');
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(true);
        }
      },
    );

    return rewardCompleter.future;
  }

  /// Dispose of any loaded ad.
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}

