import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_requirements.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';

class SignUpFormBody extends StatefulWidget {
  const SignUpFormBody({super.key});

  @override
  State<SignUpFormBody> createState() => _SignUpFormBodyState();
}

class _SignUpFormBodyState extends State<SignUpFormBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  SignupParams params = SignupParams(email: '', password: '', displayName: '');
  String _password = '';
  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 85.0),
            Text(
              'Create Account',
              style: AppTextStyles.displaySmall!.copyWith(
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Join thousands of readers worldwide',
              style: AppTextStyles.bodyMedium!.copyWith(
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 50.0),
            CustomTextField(
              hintText: 'Username',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              textEditingController: _usernameController,
            ),
            SizedBox(height: 16.0),
            EmailTextField(controller: _emailController),
            SizedBox(height: 16.0),
            PasswordTextField(
              hintText: 'Password',
              controller: _passwordController,
            ),
            SizedBox(height: 16.0),
            PasswordTextField(
              hintText: 'Confirm Password',
              controller: _confirmPasswordController,
            ),
            SizedBox(height: 22.0),
            PasswordRequirements(password: _password),
            SizedBox(height: 22.0),
            CustomButton(
              buttonText: 'Sign Up',
              onTap: () {
                if (formKey.currentState?.validate() ?? false) {
                  final password = _passwordController.text;
                  final confirmPassword = _confirmPasswordController.text;
                  if (password != confirmPassword &&
                      password.isNotEmpty &&
                      confirmPassword.isNotEmpty) {
                    customShowSnackBar(
                      message: 'Passwords do not match',
                      context: context,
                    );
                  } else {
                    FocusScope.of(context).unfocus();
                    context.read<SignupCubit>().eitherFailureOrSignup(
                      params: SignupParams(
                        displayName: _usernameController.text,
                        email: _emailController.text,
                        password: password,
                      ),
                    );
                  }
                } else {
                  autovalidateMode = AutovalidateMode.always;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
