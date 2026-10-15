import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/core/widgets/custom_loading_indecator.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';

class CheckCodeViewBody extends StatefulWidget {
  const CheckCodeViewBody({super.key, required this.email});
  final String email;

  @override
  State<CheckCodeViewBody> createState() => _CheckCodeViewBodyState();
}

class _CheckCodeViewBodyState extends State<CheckCodeViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final ValueNotifier<AutovalidateMode> _autovalidateMode =
      ValueNotifier<AutovalidateMode>(AutovalidateMode.disabled);

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);
  final ValueNotifier<int> _resendCooldown = ValueNotifier<int>(0);
  Timer? _cooldownTimer;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _startListeningToAuthChanges();
  }

  void _startListeningToAuthChanges() {
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      if (data.event == AuthChangeEvent.signedIn && data.session != null) {
        final session = data.session!;
        if (session.accessToken.isNotEmpty) {
          await _onSuccessfulAuthentication(session.accessToken);
        }
      }
    });
  }

  void _startCooldown() {
    _resendCooldown.value = 60;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown.value <= 1) {
        timer.cancel();
        _resendCooldown.value = 0;
      } else {
        _resendCooldown.value--;
      }
    });
  }

  Future<void> _onSuccessfulAuthentication(String accessToken) async {
    await SharedPreferencesSingleton.setString(AppConstants.tokenKey, accessToken);
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && Hive.isBoxOpen(AppConstants.userKey)) {
      final userBox = Hive.box<UserEntity>(AppConstants.userKey);
      final userEntity = UserEntity(
        userName: user.userMetadata?['display_name'] as String? ?? '',
        email: user.email ?? widget.email,
        favoriteCategories: const [],
        token: accessToken,
      );
      await userBox.put(AppConstants.userKey, userEntity);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.categories,
          (route) => false,
          arguments: userEntity,
        );
      }
    } else {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.main,
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleVerify() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      _autovalidateMode.value = AutovalidateMode.always;
      return;
    }

    FocusScope.of(context).unfocus();
    _isLoading.value = true;
    _errorMessage.value = null;

    final result = await getIt<VerifyOtpUseCase>().call(
      email: widget.email,
      token: _codeController.text.trim(),
    );

    result.when(
      success: (accessToken) async {
        await _onSuccessfulAuthentication(accessToken);
      },
      failure: (failure) {
        _isLoading.value = false;
        _errorMessage.value = failure.message;
      },
    );
  }

  Future<void> _handleResend() async {
    if (_resendCooldown.value > 0 || _isLoading.value) return;

    _isLoading.value = true;
    _errorMessage.value = null;

    final result = await getIt<ResendOtpUseCase>().call(email: widget.email);

    _isLoading.value = false;
    result.when(
      success: (_) {
        _startCooldown();
        customShowSnackBar(
          message: 'A new verification code has been dispatched to your email',
          context: context,
        );
      },
      failure: (failure) {
        _errorMessage.value = failure.message;
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _cooldownTimer?.cancel();
    _codeController.dispose();
    _isLoading.dispose();
    _errorMessage.dispose();
    _resendCooldown.dispose();
    _autovalidateMode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        authBackground(),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: ValueListenableBuilder<AutovalidateMode>(
                  valueListenable: _autovalidateMode,
                  builder: (context, autovalidateMode, _) {
                    return Form(
                      key: formKey,
                      autovalidateMode: autovalidateMode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              EditorialIconButton(
                                icon: AppIcons.arrowBackRounded,
                                label: 'Back',
                                onPressed: () => Navigator.pop(context),
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
                            'We dispatched a 6-digit confirmation code to\n${widget.email}',
                            style: const TextStyle(
                              color: AppColors.greyText,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                          ValueListenableBuilder<String?>(
                            valueListenable: _errorMessage,
                            builder: (context, errorMessage, _) {
                              if (errorMessage == null) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.blush.withValues(alpha: 0.15),
                                    border: Border.all(color: AppColors.redHighlight),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: AppColors.redHighlight, size: 20),
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
                          const SizedBox(height: 28),
                          const Text(
                            'Verification Code',
                            style: TextStyle(
                              color: AppColors.softCream,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            textEditingController: _codeController,
                            hintText: 'Enter 6-digit code',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter the verification code';
                              }
                              if (value.trim().length < 6) {
                                return 'Verification code must be 6 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),
                          ValueListenableBuilder<bool>(
                            valueListenable: _isLoading,
                            builder: (context, isLoading, _) {
                              if (isLoading) {
                                return const Center(
                                    child: CustomLoadingIndecator());
                              }
                              return CustomButton(
                                buttonText: 'Verify Code',
                                onTap: _handleVerify,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder<int>(
                            valueListenable: _resendCooldown,
                            builder: (context, cooldown, _) {
                              return ValueListenableBuilder<bool>(
                                valueListenable: _isLoading,
                                builder: (context, isLoading, _) {
                                  final canResend = cooldown == 0 && !isLoading;
                                  return Center(
                                    child: TextButton(
                                      onPressed: canResend ? _handleResend : null,
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

