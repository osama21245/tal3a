import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';
import 'data/datasources/events_remote_datasource.dart';
import 'data/repositories/events_repository_impl.dart';
import 'presentation/controllers/purchased_tickets_cubit.dart';
import 'presentation/screens/tickets_screen.dart';

class TicketsFeature {
  static Widget getTicketsScreen() {
    return BlocProvider<PurchasedTicketsCubit>(
      create: (context) {
        final remoteDataSource = EventsRemoteDataSourceImpl(
          apiClient: ApiClient(),
        );
        final repository = EventsRepositoryImpl(dataSource: remoteDataSource);
        return PurchasedTicketsCubit(eventsRepository: repository)
          ..loadPurchasedTickets();
      },
      child: const TicketsScreen(),
    );
  }
}
