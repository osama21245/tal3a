import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../data/models/event_details_model.dart';
import '../../../data/models/ticket_purchase_request_model.dart';
import '../../controllers/ticket_purchase_cubit.dart';
import '../../controllers/ticket_purchase_state.dart';

class TicketPurchaseActionsWidget extends StatelessWidget {
  final String eventId;
  final EventDetailsModel eventDetails;
  final double totalPrice;
  final Map<String, dynamic> selectedTickets;

  const TicketPurchaseActionsWidget({
    super.key,
    required this.eventId,
    required this.eventDetails,
    required this.totalPrice,
    required this.selectedTickets,
  });

  void _handleTicketPurchase(BuildContext context) {
    // Prepare purchase requests for each selected ticket type
    final List<TicketPurchaseRequestModel> purchaseRequests = [];

    for (var entry in selectedTickets.entries) {
      purchaseRequests.add(
        TicketPurchaseRequestModel(
          eventId: eventId,
          ticketType: entry.key,
          quantity: entry.value,
        ),
      );
    }

    // Use cubit to purchase tickets
    context.read<TicketPurchaseCubit>().purchaseMultipleTickets(
      purchaseRequests,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketPurchaseCubit, TicketPurchaseState>(
      listener: (context, state) {
        if (state is TicketPurchaseLoading) {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ColorPalette.primaryBlue,
                  ),
                ),
              );
            },
          );
        } else if (state is TicketPurchaseMultipleSuccess) {
          // Hide loading indicator
          Navigator.of(context).pop();

          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tickets purchased successfully!'),
              backgroundColor: ColorPalette.primaryBlue,
            ),
          );

          // Navigate back to event details
          Navigator.of(context).pop();
        } else if (state is TicketPurchaseError) {
          // Hide loading indicator
          Navigator.of(context).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to purchase tickets: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: _buildActionsContent(context),
    );
  }

  Widget _buildActionsContent(BuildContext context) {
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
          // Home Indicator
          Container(
            width: 150.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1A181A),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          SizedBox(height: 20.h),

          // Price Section
          Row(
            children: [
              // Price Label
              Text(
                'events.price'.tr(),
                style: const TextStyle(
                  color: ColorPalette.trainingHeaderBg,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Rubik',
                  letterSpacing: 0.54,
                ),
              ),
              SizedBox(width: 20.w),

              // Total Price
              Row(
                children: [
                  // Price Icon
                  SvgPicture.asset(
                    'assets/icons/Simplification.svg',
                    width: 22.w,
                    height: 26.h,
                  ),
                  SizedBox(width: 5.w),
                  // Price Text
                  Text(
                    totalPrice.toStringAsFixed(2),
                    style: const TextStyle(
                      color: ColorPalette.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Purchase Button
          Container(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed:
                  selectedTickets.isNotEmpty
                      ? () {
                        // Handle ticket purchase
                        _handleTicketPurchase(context);
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryBlue,
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
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Rubik',
                  letterSpacing: 0.54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
