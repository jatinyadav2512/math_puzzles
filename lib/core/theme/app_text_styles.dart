import 'package:flutter/material.dart';

/// Semantic text styles. Colors are NOT baked in — inherit from theme.
/// See design.md §4 for the full spec.
///
/// Inter is the primary family; JetBrains Mono is used for equations and
/// the numpad. Both are shipped as local font assets registered in
/// pubspec.yaml (added when the TTF files are dropped in assets/fonts/).
/// Until then we fall back to the default system fonts.
class AppTextStyles {
  AppTextStyles._();

  // ─── Inter (or system fallback) ───

  static const displayLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
  );

  static const headline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
  );

  static const title = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  static const bodyEmphasis = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );

  // ─── JetBrains Mono (or system monospace fallback) ───

  static const riddleEquation = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w500,
  );

  static const riddleAnswer = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w700,
  );

  static const numpadKey = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
  );

  static const tileNumber = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );
}
