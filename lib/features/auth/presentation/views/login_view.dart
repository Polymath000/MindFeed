import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/helpers/setup_service_locator.dart';

import 'package:mind_feed/features/auth/data/repos/auth_repo_impl.dart'
    show AuthRepoImpl;
import 'package:mind_feed/features/auth/presentation/controllers/cubit/auth_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/login_view_body.dart';

import '../../domain/usecases/login.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider.value(
        value: AuthCubit(
          loginUseCase: LoginUseCase(repo: getIt.get<AuthRepoImpl>()),
        ),
        child: LoginViewBody(),
      ),
    );
  }
}
