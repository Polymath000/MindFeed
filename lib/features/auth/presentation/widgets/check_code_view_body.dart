import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';

class CheckCodeViewBody extends StatelessWidget {
  CheckCodeViewBody({super.key, required this.email});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        authBackground(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            AppRoutes.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.lightGrey,
                          ),
                        ),
                        Text(
                          'Check Code',
                          style: AppTextStyles.headlineSmall!.copyWith(
                            color: AppColors.lightGray,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60.0),
                      child: Center(
                        child: Text(
                          'We have sent a password recover instructions to your email',
                          style: AppTextStyles.bodyLarge!.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Enter the Verified Code',
                      style: AppTextStyles.bodyLarge!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Enter the Verified Code',
                      onChanged: (String value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Type the Code please!';
                        }
                      },
                    ),
                    SizedBox(height: 32),
                    CustomButton(
                      buttonText: 'Verify Code',
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          FocusScope.of(context).unfocus();
                          // TODO: Handle login logic here
                          AppRoutes.changepasswordView(context, email: email);
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Success')));
                        } else {
                          autovalidateMode = AutovalidateMode.always;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
