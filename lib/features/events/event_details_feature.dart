import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';
import 'data/datasources/events_remote_datasource.dart';
import 'data/repositories/events_repository_impl.dart';
import 'presentation/controllers/event_details_cubit.dart';
import 'presentation/screens/event_details_screen.dart';

class EventDetailsFeature {
  static Widget getEventDetailsScreen(
    String eventId, {
    bool isFromTicketsScreen = false,
  }) {
    return BlocProvider<EventDetailsCubit>(
      create: (context) {
        final remoteDataSource = EventsRemoteDataSourceImpl(
          apiClient: ApiClient(),
        );
        final repository = EventsRepositoryImpl(dataSource: remoteDataSource);
        return EventDetailsCubit(eventsRepository: repository)
          ..loadEventDetails(eventId);
      },
      child: EventDetailsScreen(
        eventId: eventId,
        isFromTicketsScreen: isFromTicketsScreen,
      ),
    );
  }
}
