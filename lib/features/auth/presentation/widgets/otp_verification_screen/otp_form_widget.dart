import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/dimentions.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/routing/routes.dart';
import '../../cubit/auth_cubit.dart';

class OtpFormWidget extends StatefulWidget {
  final String email;
  final bool isFromForgotPassword;

  const OtpFormWidget({
    super.key,
    required this.email,
    required this.isFromForgotPassword,
  });

  @override
  State<OtpFormWidget> createState() => _OtpFormWidgetState();
}

class _OtpFormWidgetState extends State<OtpFormWidget> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _hasError = false;
  bool _isButtonEnabled = false;

  // Countdown timer logic
  Timer? _timer;
  int _countdown = 59;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(_onTextChanged);
    }
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _resendOtp() {
    if (_canResend) {
      setState(() {
        _countdown = 59;
        _canResend = false;
      });
      _startCountdown();
      // TODO: Implement resend OTP logic
    }
  }

  void _onTextChanged() {
    String otp = _controllers.map((controller) => controller.text).join();
    setState(() {
      _isButtonEnabled = otp.length == 6;
      _hasError = false; // Clear error when user types
    });
  }

  String _maskEmail(String email) {
    if (email.isEmpty) return 'your email';

    int atIndex = email.indexOf('@');
    if (atIndex == -1 || atIndex <= 3) {
      // If no @ found or @ is too early, just show first 3 chars + ****
      return email.length > 3
          ? '${email.substring(0, 3)}****@gmail.com'
          : '****@gmail.com';
    }

    // Mask the middle part of the email
    String prefix = email.substring(0, 3);
    String suffix = email.substring(atIndex);
    return '$prefix****$suffix';
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _verifyOtp() {
    String otp = _controllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      setState(() {
        _hasError = true;
      });
      return;
    }

    if (widget.isFromForgotPassword) {
      // For forgot password flow, bypass OTP verification and navigate directly
      // The actual verification will happen in the new password screen
      print('🔍 DEBUG: OTP Form - widget.email: ${widget.email}');
      print('🔍 DEBUG: OTP Form - otp: $otp');
      print(
        '🔍 DEBUG: OTP Form - isFromForgotPassword: ${widget.isFromForgotPassword}',
      );

      Navigator.of(context).pushNamed(
        Routes.newPasswordScreen,
        arguments: {'email': widget.email, 'code': otp},
      );
    } else {
      // For signup flow, use normal OTP verification
      context.read<AuthCubit>().verifyCode(code: otp);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isCodeVerificationSuccess) {
          // Navigate based on the flow
          if (widget.isFromForgotPassword) {
            Navigator.of(
              context,
            ).pushNamed(Routes.newPasswordScreen, arguments: widget.email);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Your Account Is Created Successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushNamed(Routes.signInScreen);
          }
        } else if (state.isCodeVerificationError && state.error != null) {
          setState(() {
            _hasError = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Description Text
            Text(
              'We have sent an OTP code to your email ${_maskEmail(widget.email)}. Enter the code below.',
              style: AppTextStyles.formDescriptionStyle,
            ),

            const SizedBox(height: 20),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  width: 50.w,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        _hasError && index == 0
                            ? Border.all(
                              color: const Color(0xFFDA0B20),
                              width: 1,
                            )
                            : null,
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style:
                        _hasError && index == 0
                            ? AppTextStyles.otpInputErrorTextStyle
                            : AppTextStyles.otpInputTextStyle,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: '0',
                      hintStyle: AppTextStyles.otpHintTextStyle,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      _onDigitChanged(value, index);
                    },
                    onTap: () {
                      setState(() {
                        _hasError = false;
                      });
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Continue Button
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isButtonEnabled && !state.isCodeVerificationLoading
                        ? _verifyOtp
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isButtonEnabled && !state.isCodeVerificationLoading
                          ? ColorPalette.primaryBlue
                          : const Color(0xFFE7EAEB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radiusMedium,
                    ),
                  ),
                  elevation: 0,
                ),
                child:
                    state.isCodeVerificationLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          'auth.continue'.tr(),
                          style: AppTextStyles.tabButtonStyle,
                        ),
              ),
            ),

            const SizedBox(height: 20),

            // Resend Code
            Center(
              child: GestureDetector(
                onTap: _canResend ? _resendOtp : null,
                child: Text(
                  _canResend
                      ? 'auth.resend_code'.tr()
                      : '${'auth.didnt_receive_code'.tr()} $_countdown sec',
                  style: AppTextStyles.resendCodeTextStyle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
