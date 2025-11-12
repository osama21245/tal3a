import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/utils/date_formatter.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../data/models/event_details_model.dart';
import 'ticket_purchase_actions_widget.dart';

class TicketPurchaseContentWidget extends StatefulWidget {
  final String eventId;
  final EventDetailsModel eventDetails;

  const TicketPurchaseContentWidget({
    super.key,
    required this.eventId,
    required this.eventDetails,
  });

  @override
  State<TicketPurchaseContentWidget> createState() =>
      _TicketPurchaseContentWidgetState();
}

class _TicketPurchaseContentWidgetState
    extends State<TicketPurchaseContentWidget> {
  String? selectedTicketType;
  Map<String, int> ticketQuantities = {};
  Map<String, dynamic> selectedTickets = {};

  double _calculateTotalPrice() {
    double total = 0.0;
    for (var entry in ticketQuantities.entries) {
      final ticketType = widget.eventDetails.ticketTypes.firstWhere(
        (type) => type.name == entry.key,
      );
      total += ticketType.price * entry.value;
    }
    return total;
  }

  Map<String, dynamic> _getSelectedTickets() {
    final tickets = <String, dynamic>{};
    for (var entry in ticketQuantities.entries) {
      if (entry.value > 0) {
        tickets[entry.key] = entry.value;
      }
    }
    return tickets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Header
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    // Event Title
                    Text(
                      widget.eventDetails.name,
                      style: const TextStyle(
                        color: ColorPalette.trainingHeaderBg,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        height: 0.96,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 14.h),

                    // Event Date & Location
                    Column(
                      children: [
                        Text(
                          DateFormatter.formatEventDateWithTime(
                            widget.eventDetails.dateOfEvent,
                          ),
                          style: const TextStyle(
                            color: ColorPalette.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            height: 1.6,
                          ),
                        ),
                        Text(
                          widget.eventDetails.location,
                          style: const TextStyle(
                            color: ColorPalette.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Ticket Types List
              Container(
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
                child: Column(
                  children:
                      widget.eventDetails.ticketTypes.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final ticketType = entry.value;
                        final isLast =
                            index == widget.eventDetails.ticketTypes.length - 1;

                        return _buildTicketTypeItem(ticketType, isLast, index);
                      }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Bottom Actions
        TicketPurchaseActionsWidget(
          eventId: widget.eventId,
          eventDetails: widget.eventDetails,
          totalPrice: _calculateTotalPrice(),
          selectedTickets: _getSelectedTickets(),
        ),
      ],
    );
  }

  Widget _buildTicketTypeItem(dynamic ticketType, bool isLast, int index) {
    final isSoldOut = ticketType.ticketAvailable <= 0;
    final quantity = ticketQuantities[ticketType.name] ?? 0;

    return Container(
      padding: EdgeInsets.all(22.w),
      child: Column(
        children: [
          Row(
            children: [
              // Ticket Type Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ticket Type Header
                    Row(
                      children: [
                        // Icon based on ticket type
                        _getTicketTypeIcon(ticketType.name),
                        SizedBox(width: 11.w),
                        Text(
                          ticketType.name,
                          style: TextStyle(
                            color: _getTicketTypeColor(index, isSoldOut),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 11.h),

                    // Price and Sales Info
                    Row(
                      children: [
                        // Price Icon
                        SvgPicture.asset(
                          'assets/icons/Simplification.svg',
                          width: 16,
                          height: 19,
                        ),
                        SizedBox(width: 7.w),
                        // Price
                        Text(
                          '${ticketType.price}.00',
                          style: const TextStyle(
                            color: ColorPalette.trainingHeaderBg,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Rubik',
                            height: 1.875,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Sales End Date
                    Text(
                      'Sales end on ${DateFormatter.formatEventDate(ticketType.ticketSellEndDate)}',
                      style: const TextStyle(
                        color: ColorPalette.textGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Rubik',
                        height: 1.43,
                        letterSpacing: 0.42,
                      ),
                    ),
                  ],
                ),
              ),

              // Sold Out Badge or Quantity Selector
              if (isSoldOut)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE7E9),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    'Sold Out!',
                    style: const TextStyle(
                      color: Color(0xFFDA0B20),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      height: 1.6,
                    ),
                  ),
                )
              else
                _buildQuantitySelector(ticketType.name, quantity),
            ],
          ),

          // Divider (if not last item)
          if (!isLast) ...[
            SizedBox(height: 18.h),
            Container(
              height: 1.h,
              width: double.infinity,
              child: CustomPaint(painter: DashedLinePainter()),
            ),
            SizedBox(height: 18.h),
          ],
        ],
      ),
    );
  }

  Widget _getTicketTypeIcon(String ticketTypeName) {
    String iconPath;
    switch (ticketTypeName.toLowerCase()) {
      case 'early bird':
        iconPath = 'assets/icons/first_tiket_start.svg';
        break;
      case 'general':
        iconPath = 'assets/icons/secound-star.svg';
        break;
      case 'vip':
        iconPath = 'assets/icons/third_star.svg';
        break;
      default:
        iconPath = 'assets/icons/first_tiket_start.svg';
    }

    return SvgPicture.asset(iconPath, width: 24, height: 24);
  }

  Color _getTicketTypeColor(int index, bool isSoldOut) {
    final colors = [
      const Color(0xFFB950E9), // First color
      const Color(0xFF2BB8FF), // Second color
      const Color(0xFFF1B739), // Third color
    ];

    // Get color based on index
    final colorIndex = index % colors.length;
    final baseColor = colors[colorIndex];

    // Apply 50% opacity only if sold out, otherwise 100% opacity
    return isSoldOut ? baseColor.withOpacity(0.5) : baseColor;
  }

  Widget _buildQuantitySelector(String ticketTypeName, int quantity) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Down Arrow Button
          GestureDetector(
            onTap: () {
              setState(() {
                if (quantity > 0) {
                  ticketQuantities[ticketTypeName] = quantity - 1;
                  if (ticketQuantities[ticketTypeName] == 0) {
                    ticketQuantities.remove(ticketTypeName);
                    if (selectedTicketType == ticketTypeName) {
                      selectedTicketType = null;
                    }
                  }
                }
              });
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorPalette.trainingHeaderBg,
              size: 18,
            ),
          ),
          SizedBox(width: 8.w),

          // Quantity Text
          Text(
            quantity.toString(),
            style: const TextStyle(
              color: ColorPalette.trainingHeaderBg,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              height: 1.6,
            ),
          ),
          SizedBox(width: 8.w),

          // Up Arrow Button
          GestureDetector(
            onTap: () {
              setState(() {
                ticketQuantities[ticketTypeName] = quantity + 1;
                selectedTicketType = ticketTypeName;
              });
            },
            child: Icon(
              Icons.arrow_forward_ios_sharp,
              color: ColorPalette.trainingHeaderBg,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFE8E8E8).withOpacity(0.5)
          ..strokeWidth = 1.0;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
