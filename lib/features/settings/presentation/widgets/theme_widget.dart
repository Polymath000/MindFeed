import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_menu.dart';

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
        return buildSettingsMenuItemWithDropdown<ThemeMode>(
          icon: FontAwesomeIcons.circleHalfStroke,
          title: "Theme",
          value: currentTheme,
          items: const [
            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
          ],
          onChanged: (themeMode) {
            if (themeMode != null) {
              context.read<ThemeModeCubit>().changeThemeMode(themeMode);
            }
          },
          context: context,
        );
      },
    );
  }
}
