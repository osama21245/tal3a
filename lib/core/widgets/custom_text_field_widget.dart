import 'package:flutter/material.dart';
import '../const/color_pallete.dart';
import '../const/dimentions.dart';
import '../const/text_style.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.bottom,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.maxLines > 1 ? null : 57,
      decoration: BoxDecoration(
        color: ColorPalette.cardGrey,
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        style: AppTextStyles.loginInputTextStyle,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.inputPlaceholderStyle,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(
            left: Dimensions.paddingLarge,
            right: Dimensions.paddingLarge,
            top: 30,
            bottom: 13,
          ),
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          counterText: '', // Hide character counter
        ),
      ),
    );
  }
}
