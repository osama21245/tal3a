import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/utils/date_formatter.dart';
import '../../controllers/event_details_cubit.dart';
import '../../controllers/event_details_state.dart';

class EventDetailsContentWidget extends StatelessWidget {
  final String eventId;

  const EventDetailsContentWidget({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsCubit, EventDetailsState>(
      builder: (context, state) {
        if (state is EventDetailsLoading) {
          return Container(
            padding: EdgeInsets.all(20.w),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 32.w,
                    height: 32.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF2BB8FF),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'events.loading_event_details'.tr(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is EventDetailsError) {
          return Container(
            padding: EdgeInsets.all(20.w),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.w,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'events.error_loading_event_details'.tr(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is EventDetailsLoaded) {
          final event = state.eventDetails;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 21.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                // Event Title
                Text(
                  event.name,
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    height: 1.33,
                  ),
                ),
                SizedBox(height: 20.h),

                // Date & Time Section
                _buildInfoSection(
                  icon: 'assets/icons/calendar.svg',
                  title: DateFormatter.formatEventDateForDetails(
                    event.dateOfEvent,
                  ),
                  subtitle:
                      '${DateFormatter.formatEventTime(event.dateOfEvent)} - ${DateFormatter.getEndTime(event.dateOfEvent, 2)}', // Assuming 2 hour duration
                  actionText: 'events.add_to_calendar'.tr(),
                  onActionTap: () {
                    // Handle add to calendar
                  },
                ),

                SizedBox(height: 20.h),

                // Location Section
                _buildInfoSection(
                  icon: 'assets/icons/map_pin_icon.svg',
                  title: event.location,
                  subtitle:
                      'Passeig Olímpic, 5-7, 08038 Barcelona', // TODO: Get full address
                  actionText: 'events.view_on_maps'.tr(),
                  onActionTap: () {
                    // Handle view on maps
                  },
                ),

                SizedBox(height: 20.h),

                // Refund Policy Section
                _buildInfoSection(
                  icon: 'assets/icons/dollar_sign.svg',
                  title: 'events.refund_policy'.tr(),
                  subtitle: 'events.flut_fee_not_refundable'.tr(),
                  actionText: null,
                  onActionTap: null,
                ),

                SizedBox(height: 20.h),

                // About Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'events.about'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Rubik',
                        height: 2.14,
                        letterSpacing: 0.48,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      event.description,
                      style: const TextStyle(
                        color: Color(0xFF354F5C),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Rubik',
                        height: 1.43,
                        letterSpacing: 0.42,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoSection({
    required String icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Info Row
        Row(
          children: [
            // Icon
            Container(
              width: 18.w,
              height: 18.h,
              child: SvgPicture.asset(
                icon,
                width: 18.w,
                height: 18.h,
                color: const Color(0xFF000000),
              ),
            ),
            SizedBox(width: 10.w),
            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Rubik',
                  height: 1.875,
                  letterSpacing: 0.48,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Subtitle
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF354F5C),
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontFamily: 'Rubik',
            height: 1.43,
            letterSpacing: 0.42,
          ),
        ),
        // Action Text (if provided)
        if (actionText != null) ...[
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFF00AAFF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Rubik',
                height: 2.14,
                letterSpacing: 0.42,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
