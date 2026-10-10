import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_view_body.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  static const String routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: EditorialPalette.sand,
      body: SafeArea(
        bottom: false,
        child: SettingsViewBody(),
      ),
    );
  }
}
