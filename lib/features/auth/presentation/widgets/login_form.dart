import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/presentation/controllers/cubit/auth_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/forget_password_text.dart';
import 'package:mind_feed/features/auth/presentation/widgets/logo.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

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
          Logo(),
          EmailTextField(
            onChanged: (String value) {
              setState(() {
                email = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          PasswordTextField(
            hintText: 'Password',
            onChanged: (String value) {
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          ForgetPasswordText(),
          SizedBox(height: 16.0),
          CustomButton(
            buttonText: 'Login',
            onTap: () {
              if (formKey.currentState?.validate() ?? false) {
                FocusScope.of(context).unfocus();
                context.read<AuthCubit>().eitherFailureOrLogin(
                  email: email,
                  password: password,
                );
                // TODO: Handle login logic here
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Login successful')));
              } else {
                autovalidateMode = AutovalidateMode.always;
              }
            },
          ),
        ],
      ),
    );
  }
}
