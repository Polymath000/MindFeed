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
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  bool _isLoading = false;
  String? _errorMessage;
  int _resendCooldown = 0;
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
    setState(() {
      _resendCooldown = 60;
    });
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _resendCooldown = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _resendCooldown--;
          });
        }
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
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await getIt<VerifyOtpUseCase>().call(
      email: widget.email,
      token: _codeController.text.trim(),
    );

    result.when(
      success: (accessToken) async {
        await _onSuccessfulAuthentication(accessToken);
      },
      failure: (failure) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = failure.message;
          });
        }
      },
    );
  }

  Future<void> _handleResend() async {
    if (_resendCooldown > 0 || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await getIt<ResendOtpUseCase>().call(email: widget.email);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      result.when(
        success: (_) {
          _startCooldown();
          customShowSnackBar(
            message: 'A new verification code has been dispatched to your email',
            context: context,
          );
        },
        failure: (failure) {
          setState(() {
            _errorMessage = failure.message;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _cooldownTimer?.cancel();
    _codeController.dispose();
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
                child: Form(
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
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 20),
                        Container(
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
                                  _errorMessage!,
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
                      ],
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
                      if (_isLoading)
                        const Center(child: CustomLoadingIndecator())
                      else
                        CustomButton(
                          buttonText: 'Verify Code',
                          onTap: _handleVerify,
                        ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: (_resendCooldown == 0 && !_isLoading)
                              ? _handleResend
                              : null,
                          child: Text(
                            _resendCooldown > 0
                                ? 'Resend code in ${_resendCooldown}s'
                                : 'Resend confirmation code',
                            style: TextStyle(
                              color: (_resendCooldown == 0 && !_isLoading)
                                  ? AppColors.cream
                                  : AppColors.greyText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
