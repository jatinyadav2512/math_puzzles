/// App-wide constants. Change values here, not in widgets.
class AppConstants {
  AppConstants._();

  static const String appName = 'Math Puzzles';
  static const String appTagline = 'Train your brain, one puzzle a day.';

  // Pending — decide before Phase 7
  static const String privacyPolicyUrl =
      'https://docs.google.com/document/d/e/2PACX-1vR_eFhhnbrCpY4E6DUn0tx5kMEdCvBwOnDQryRamoU7OSSEjNApywT6vSgwMhRkAOuuqufg0e45r1Jq/pub';
  static const String playStoreUrl = '';

  static const int bucketCount = 10;
  static const int riddlesPerBucket = 10;

  /// Tier display names, one per bucket (0..9). Two tiers per difficulty band.
  static const List<String> tierNames = [
    'Rookie',
    'Easy',
    'Rising',
    'Steady',
    'Clever',
    'Tricky',
    'Sharp',
    'Expert',
    'Genius',
    'Master',
  ];

  static const String sharedPrefsPrefix = 'mr.';
  static const int schemaVersion = 1;
}
