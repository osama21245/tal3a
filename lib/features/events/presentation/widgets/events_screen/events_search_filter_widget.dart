import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import 'package:easy_localization/easy_localization.dart';

class EventsSearchFilterWidget extends StatelessWidget {
  const EventsSearchFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 52.h,
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(2, 6),
                    blurRadius: 25,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TextField(
                style: AppTextStyles.inputPlaceholderStyle,
                decoration: InputDecoration(
                  hintText: 'events.search_placeholder'.tr(),
                  hintStyle: AppTextStyles.inputPlaceholderStyle,
                  prefixIcon: Container(
                    width: 18.w,
                    height: 18.h,
                    margin: EdgeInsets.all(17.r),
                    child: SvgPicture.asset(
                      'assets/icons/search_icon.svg',
                      width: 18.w,
                      height: 18.h,
                      color: ColorPalette.textPlaceholder,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Filter Button
          Container(
            width: 60.w,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(2, 6),
                  blurRadius: 25,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/filter_icon.svg',
                width: 24.w,
                height: 24.h,
                color: ColorPalette.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
