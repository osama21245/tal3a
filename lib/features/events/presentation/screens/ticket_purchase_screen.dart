import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';
import '../../../../core/network/api_client.dart';
import '../widgets/ticket_purchase_screen/ticket_purchase_content_widget.dart';
import '../../data/datasources/events_remote_datasource.dart';
import '../../data/repositories/events_repository_impl.dart';
import '../../data/models/event_details_model.dart';
import '../controllers/ticket_purchase_cubit.dart';

class TicketPurchaseScreen extends StatelessWidget {
  final String eventId;
  final EventDetailsModel? eventDetails;

  const TicketPurchaseScreen({
    super.key,
    required this.eventId,
    this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (eventDetails == null) {
      // Show loading state if eventDetails is not provided
      return Scaffold(
        body: Column(
          children: [
            // Header with Training App Bar
            CustomAppBar(
              title: 'events.event_details'.tr(),
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            // Loading content
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF2BB8FF),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BlocProvider<TicketPurchaseCubit>(
      create: (context) {
        final remoteDataSource = EventsRemoteDataSourceImpl(
          apiClient: ApiClient(),
        );
        final repository = EventsRepositoryImpl(dataSource: remoteDataSource);
        return TicketPurchaseCubit(eventsRepository: repository);
      },
      child: Scaffold(
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
                    TicketPurchaseContentWidget(
                      eventId: eventId,
                      eventDetails: eventDetails!,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
