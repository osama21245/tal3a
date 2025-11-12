import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/const/text_style.dart';
import '../../../../core/controller/user_controller.dart';
import '../../../../core/routing/routes.dart';

class StartButtonWidget extends StatelessWidget {
  final VoidCallback? onConfettiTrigger;

  const StartButtonWidget({super.key, this.onConfettiTrigger});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Trigger confetti celebration
          onConfettiTrigger?.call();
          await Future.delayed(const Duration(seconds: 1), () {});
          // Complete onboarding using UserController
          context.read<UserController>().completeOnboarding();
          Navigator.of(context).pushReplacementNamed(Routes.signInScreen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
          ),
          padding: EdgeInsets.symmetric(vertical: Dimensions.buttonPadding),
        ),
        child: Text(
          'onboarding.start_button'.tr(),
          style: AppTextStyles.buttonStyle,
        ),
      ),
    );
  }
}
