import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
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
          customShowSnackBar(message: state.errorMessage, context: context);
        } else if (state is LoginSuccess) {
          AppRoutes.main(context);
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
