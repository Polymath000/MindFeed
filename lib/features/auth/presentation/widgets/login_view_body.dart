import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/features/auth/presentation/controllers/cubit/auth_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/login_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/no_account_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthFailure) {
          customShowSnackBar(message: state.errorMessage, context: context);
        } else if (state is AuthSuccess) {
          // TODO: Handle The Navigator to Home Page
          customShowSnackBar(message: 'Login Success', context: context);
        }
        return ModalProgressHUD(
          inAsyncCall: state is AuthLoading,
          child: Stack(
            children: [
              authBackground(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        LoginForm(),
                        SizedBox(height: 16.0),
                        NoAccountText(),
                      ],
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
