import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';
import 'data/datasources/events_remote_datasource.dart';
import 'data/repositories/events_repository_impl.dart';
import 'data/models/event_details_model.dart';
import 'presentation/controllers/event_details_cubit.dart';
import 'presentation/screens/ticket_purchase_screen.dart';

class TicketPurchaseFeature {
  static Widget getTicketPurchaseScreen(
    String eventId, {
    EventDetailsModel? eventDetails,
  }) {
    if (eventDetails != null) {
      // Use provided event details, no need for API call
      return TicketPurchaseScreen(eventId: eventId, eventDetails: eventDetails);
    } else {
      // Fallback: fetch event details from API
      return BlocProvider<EventDetailsCubit>(
        create: (context) {
          final remoteDataSource = EventsRemoteDataSourceImpl(
            apiClient: ApiClient(),
          );
          final repository = EventsRepositoryImpl(dataSource: remoteDataSource);
          return EventDetailsCubit(eventsRepository: repository)
            ..loadEventDetails(eventId);
        },
        child: TicketPurchaseScreen(eventId: eventId),
      );
    }
  }
}
