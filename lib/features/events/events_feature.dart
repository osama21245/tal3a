import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';
import 'data/datasources/events_remote_datasource.dart';
import 'data/repositories/events_repository_impl.dart';
import 'presentation/controllers/events_cubit.dart';
import 'presentation/screens/events_screen.dart';

class EventsFeature {
  static Widget getEventsScreen() {
    return BlocProvider(
      create:
          (context) => EventsCubit(
            eventsRepository: EventsRepositoryImpl(
              dataSource: EventsRemoteDataSourceImpl(apiClient: ApiClient()),
            ),
          ),
      child: const EventsScreen(),
    );
  }
}
