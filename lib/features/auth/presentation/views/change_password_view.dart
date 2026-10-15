import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/presentation/controllers/change_password_cubit/change_password_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/change_password_view_body.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key, required this.email, this.cubit});
  final String email;
  final ChangePasswordCubit? cubit;
  static const String routeName = 'changepassword';

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return Scaffold(
        body: BlocProvider<ChangePasswordCubit>.value(
          value: cubit!,
          child: ChangePasswordViewBody(email: email),
        ),
      );
    }
    return Scaffold(
      body: BlocProvider<ChangePasswordCubit>(
        create: (_) => getIt<ChangePasswordCubit>(),
        child: ChangePasswordViewBody(email: email),
      ),
    );
  }
}
