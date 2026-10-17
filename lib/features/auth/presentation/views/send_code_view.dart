import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/send_code_view_body.dart';

class SendCodeView extends StatelessWidget {
  const SendCodeView({super.key, this.cubit});
  final ForgetPasswordCubit? cubit;
  static const String routeName = 'sendcode';

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return Scaffold(
        body: BlocProvider<ForgetPasswordCubit>.value(
          value: cubit!,
          child: const SendCodeViewBody(),
        ),
      );
    }
    return Scaffold(
      body: BlocProvider<ForgetPasswordCubit>(
        create: (_) => getIt<ForgetPasswordCubit>(),
        child: const SendCodeViewBody(),
      ),
    );
  }
}
