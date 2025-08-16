import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/features/auth/domain/entites/user_entity.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_requirements.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String confirmPassword = '';
  UserEntity userEntity = UserEntity(
    favoriteCategories: [],
    email: '',
    password: '',
    userName: '',
  );

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
              onChanged: (String value) {
                setState(() {
                  userEntity.copyWith(username: value);
                });
              },
            ),
            SizedBox(height: 16.0),
            EmailTextField(
              onChanged: (String value) {
                setState(() {
                  userEntity.copyWith(email: value);
                });
              },
            ),
            SizedBox(height: 16.0),
            PasswordTextField(
              hintText: 'Password',
              onChanged: (String value) {
                setState(() {
                  userEntity.copyWith(password: value);
                });
              },
            ),
            SizedBox(height: 16.0),
            PasswordTextField(
              hintText: 'Confirm Password',
              onChanged: (String value) {
                setState(() {
                  confirmPassword = value;
                });
              },
            ),
            SizedBox(height: 22.0),
            PasswordRequirements(password: userEntity.password ?? ''),
            SizedBox(height: 22.0),
            CustomButton(
              buttonText: 'Sign Up',
              onTap: () {
                if (formKey.currentState?.validate() ?? false) {
                  FocusScope.of(context).unfocus();
                  // TODO: Handle Signup logic here
                  AppRoutes.categoriesView(context, userEntity: userEntity);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('success')));
                } else if (userEntity.password != confirmPassword &&
                    userEntity.password!.isNotEmpty &&
                    confirmPassword.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
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
