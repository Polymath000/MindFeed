import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/widgets/custom_loading_indecator.dart';
import 'package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/login_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/no_account_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          if (state.errorMessage.toLowerCase().contains('email not confirmed')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Email not confirmed. Please enter your code.'),
                action: SnackBarAction(
                  label: 'Verify',
                  textColor: const Color(0xFFFFF1C6),
                  onPressed: () {
                    if (state.email != null && state.email!.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.checkCode,
                        arguments: state.email!,
                      );
                    }
                  },
                ),
              ),
            );
          } else {
            customShowSnackBar(message: state.errorMessage, context: context);
          }
        } else if (state is LoginRequiresCategories) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.categories,
            (route) => false,
            arguments: state.userEntity,
          );
          customShowSnackBar(
            message: 'Please select your favorite categories to continue.',
            context: context,
          );
        } else if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
          customShowSnackBar(message: 'Login Success', context: context);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is LoginLoading,
          progressIndicator: CustomLoadingIndecator(),
          child: Stack(
            children: [
              authBackground(),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: const Column(
                        children: [
                          LoginForm(),
                          SizedBox(height: 24.0),
                          NoAccountText(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
