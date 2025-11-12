import 'package:flutter/material.dart';
import '../const/text_style.dart';

class SecondaryButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final TextStyle? textStyle;

  const SecondaryButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(text, style: textStyle ?? AppTextStyles.forgotPasswordStyle),
    );
  }
}
