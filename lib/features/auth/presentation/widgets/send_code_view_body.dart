import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';

class SendCodeViewBody extends StatefulWidget {
  SendCodeViewBody({super.key});

  @override
  State<SendCodeViewBody> createState() => _SendCodeViewBodyState();
}

class _SendCodeViewBodyState extends State<SendCodeViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String email = '';
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
                          'Send Code',
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
                          'Enter your email tp send the code',
                          style: AppTextStyles.bodyLarge!.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),

                    Text(
                      'Email',
                      style: AppTextStyles.bodyLarge!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    EmailTextField(
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 32),
                    CustomButton(
                      buttonText: 'Send instructions',
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          FocusScope.of(context).unfocus();
                          // TODO: Handle login logic here
                          AppRoutes.checkCodeView(context, email: email);
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
