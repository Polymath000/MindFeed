import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/core/widgets/custom_loading_indecator.dart';
import 'package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/security_tip_text.dart';
import 'package:mind_feed/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/there_is_an_account_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart'
    show ModalProgressHUD;

import '../../../../core/helpers/custom_show_snack_bar.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          AppRoutes.main(context);
          customShowSnackBar(message: 'Sign Up Success', context: context);
        } else if (state is SignupFailure) {
          customShowSnackBar(message: state.errorMessage, context: context);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          progressIndicator: CustomLoadingIndecator(),
          inAsyncCall: state is SignupLoading,
          child: Stack(
            children: [
              authBackground(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SignUpForm(),
                        SizedBox(height: 22.0),
                        SecurityTipText(),
                        ThereIsAnAccountText(),
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
