import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';

class SettingsProfileCardWidget extends StatelessWidget {
  const SettingsProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: ColorPalette.settingsProfileCardBg,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(2, 6),
            blurRadius: 25,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorPalette.settingsProfileBorder,
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/male_runner.png', // Using existing asset
                width: 50.w,
                height: 50.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 15.w),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mosarraf Hossain',
                  style: AppTextStyles.settingsProfileNameStyle,
                ),
                SizedBox(height: 4.h),
                Text(
                  'georgemikhaiel@gmail...',
                  style: AppTextStyles.settingsProfileEmailStyle,
                ),
              ],
            ),
          ),

          SizedBox(width: 5),

          // Star Badge
          SvgPicture.asset(
            'assets/icons/profile_start.svg',
            width: 50,
            height: 50,
          ),

          SizedBox(width: 3),

          // Edit Button
          GestureDetector(
            onTap: () {
              // Handle edit profile
            },
            child: SvgPicture.asset(
              'assets/icons/setting_Edit.svg',
              width: 33,
              height: 33,
            ),
          ),
        ],
      ),
    );
  }
}
