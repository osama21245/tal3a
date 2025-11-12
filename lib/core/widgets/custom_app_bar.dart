import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title, this.onBackPressed});
  final String title;
  final VoidCallback? onBackPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116.h,
      width: double.infinity,
      decoration: BoxDecoration(color: ColorPalette.trainingHeaderBg),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 72.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Stack(
                children: [
                  // Back Button
                  Positioned(
                    left: 0,
                    bottom: 12,
                    child: GestureDetector(
                      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/back_arrow_icon.svg',
                            width: 9.w,
                            height: 16.h,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Centered Title
                  Center(
                    child: Text(
                      title,
                      style: AppTextStyles.trainingAppBarTitleStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -230,
            right: -240,

            child: SvgPicture.asset(
              'assets/icons/high_five_icon.svg',
              width: 350.w,
              height: 350.h,
              color: Color(0xFF354F5C),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
