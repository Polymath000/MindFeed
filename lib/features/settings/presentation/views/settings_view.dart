import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart';
import 'package:mind_feed/features/settings/presentation/widgets/settings_view_body.dart';

class SettingsView extends StatelessWidget {
  final SettingsCubit? cubit;
  const SettingsView({super.key, this.cubit});
  static const String routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    const body = Scaffold(
      backgroundColor: AppColors.sand,
      body: SafeArea(
        bottom: false,
        child: SettingsViewBody(),
      ),
    );

    if (cubit != null) {
      return BlocProvider<SettingsCubit>.value(
        value: cubit!,
        child: body,
      );
    }
    return body;
  }
}
