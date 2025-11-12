import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/routing/routes.dart';
import '../../../data/models/event_details_model.dart';

class EventDetailsActionsWidget extends StatelessWidget {
  final String eventId;
  final bool isFromTicketsScreen;
  final EventDetailsModel? eventDetails;

  const EventDetailsActionsWidget({
    super.key,
    required this.eventId,
    this.isFromTicketsScreen = false,
    this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          if (isFromTicketsScreen) ...[
            // Tickets Screen Design: Countdown and QR Code Button
            _buildTicketsScreenActions(),
          ] else ...[
            // Events Screen Design: Price and Buy Tickets Button
            _buildEventsScreenActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceDisplay(String price) {
    return Row(
      children: [
        // Dollar Icon
        SvgPicture.asset(
          'assets/icons/dollar_sign.svg',
          width: 22.w,
          height: 24.h,
          color: Colors.white,
        ),
        SizedBox(width: 5.w),
        // Price Text
        Text(
          price,
          style: const TextStyle(
            color: Color(0xFF262627),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeDisplay(String minPrice, String maxPrice) {
    return Row(
      children: [
        // Min Price
        _buildPriceDisplay(minPrice),
        SizedBox(width: 10.w),
        // Colon Separator
        Text(
          ':',
          style: const TextStyle(
            color: Color(0xFF262627),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
            height: 1.5,
          ),
        ),
        SizedBox(width: 10.w),
        // Max Price
        _buildPriceDisplay(maxPrice),
      ],
    );
  }

  double _calculateMinPrice() {
    if (eventDetails?.ticketTypes.isEmpty ?? true) {
      return 0.0;
    }

    double minPrice = eventDetails!.ticketTypes.first.price.toDouble();
    for (var ticketType in eventDetails!.ticketTypes) {
      if (ticketType.price < minPrice) {
        minPrice = ticketType.price.toDouble();
      }
    }
    return minPrice;
  }

  double _calculateMaxPrice() {
    if (eventDetails?.ticketTypes.isEmpty ?? true) {
      return 0.0;
    }

    double maxPrice = eventDetails!.ticketTypes.first.price.toDouble();
    for (var ticketType in eventDetails!.ticketTypes) {
      if (ticketType.price > maxPrice) {
        maxPrice = ticketType.price.toDouble();
      }
    }
    return maxPrice;
  }

  double _calculateAveragePrice() {
    if (eventDetails?.ticketTypes.isEmpty ?? true) {
      return 0.0;
    }

    double totalPrice = 0.0;
    for (var ticketType in eventDetails!.ticketTypes) {
      totalPrice += ticketType.price.toDouble();
    }
    return totalPrice / eventDetails!.ticketTypes.length;
  }

  Widget _buildTicketsScreenActions() {
    return Column(
      children: [
        // View QR Code Button
        Container(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigate to QR code screen
              // This should show the ticket QR code for entry
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2BB8FF), // Figma: #2bb8ff
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'View QR Code',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Rubik',
                letterSpacing: 0.54,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // Countdown Timer
        Text(
          'Only 12 Days 10 Hours │15 Minutes 60 Seconds Until the Event',
          style: const TextStyle(
            color: Color(0xFF354F5C), // Figma: #354f5c
            fontSize: 11.5,
            fontWeight: FontWeight.w300, // Light
            fontFamily: 'Rubik',
            letterSpacing: 0.345,
            height: 1.74, // 20px line height
          ),
        ),
      ],
    );
  }

  Widget _buildEventsScreenActions(BuildContext context) {
    return Column(
      children: [
        // Price Label
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'events.price'.tr(),
            style: const TextStyle(
              color: Color(0xFF0C2B3B), // Figma: #0c2b3b
              fontSize: 18,
              fontWeight: FontWeight.w400, // Medium
              fontFamily: 'Rubik',
              letterSpacing: 0.54,
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // Price Range and Tickets Button Row
        Row(
          children: [
            // Price Range Section
            Container(
              width: 166.w,
              height: 24.h,
              child: Row(
                children: [
                  // Min Price
                  Container(
                    width: 71.w,
                    child: Row(
                      children: [
                        // Simplification Icon
                        SvgPicture.asset(
                          'assets/icons/Simplification.svg',
                          width: 22,
                          height: 24,
                        ),
                        SizedBox(width: 3.w),
                        // Price Text
                        Text(
                          '${_calculateMinPrice().toStringAsFixed(2)} ',
                          style: const TextStyle(
                            color: Color(0xFF262627), // Figma: #262627
                            fontSize: 16,
                            fontWeight: FontWeight.w400, // Regular
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                            height: 1.5, // 24px line height
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Separator
                  Text(
                    ':',
                    style: const TextStyle(
                      color: Color(0xFF262627), // Figma: #262627
                      fontSize: 16,
                      fontWeight: FontWeight.w700, // Bold
                      fontFamily: 'Inter',
                      letterSpacing: 0,
                      height: 1.5, // 24px line height
                    ),
                  ),

                  // Max Price
                  Container(
                    width: 70.w,
                    child: Row(
                      children: [
                        SizedBox(width: 3.w),
                        // Simplification Icon
                        SvgPicture.asset(
                          'assets/icons/Simplification.svg',
                          width: 22,
                          height: 24,
                        ),
                        SizedBox(width: 3.w),
                        // Price Text
                        Text(
                          _calculateMaxPrice().toStringAsFixed(2),
                          style: const TextStyle(
                            color: Color(0xFF262627), // Figma: #262627
                            fontSize: 16,
                            fontWeight: FontWeight.w400, // Regular
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                            height: 1.5, // 24px line height
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Tickets Button
            Container(
              width: 167.w,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to ticket purchase screen with event details
                  Navigator.of(context).pushNamed(
                    Routes.ticketPurchaseScreen,
                    arguments: {
                      'eventId': eventId,
                      'eventDetails': eventDetails,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2BB8FF), // Figma: #2bb8ff
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'events.tickets'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500, // Medium
                    fontFamily: 'Rubik',
                    letterSpacing: 0.54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
