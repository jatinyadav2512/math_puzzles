/// Hint gating service. Swappable via Provider.
///
/// v0 uses `FreeHintService` (always allow). Later: `RewardedAdHintService`.
/// See architecture.md §2.15.
// ignore: one_member_abstracts
abstract class HintService {
  /// Returns true if the user is permitted to see the hint for [riddleId].
  Future<bool> requestHint(String riddleId);
}

/// Always-free hint service for v0.
class FreeHintService implements HintService {
  @override
  Future<bool> requestHint(String riddleId) async => true;
}
