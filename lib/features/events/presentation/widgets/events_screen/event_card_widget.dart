import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/routing/routes.dart';
import 'package:tal3a/core/utils/date_formatter.dart';
import '../../../data/models/event_model.dart';

class EventCardWidget extends StatelessWidget {
  final EventModel event;
  final bool isFeatured;

  const EventCardWidget({
    super.key,
    required this.event,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFeatured) {
      return _buildFeaturedEventCard(context);
    } else {
      return _buildStandardEventCard(context);
    }
  }

  Widget _buildFeaturedEventCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(Routes.eventDetailsScreen, arguments: event.id);
      },
      child: Container(
        height: 222.h,
        decoration: BoxDecoration(
          color: ColorPalette.cardGrey,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Event Image
                Container(
                  height: 120.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      topRight: Radius.circular(14.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      topRight: Radius.circular(14.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: event.eventIcon,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          ),
                    ),
                  ),
                ),

                // Event Details
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(11.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and Time
                        Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                DateFormatter.formatEventDate(
                                  event.dateOfEvent,
                                ),
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: ColorPalette.textDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Rubik',
                                  height: 1.875,
                                  letterSpacing: 0.48,
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                // Handle bookmark
                              },
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                child: SvgPicture.asset(
                                  'assets/icons/bookmark.svg',
                                  width: 24.w,
                                  height: 24.h,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            GestureDetector(
                              onTap: () {
                                // Handle share
                              },
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                child: SvgPicture.asset(
                                  'assets/icons/share.svg',
                                  width: 24.w,
                                  height: 24.h,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4.h),

                        // Event Name
                        Text(
                          event.name,
                          style: const TextStyle(
                            color: Color(0xFF262627),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Rubik',
                            height: 1.33,
                            letterSpacing: 0.54,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Location
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/map_pin_icon.svg',
                              width: 14.w,
                              height: 14.h,
                              color: ColorPalette.trainingHeaderBg,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                event.location,
                                style: const TextStyle(
                                  color: ColorPalette.trainingHeaderBg,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Rubik',
                                  height: 1.43,
                                  letterSpacing: 0.42,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Action Buttons
          ],
        ),
      ),
    );
  }

  Widget _buildStandardEventCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(Routes.eventDetailsScreen, arguments: event.id);
      },
      child: Container(
        height: 84.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            // Event Image
            Container(
              width: 80.w,
              height: 84.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: event.eventIcon,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                ),
              ),
            ),

            // Event Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Date and Time
                    Flexible(
                      child: Text(
                        DateFormatter.formatEventDateShort(event.dateOfEvent),
                        style: TextStyle(
                          color: ColorPalette.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Rubik',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Event Name
                    Flexible(
                      child: Text(
                        event.name,
                        style: TextStyle(
                          color: ColorPalette.trainingHeaderBg,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Rubik',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Location
                    Flexible(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/map_pin_icon.svg',
                            width: 12,
                            height: 12,
                            color: const Color(0xFF9BA8AF),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              event.location,
                              style: TextStyle(
                                color: const Color(0xFF9BA8AF),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Rubik',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              width: 60.w,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle bookmark
                    },
                    child: SvgPicture.asset(
                      'assets/icons/bookmark.svg',
                      width: 20,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle share
                    },
                    child: SvgPicture.asset(
                      'assets/icons/share.svg',
                      width: 20,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
