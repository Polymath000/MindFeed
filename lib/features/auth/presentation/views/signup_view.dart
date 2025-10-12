import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/features/auth/presentation/widgets/sign_up_view_body.dart';

import '../../../../core/helpers/setup_service_locator.dart' show getIt;
import '../../data/repos/auth_repo_impl.dart' show AuthRepoImpl;
import '../../domain/usecases/signup_use_case.dart' show SignupUseCase;
import '../controllers/signup_cubit/signup_cubit.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const String routeName = 'signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider.value(
        value: SignupCubit(
          signUpUseCase: SignupUseCase(repo: getIt.get<AuthRepoImpl>()),
        ),
        child: SignUpViewBody(),
      ),
    );
  }
}
