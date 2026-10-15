import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/domain/usecases/signup_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/sign_up_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({
    super.key,
    this.signupCubit,
  });

  final SignupCubit? signupCubit;
  static const String routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: signupCubit != null
          ? BlocProvider.value(
              value: signupCubit!,
              child: const SignUpViewBody(),
            )
          : BlocProvider(
              create: (context) => SignupCubit(
                signUpUseCase: getIt<SignupUseCase>(),
              ),
              child: const SignUpViewBody(),
            ),
    );
  }
}
