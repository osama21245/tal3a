import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tal3a/core/routing/routes.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../data/models/purchased_ticket_model.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../core/routing/app_router.dart';

class PurchasedTicketCardWidget extends StatelessWidget {
  final PurchasedTicketModel purchase;

  const PurchasedTicketCardWidget({super.key, required this.purchase});

  void _navigateToTicketDetails(BuildContext context) {
    // Navigate to event details screen with the event ID from purchased ticket
    // Pass isFromTicketsScreen: true to indicate coming from tickets screen
    Navigator.pushNamed(
      context,
      Routes.eventDetailsScreen,
      arguments: {'eventId': purchase.eventId, 'isFromTicketsScreen': true},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToTicketDetails(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
        child: Stack(
          children: [
            // Main content row
            Row(
              children: [
                // Event Image (Left side)
                Container(
                  width: 92.w,
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
                    child: AspectRatio(
                      aspectRatio: 92 / 122, // Maintain original proportions
                      child: CachedNetworkImage(
                        imageUrl: purchase.eventIcon,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: const Color(0xFFF2F2F2),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: ColorPalette.primaryBlue,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: const Color(0xFFF2F2F2),
                              child: const Icon(
                                Icons.event,
                                color: ColorPalette.textGrey,
                                size: 32,
                              ),
                            ),
                      ),
                    ),
                  ),
                ),

                // Event Details (Middle)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      top: 12.h,
                      bottom: 12.h,
                      right: 70.w, // Make space for action buttons
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Date and Time
                        Text(
                          DateFormatter.formatEventDateWithTime(
                            purchase.purchasedAt,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF354F5C), // Figma: #354f5c
                            fontSize: 14,
                            fontWeight: FontWeight.w300, // Light
                            fontFamily: 'Rubik',
                            letterSpacing: 0.42,
                            height: 1.2, // Reduced line height
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // Event Name
                        Text(
                          purchase.eventName,
                          style: const TextStyle(
                            color: Color(0xFF0C2B3B), // Figma: #0c2b3b
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Medium
                            fontFamily: 'Rubik',
                            letterSpacing: 0.48,
                            height: 1.2, // Reduced line height
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),

                        // Location
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/map_pin_icon.svg',
                              width: 14,
                              height: 14,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                'La Monumental', // This should come from API
                                style: const TextStyle(
                                  color: Color(0xFF9BA8AF), // Figma: #9ba8af
                                  fontSize: 14, // Reduced font size
                                  fontWeight: FontWeight.w300, // Light
                                  fontFamily: 'Rubik',
                                  letterSpacing: 0.42,
                                  height: 1.2, // Reduced line height
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        // Ticket Quantity Info
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Ticket Star Icon
                            SvgPicture.asset(
                              'assets/icons/ticket-star.svg',
                              width: 24,
                              height: 24,
                              color: const Color(0xFF0FD263), // Figma: #0fd263
                            ),
                            SizedBox(width: 6.w),
                            // Ticket Quantity Text
                            Text(
                              '${purchase.quantity} Ticket\'s',
                              style: const TextStyle(
                                color: Color(0xFF0FD263), // Figma: #0fd263
                                fontSize: 12,
                                fontWeight: FontWeight.w400, // Regular
                                fontFamily: 'Inter',
                                height: 1.2, // Reduced line height
                                letterSpacing: 0,
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

            // Action Buttons (Positioned at top right)
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heart Icon
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: Color(0xFF727A80), // Figma: #727a80
                    ),
                  ),
                  SizedBox(width: 7.w),
                  // Share Icon
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/share.svg',
                      width: 20,
                      height: 20,
                      color: const Color(0xFF727A80), // Figma: #727a80
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
