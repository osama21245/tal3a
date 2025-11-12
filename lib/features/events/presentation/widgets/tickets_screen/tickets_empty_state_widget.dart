import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/const/color_pallete.dart';

class TicketsEmptyStateWidget extends StatelessWidget {
  const TicketsEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ticket Icon
          SvgPicture.asset('assets/icons/ticket.svg', width: 88, height: 88),
          const SizedBox(height: 24),

          // Empty State Title
          Text(
            'events.no_tickets_title'.tr(),
            style: const TextStyle(
              color: ColorPalette.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Empty State Description
          Text(
            'events.no_tickets_description'.tr(),
            style: const TextStyle(
              color: ColorPalette.textGrey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
