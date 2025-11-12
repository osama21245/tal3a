import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../utils/home_navigation.dart';

class HomeBottomNavWidget extends StatelessWidget {
  const HomeBottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.h,
      decoration: BoxDecoration(
        color: ColorPalette.homeBottomNavBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          // Active indicator dot
          Container(
            width: 8.w,
            height: 8.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: ColorPalette.homeActiveDot,
              shape: BoxShape.circle,
            ),
          ),

          // Navigation Items
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    'assets/icons/Home.svg',
                    true,
                    () => HomeNavigation.toHome(context),
                  ),
                  _buildNavItem(
                    'assets/icons/star.svg',
                    false,
                    () => HomeNavigation.toActivities(context),
                  ),
                  _buildNavItem(
                    'assets/icons/chat.svg',
                    false,
                    () => HomeNavigation.toStory(context),
                  ),
                  _buildNavItem(
                    'assets/icons/heart.svg',
                    false,
                    () => HomeNavigation.toCommunity(context),
                  ),
                  _buildNavItem(
                    'assets/icons/navbarperson.svg',
                    false,
                    () => HomeNavigation.toProfile(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70.w,
        height: 65.h,
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 24.w,
            height: 24.h,
            color:
                isActive
                    ? ColorPalette.homeTabActive
                    : ColorPalette.homeTabInactive,
          ),
        ),
      ),
    );
  }
}
