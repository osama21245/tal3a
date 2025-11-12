import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';

class SettingsTabSelectorWidget extends StatelessWidget {
  final bool isProfileSelected;
  final Function(bool) onTabChanged;

  const SettingsTabSelectorWidget({
    super.key,
    required this.isProfileSelected,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      height: 49.h,
      decoration: BoxDecoration(
        color: ColorPalette.settingsTabBg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          // Profile Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                onTabChanged(true);
              },
              child: Container(
                height: 40.h,
                margin: EdgeInsets.all(4.5.r),
                decoration: BoxDecoration(
                  color:
                      isProfileSelected
                          ? ColorPalette.settingsTabActiveBg
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Center(
                  child: Text(
                    'Profile',
                    style:
                        isProfileSelected
                            ? AppTextStyles.settingsTabActiveStyle
                            : AppTextStyles.settingsTabInactiveStyle,
                  ),
                ),
              ),
            ),
          ),

          // Settings Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                onTabChanged(false);
              },
              child: Container(
                height: 40.h,
                margin: EdgeInsets.all(4.5.r),
                decoration: BoxDecoration(
                  color:
                      isProfileSelected
                          ? Colors.transparent
                          : ColorPalette.settingsTabActiveBg,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Center(
                  child: Text(
                    'Settings',
                    style:
                        isProfileSelected
                            ? AppTextStyles.settingsTabInactiveStyle
                            : AppTextStyles.settingsTabActiveStyle,
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
