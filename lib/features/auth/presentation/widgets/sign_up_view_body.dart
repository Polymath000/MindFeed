import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/widgets/custom_loading_indecator.dart';
import 'package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/security_tip_text.dart';
import 'package:mind_feed/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/there_is_an_account_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupRequiresConfirmation) {
          Navigator.pushNamed(context, AppRoutes.checkCode, arguments: state.email);
          customShowSnackBar(message: 'Check your email for your confirmation code', context: context);
        } else if (state is SignupSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
          customShowSnackBar(message: 'Sign Up Success', context: context);
        } else if (state is SignupFailure) {
          if (state.isUserAlreadyRegistered) {
            customShowSnackBar(
              message: 'An account with this email already exists',
              context: context,
              action: SnackBarAction(
                label: 'Sign In',
                textColor: Colors.amber,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            );
          } else {
            customShowSnackBar(message: state.errorMessage, context: context);
          }
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          progressIndicator: CustomLoadingIndecator(),
          inAsyncCall: state is SignupLoading,
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
                          SignUpForm(),
                          SizedBox(height: 24.0),
                          SecurityTipText(),
                          SizedBox(height: 20.0),
                          ThereIsAnAccountText(),
                          SizedBox(height: 24.0),
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
