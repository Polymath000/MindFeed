import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/forget_password_text.dart';
import 'package:mind_feed/features/auth/presentation/widgets/logo.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String password = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: autovalidateMode,
      key: formKey,
      child: Column(
        children: [
          const Logo(),
          EmailTextField(
            onChanged: (String value) {
              setState(() {
                email = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          PasswordTextField(
            hintText: 'Password',
            onChanged: (String value) {
              setState(() {
                password = value;
              });
            },
          ),
          const SizedBox(height: 8.0),
          const ForgetPasswordText(),
          const SizedBox(height: 20.0),
          CustomButton(
            buttonText: 'Sign In',
            onTap: () {
              if (formKey.currentState?.validate() ?? false) {
                FocusScope.of(context).unfocus();
                context.read<LoginCubit>().eitherFailureOrLogin(
                  email: email,
                  password: password,
                );
              } else {
                setState(() {
                  autovalidateMode = AutovalidateMode.always;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
