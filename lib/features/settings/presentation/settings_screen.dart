import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_riddles/core/constants/app_constants.dart';
import 'package:math_riddles/core/theme/app_colors.dart';
import 'package:math_riddles/core/theme/app_spacing.dart';
import 'package:math_riddles/core/theme/app_text_styles.dart';
import 'package:math_riddles/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final settings = appState.settings;
    final brightness = Theme.of(context).brightness;
    final colors =
        brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.title.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s5),
        children: [
          _SectionHeader(title: 'FEEDBACK', colors: colors),
          SwitchListTile(
            title: Text('Sound', style: AppTextStyles.bodyEmphasis.copyWith(color: colors.onSurface)),
            value: settings.soundEnabled,
            onChanged: (value) {
              appState.updateSettings(settings.copyWith(soundEnabled: value));
            },
            activeColor: AppColors.brandPrimary,
          ),
          SwitchListTile(
            title: Text('Haptics', style: AppTextStyles.bodyEmphasis.copyWith(color: colors.onSurface)),
            value: settings.hapticsEnabled,
            onChanged: (value) {
              appState.updateSettings(settings.copyWith(hapticsEnabled: value));
            },
            activeColor: AppColors.brandPrimary,
          ),
          const SizedBox(height: AppSpacing.s6),
          _SectionHeader(title: 'PROGRESS', colors: colors),
          ListTile(
            title: Text(
              'Reset progress',
              style: AppTextStyles.bodyEmphasis.copyWith(color: colors.error),
            ),
            onTap: () => _showResetConfirmation(context, appState, colors),
          ),
          const SizedBox(height: AppSpacing.s6),
          _SectionHeader(title: 'ABOUT', colors: colors),
          _InfoTile(title: 'Version', value: '1.0.0', colors: colors),
          _InfoTile(
            title: 'Privacy Policy',
            colors: colors,
            onTap: () => _launchUrl(AppConstants.privacyPolicyUrl),
          ),
          _InfoTile(
            title: 'Share App',
            colors: colors,
            onTap: () {
              Share.share(
                'Check out this Math Riddles app: https://play.google.com/store/apps/details?id=com.renazy.math_riddles',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(
    BuildContext context,
    AppState appState,
    AppColors colors,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset progress?'),
        content: const Text(
          'This wipes your solved riddles and stats. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              appState.resetProgress();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress reset.')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: colors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.colors});
  final String title;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s2, left: AppSpacing.s1),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          color: colors.onSurfaceMuted,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}


class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.colors,
    this.value,
    this.onTap,
  });
  final String title;
  final String? value;
  final AppColors colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final v = value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTextStyles.bodyEmphasis.copyWith(color: colors.onSurface)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (v != null)
            Text(v, style: AppTextStyles.caption.copyWith(color: colors.onSurfaceMuted)),
          if (onTap != null)
            Icon(Icons.chevron_right, color: colors.onSurfaceMuted),
        ],
      ),
      onTap: onTap,
    );
  }
}
