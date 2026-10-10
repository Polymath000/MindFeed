import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/features/auth/presentation/controllers/signup_cubit/signup_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_requirements.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

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
  String _password = '';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
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
            const SizedBox(height: 32.0),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderDark, width: 1.5),
              ),
              child: SvgPicture.asset(
                Assets.assetsImagesLogo,
                height: 44,
                width: 44,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Join MindFeed',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                color: AppColors.softCream,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Start your journey with curated insights',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: AppColors.greyText,
              ),
            ),
            const SizedBox(height: 32.0),
            CustomTextField(
              hintText: 'Full name or username',
              prefixIcon: const Icon(
                AppIcons.personOutline,
                color: AppColors.greyText,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              textEditingController: _usernameController,
            ),
            const SizedBox(height: 14.0),
            EmailTextField(controller: _emailController),
            const SizedBox(height: 14.0),
            PasswordTextField(
              hintText: 'Create password',
              controller: _passwordController,
            ),
            const SizedBox(height: 14.0),
            PasswordTextField(
              hintText: 'Confirm password',
              controller: _confirmPasswordController,
            ),
            const SizedBox(height: 18.0),
            PasswordRequirements(password: _password),
            const SizedBox(height: 22.0),
            CustomButton(
              buttonText: 'Create Account',
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
                        displayName: _usernameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: password,
                      ),
                    );
                  }
                } else {
                  setState(() {
                    autovalidateMode = AutovalidateMode.always;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
