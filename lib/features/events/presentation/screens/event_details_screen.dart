import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';
import '../widgets/event_details_screen/event_details_content_widget.dart';
import '../widgets/event_details_screen/event_details_image_widget.dart';
import '../widgets/event_details_screen/event_details_actions_widget.dart';
import '../controllers/event_details_cubit.dart';
import '../controllers/event_details_state.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  final bool isFromTicketsScreen;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    this.isFromTicketsScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with Training App Bar
          CustomAppBar(
            title: 'events.event_details'.tr(),
            onBackPressed: () => Navigator.of(context).pop(),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EventDetailsImageWidget(),
                  EventDetailsContentWidget(eventId: eventId),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Bottom Actions
          BlocBuilder<EventDetailsCubit, EventDetailsState>(
            builder: (context, state) {
              return EventDetailsActionsWidget(
                eventId: eventId,
                eventDetails:
                    state is EventDetailsLoaded ? state.eventDetails : null,
                isFromTicketsScreen: isFromTicketsScreen,
              );
            },
          ),
        ],
      ),
    );
  }
}
