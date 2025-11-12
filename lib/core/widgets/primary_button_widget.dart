import 'package:flutter/material.dart';
import '../const/color_pallete.dart';
import '../const/dimentions.dart';
import '../const/text_style.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;

  const PrimaryButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bool buttonEnabled = isEnabled && !isLoading && onPressed != null;

    return SizedBox(
      height: height ?? Dimensions.buttonHeight,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: buttonEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              buttonEnabled
                  ? ColorPalette.primaryBlue
                  : ColorPalette.primaryBlue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
          ),
          elevation: 0,
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorPalette.textWhite,
                    ),
                  ),
                )
                : Text(text, style: AppTextStyles.continueButtonTextStyle),
      ),
    );
  }
}
