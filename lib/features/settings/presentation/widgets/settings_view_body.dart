import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_feed/core/widgets/custom_app_bar.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_menu.dart';

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
                      icon: FontAwesomeIcons.userPen,
                      title: "Edit Profile",
                      onTap: () {},
                    ),
                    buildSettingsMenuItem(
                      icon: FontAwesomeIcons.lock,
                      title: "Change Password",
                      onTap: () {},
                    ),
                    buildSettingsMenuItem(
                      icon: FontAwesomeIcons.rightFromBracket,
                      title: "Logout",
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsMenu(
                  title: 'Preferences',
                  children: [
                    buildSettingsMenuItemWithDropMenu(
                      icon: FontAwesomeIcons.circleHalfStroke,
                      title: "Theme",
                      onTap: () {},
                    ),
                    buildSettingsMenuItemWithDropMenu(
                      icon: FontAwesomeIcons.textWidth,
                      title: "Font Size",
                      onTap: () {},
                    ),
                    buildSettingsMenuItemWithDropMenu(
                      icon: FontAwesomeIcons.bookOpen,
                      title: "Reading Mode",
                      onTap: () {},
                    ),
                    buildSettingsMenuItemWithDropMenu(
                      icon: FontAwesomeIcons.globe,
                      title: "Language",
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsMenu(
                  title: 'Notifications',
                  children: [
                    buildSettingsMenuItemSwitcher(
                      icon: FontAwesomeIcons.solidNewspaper,
                      title: "New Articles",
                    ),
                    buildSettingsMenuItemSwitcher(
                      icon: Icons.system_update,
                      title: "App Updates",
                    ),
                  ],
                ),

                SettingsMenu(
                  title: 'Storage & Downloads',
                  children: [
                    buildSettingsMenuItemWithDropMenu(
                      icon: FontAwesomeIcons.download,
                      title: "Manage Downloads",
                    ),
                    buildSettingsMenuItemSwitcher(
                      icon: FontAwesomeIcons.database,
                      title: "Data Saver",
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
