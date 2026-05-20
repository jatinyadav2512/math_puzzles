import 'package:flutter/material.dart';

/// Semantic color tokens. Every color used in the app comes from here.
/// See design.md §3 for the full spec.
// ignore_for_file: use_enums
class AppColors {
  const AppColors._({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.onBackground,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.divider,
    required this.success,
    required this.error,
    required this.warning,
    required this.lockedTile,
    required this.solvedTile,
    required this.currentTileGlow,
    required this.easyAccent,
    required this.mediumAccent,
    required this.hardAccent,
    required this.expertAccent,
    required this.masterAccent,
  });

  // Brand — shared across themes
  static const Color brandPrimary = Color(0xFF6C5CE7);
  static const Color brandPrimaryDark = Color(0xFF5546C7);
  static const Color brandSecondary = Color(0xFF00C2A8);

  // ─── Light ───
  static const light = AppColors._(
    background: Color(0xFFF7F7FB),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEEEEF6),
    onBackground: Color(0xFF1A1A2E),
    onSurface: Color(0xFF1A1A2E),
    onSurfaceMuted: Color(0xFF5A5A78),
    divider: Color(0xFFE3E3EE),
    success: Color(0xFF19B26B),
    error: Color(0xFFE5484D),
    warning: Color(0xFFF5A524),
    lockedTile: Color(0xFFD6D6E0),
    solvedTile: Color(0xFFDCF7E8),
    currentTileGlow: Color(0xFF6C5CE7),
    easyAccent: Color(0xFF19B26B),
    mediumAccent: Color(0xFF3FA7FF),
    hardAccent: Color(0xFFA06BFF),
    expertAccent: Color(0xFFFF8A3D),
    masterAccent: Color(0xFFE5484D),
  );

  // ─── Dark ───
  static const dark = AppColors._(
    background: Color(0xFF0F1020),
    surface: Color(0xFF1A1B33),
    surfaceMuted: Color(0xFF23253F),
    onBackground: Color(0xFFF2F2F7),
    onSurface: Color(0xFFF2F2F7),
    onSurfaceMuted: Color(0xFFA0A0BB),
    divider: Color(0xFF2C2E48),
    success: Color(0xFF3BD986),
    error: Color(0xFFFF6B6B),
    warning: Color(0xFFFFB454),
    lockedTile: Color(0xFF2A2C46),
    solvedTile: Color(0xFF1F3A2C),
    currentTileGlow: Color(0xFF9C8CFF),
    easyAccent: Color(0xFF3BD986),
    mediumAccent: Color(0xFF7CC4FF),
    hardAccent: Color(0xFFC09EFF),
    expertAccent: Color(0xFFFFB370),
    masterAccent: Color(0xFFFF7B7F),
  );

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color onBackground;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color divider;
  final Color success;
  final Color error;
  final Color warning;
  final Color lockedTile;
  final Color solvedTile;
  final Color currentTileGlow;
  final Color easyAccent;
  final Color mediumAccent;
  final Color hardAccent;
  final Color expertAccent;
  final Color masterAccent;

  /// Convenience: get the accent color for a bucket index (0..4).
  Color bucketAccent(int bucketIndex) {
    switch (bucketIndex) {
      case 0:
        return easyAccent;
      case 1:
        return mediumAccent;
      case 2:
        return hardAccent;
      case 3:
        return expertAccent;
      case 4:
        return masterAccent;
      default:
        return easyAccent;
    }
  }
}
