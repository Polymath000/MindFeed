import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';

class CheckCodeHeader extends StatelessWidget {
  final String email;
  final ValueListenable<String?> errorMessageListenable;
  final VoidCallback? onBackPressed;

  const CheckCodeHeader({
    super.key,
    required this.email,
    required this.errorMessageListenable,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            EditorialIconButton(
              icon: AppIcons.arrowBackRounded,
              label: 'Back',
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            const Text(
              'Verify Email',
              style: TextStyle(
                color: AppColors.softCream,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Text(
          'We dispatched a 6-digit confirmation code to\n$email',
          style: const TextStyle(
            color: AppColors.greyText,
            fontSize: 15,
            height: 1.4,
          ),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: errorMessageListenable,
          builder: (context, errorMessage, _) {
            if (errorMessage == null) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blush.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.redHighlight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.redHighlight,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: AppColors.redHighlight,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CheckCodeActionsSection extends StatelessWidget {
  final ValueListenable<bool> isLoadingListenable;
  final ValueListenable<int> resendCooldownListenable;
  final VoidCallback onVerify;
  final VoidCallback onResend;

  const CheckCodeActionsSection({
    super.key,
    required this.isLoadingListenable,
    required this.resendCooldownListenable,
    required this.onVerify,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: isLoadingListenable,
          builder: (context, isLoading, _) {
            return CustomButton(
              buttonText: 'Verify Code',
              isLoading: isLoading,
              onTap: isLoading ? null : onVerify,
            );
          },
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder<int>(
          valueListenable: resendCooldownListenable,
          builder: (context, cooldown, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: isLoadingListenable,
              builder: (context, isLoading, _) {
                final canResend = cooldown == 0 && !isLoading;
                return Center(
                  child: TextButton(
                    onPressed: canResend ? onResend : null,
                    child: Text(
                      cooldown > 0
                          ? 'Resend code in ${cooldown}s'
                          : 'Resend confirmation code',
                      style: TextStyle(
                        color: canResend
                            ? AppColors.cream
                            : AppColors.greyText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
