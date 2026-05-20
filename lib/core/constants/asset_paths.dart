/// Centralised asset path references. No string literals in widgets.
class AssetPaths {
  AssetPaths._();

  // Data
  static const String riddlesJson = 'assets/data/riddles.json';
  static const String riddlesDiagramSamplesJson =
      'assets/data/riddles_diagrams_samples.json';

  // Audio
  static const String soundCorrect = 'audio/correct.mp3';
  static const String soundWrong = 'audio/wrong.mp3';
  static const String soundTap = 'audio/tap.mp3';

  // Images
  static const String onboardingWelcome =
      'assets/images/onboarding/welcome.png';
  static const String onboardingHowToPlay =
      'assets/images/onboarding/how_to_play.png';
  static const String onboardingDifficulty =
      'assets/images/onboarding/difficulty.png';
}
