import 'package:flutter/material.dart';
import 'package:mind_feed/core/widgets/custom_app_bar.dart';
import 'package:mind_feed/core/utls/app_icons.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_menu.dart';
import 'package:mind_feed/features/settings/presentation/widgets/theme_widget.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CustomAppBar(title: 'Settings'),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsMenu(
                  title: 'Account',
                  children: [
                    buildSettingsMenuItem(
                      icon: AppIcons.editProfile,
                      title: "Edit Profile",
                      onTap: () {},
                      context: context,
                    ),
                    buildSettingsMenuItem(
                      icon: AppIcons.lock,
                      title: "Change Password",
                      onTap: () {},
                      context: context,
                    ),
                    buildSettingsMenuItem(
                      icon: AppIcons.logout,
                      title: "Logout",
                      onTap: () {},
                      context: context,
                    ),
                  ],
                ),
                SettingsMenu(
                  title: 'Preferences',
                  children: [
                    ThemeWidget(),
                    buildSettingsMenuItemWithDropMenu(
                      icon: AppIcons.textFormat,
                      title: "Font Size",
                      onTap: () {},
                      beforeTrailing: '',
                      context: context,
                    ),
                  ],
                ),
                SettingsMenu(
                  title: 'Notifications',
                  children: [
                    buildSettingsMenuItemSwitcher(
                      icon: AppIcons.news,
                      title: "New Articles",
                      context: context,
                    ),
                    buildSettingsMenuItemSwitcher(
                      icon: Icons.system_update,
                      title: "App Updates",
                      context: context,
                    ),
                  ],
                ),
                SettingsMenu(
                  title: 'Storage & Downloads',
                  children: [
                    buildSettingsMenuItemWithDropMenu(
                      icon: AppIcons.download,
                      title: "Manage Downloads",
                      beforeTrailing: '',
                      context: context,
                    ),
                    buildSettingsMenuItemSwitcher(
                      icon: AppIcons.database,
                      title: "Data Saver",
                      context: context,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
