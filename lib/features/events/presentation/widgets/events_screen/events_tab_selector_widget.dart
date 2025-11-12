import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import 'package:easy_localization/easy_localization.dart';

class EventsTabSelectorWidget extends StatefulWidget {
  final bool isEventsSelected;
  final Function(bool) onTabChanged;

  const EventsTabSelectorWidget({
    super.key,
    required this.isEventsSelected,
    required this.onTabChanged,
  });

  @override
  State<EventsTabSelectorWidget> createState() =>
      _EventsTabSelectorWidgetState();
}

class _EventsTabSelectorWidgetState extends State<EventsTabSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      height: 49.h,
      decoration: BoxDecoration(
        color: ColorPalette.cardGrey,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          // Events Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTabChanged(true);
              },
              child: Container(
                height: 40.h,
                margin: EdgeInsets.all(4.5.r),
                decoration: BoxDecoration(
                  color:
                      widget.isEventsSelected
                          ? ColorPalette.primaryBlue
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Center(
                  child: Text(
                    'events.title'.tr(),
                    style:
                        !widget.isEventsSelected
                            ? AppTextStyles.tabButtonInactiveStyle
                            : AppTextStyles.tabButtonStyle,
                  ),
                ),
              ),
            ),
          ),

          // Tickets Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTabChanged(false);
              },
              child: Container(
                height: 40.h,
                margin: EdgeInsets.all(4.5.r),
                decoration: BoxDecoration(
                  color:
                      widget.isEventsSelected
                          ? Colors.transparent
                          : ColorPalette.primaryBlue,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Center(
                  child: Text(
                    'events.tickets'.tr(),
                    style:
                        widget.isEventsSelected
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
