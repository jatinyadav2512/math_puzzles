import 'package:math_riddles/data/services/ad_service.dart';
import 'package:math_riddles/data/services/hint_service.dart';

/// Hint service that requires watching a rewarded ad before revealing the hint.
///
/// Replaces `FreeHintService` for monetization. See architecture.md §2.15.
class RewardedAdHintService implements HintService {
  RewardedAdHintService({required this.adService});

  final AdService adService;

  @override
  Future<bool> requestHint(String riddleId) async {
    // Show a rewarded ad — returns true only if the user watched it fully.
    return adService.showRewardedAd();
  }
}
