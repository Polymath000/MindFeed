import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/domain/usecases/login_use_case.dart';
import 'package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:mind_feed/features/profile/domain/usecases/check_user_has_categories_use_case.dart';
import 'package:mind_feed/features/auth/presentation/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
    this.loginCubit,
  });

  final LoginCubit? loginCubit;
  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: loginCubit != null
          ? BlocProvider.value(
              value: loginCubit!,
              child: const LoginViewBody(),
            )
          : BlocProvider(
              create: (context) => LoginCubit(
                loginUseCase: getIt<LoginUseCase>(),
                checkUserHasCategoriesUseCase: getIt<CheckUserHasCategoriesUseCase>(),
              ),
              child: const LoginViewBody(),
            ),
    );
  }
}
