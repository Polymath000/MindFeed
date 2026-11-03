import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final currentTheme = _resolveThemeMode(state);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              _buildOptionsRow(currentTheme),
            ],
          ),
        );
      },
    );
  }

  ThemeMode _resolveThemeMode(ThemeModeState state) {
    if (state is ThemeModeLight) return ThemeMode.light;
    if (state is ThemeModeDark) return ThemeMode.dark;
    return ThemeMode.system;
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reading Surface Contrast',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Select your preferred journal contrast and paper tone.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mutedInk,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsRow(ThemeMode currentTheme) {
    return Row(
      children: [
        _buildOption(
          mode: ThemeMode.light,
          current: currentTheme,
          title: 'Warm Paper',
          subtitle: 'Daylight Print',
          icon: AppIcons.menuBookRounded,
          cardColor: AppColors.softCream,
          textColor: AppColors.ink,
        ),
        const SizedBox(width: 8),
        _buildOption(
          mode: ThemeMode.dark,
          current: currentTheme,
          title: 'Midnight Ink',
          subtitle: 'Dimmed Study',
          icon: AppIcons.nightlightRound,
          cardColor: AppColors.charcoalDarker,
          textColor: AppColors.softCream,
        ),
        const SizedBox(width: 8),
        _buildOption(
          mode: ThemeMode.system,
          current: currentTheme,
          title: 'Auto Cadence',
          subtitle: 'Solar Sync',
          icon: AppIcons.brightnessAutoRounded,
          cardColor: AppColors.sandDark,
          textColor: AppColors.ink,
        ),
      ],
    );
  }

  Widget _buildOption({
    required ThemeMode mode,
    required ThemeMode current,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
  }) {
    return Expanded(
      child: _ThemeOptionCard(
        mode: mode,
        current: current,
        title: title,
        subtitle: subtitle,
        icon: icon,
        cardColor: cardColor,
        textColor: textColor,
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final ThemeMode mode;
  final ThemeMode current;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color textColor;

  const _ThemeOptionCard({
    required this.mode,
    required this.current,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.textColor,
  });

  bool get _isSelected => mode == current;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<ThemeModeCubit>().changeThemeMode(mode),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: _buildDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildTitle(),
            const SizedBox(height: 2),
            _buildSubtitle(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: _isSelected ? AppColors.ink : AppColors.creamDark,
        width: _isSelected ? 2 : 1,
      ),
      boxShadow: _isSelected
          ? const [
              BoxShadow(
                color: AppColors.transparentBlack,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ]
          : null,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, size: 18, color: textColor),
        if (_isSelected)
          const Icon(
            AppIcons.checkCircleRounded,
            size: 15,
            color: AppColors.ink,
          ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -0.2,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle,
      style: TextStyle(
        fontSize: 9.5,
        color: textColor.withAlpha(160),
        fontWeight: FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
