import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/dimentions.dart';
import '../../../../../core/const/text_style.dart';

class AuthToggleWidget extends StatefulWidget {
  final bool isLoginSelected;
  final Function(bool) onToggle;

  const AuthToggleWidget({
    super.key,
    required this.isLoginSelected,
    required this.onToggle,
  });

  @override
  State<AuthToggleWidget> createState() => _AuthToggleWidgetState();
}

class _AuthToggleWidgetState extends State<AuthToggleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      decoration: BoxDecoration(
        color: ColorPalette.cardGrey,
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      ),
      child: Row(
        children: [
          // Login Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onToggle(true);
              },
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:
                      widget.isLoginSelected
                          ? ColorPalette.primaryBlue
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(
                    'auth.login'.tr(),
                    style:
                        widget.isLoginSelected
                            ? AppTextStyles.tabButtonStyle
                            : AppTextStyles.tabButtonInactiveStyle,
                  ),
                ),
              ),
            ),
          ),

          // Sign Up Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onToggle(false);
              },
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:
                      widget.isLoginSelected
                          ? Colors.transparent
                          : ColorPalette.primaryBlue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: Text(
                    'auth.signup'.tr(),
                    style:
                        widget.isLoginSelected
                            ? AppTextStyles.tabButtonInactiveStyle
                            : AppTextStyles.tabButtonStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
