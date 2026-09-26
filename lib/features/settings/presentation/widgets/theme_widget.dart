import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        ThemeMode currentTheme;
        if (state is ThemeModeLight) {
          currentTheme = ThemeMode.light;
        } else if (state is ThemeModeDark) {
          currentTheme = ThemeMode.dark;
        } else {
          currentTheme = ThemeMode.system;
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reading Surface Contrast',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: EditorialPalette.ink,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Select your preferred journal contrast and paper tone.',
                style: TextStyle(
                  fontSize: 12,
                  color: EditorialPalette.mutedInk,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildThemeCard(
                      context,
                      mode: ThemeMode.light,
                      current: currentTheme,
                      title: 'Warm Paper',
                      subtitle: 'Daylight Print',
                      icon: Icons.menu_book_rounded,
                      cardColor: const Color(0xFFFFF8E6),
                      textColor: EditorialPalette.ink,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildThemeCard(
                      context,
                      mode: ThemeMode.dark,
                      current: currentTheme,
                      title: 'Midnight Ink',
                      subtitle: 'Dimmed Study',
                      icon: Icons.nightlight_round,
                      cardColor: const Color(0xFF23211F),
                      textColor: const Color(0xFFFFF8E6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildThemeCard(
                      context,
                      mode: ThemeMode.system,
                      current: currentTheme,
                      title: 'Auto Cadence',
                      subtitle: 'Solar Sync',
                      icon: Icons.brightness_auto_rounded,
                      cardColor: const Color(0xFFEDE5D4),
                      textColor: EditorialPalette.ink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeCard(
    BuildContext context, {
    required ThemeMode mode,
    required ThemeMode current,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
  }) {
    final isSelected = mode == current;

    return InkWell(
      onTap: () {
        context.read<ThemeModeCubit>().changeThemeMode(mode);
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? EditorialPalette.ink : const Color(0xFFDDD4C0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 18, color: textColor),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 15,
                    color: EditorialPalette.ink,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: textColor,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9.5,
                color: textColor.withAlpha(160),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
