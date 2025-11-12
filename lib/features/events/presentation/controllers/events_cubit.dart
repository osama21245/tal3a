import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/events_repository.dart';
import '../../data/models/event_model.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventsRepository _eventsRepository;

  EventsCubit({required EventsRepository eventsRepository})
    : _eventsRepository = eventsRepository,
      super(EventsInitial());

  Future<void> loadEvents({int page = 1, int limit = 10}) async {
    if (page == 1) {
      emit(EventsLoading());
    }

    final result = await _eventsRepository.getAllEvents(
      page: page,
      limit: limit,
    );

    result.fold(
      (failure) {
        print('🎯 EventsCubit: Error - ${failure.message}');
        emit(
          EventsError(
            message: 'There is a problem retrieving events. Try again later.',
          ),
        );
      },
      (response) {
        print('🎯 EventsCubit: API Response received');
        print('🎯 Status: ${response.status}');
        print('🎯 Events count: ${response.events.length}');
        print('🎯 Total events: ${response.totalEvents}');
        print('🎯 Total pages: ${response.totalPages}');

        if (response.status) {
          final currentState = state;
          List<EventModel> allEvents = [];

          if (currentState is EventsLoaded && page > 1) {
            allEvents = List.from(currentState.events);
            allEvents.addAll(response.events);
          } else {
            allEvents = response.events;
          }

          // Handle pagination logic
          bool hasMoreData = false;
          if (response.totalPages > 0) {
            hasMoreData = response.page < response.totalPages;
          } else if (response.events.isNotEmpty) {
            hasMoreData = false;
          }

          print('🎯 Emitting EventsLoaded with ${allEvents.length} events');
          emit(
            EventsLoaded(
              events: allEvents,
              currentPage: response.page,
              totalPages: response.totalPages,
              totalEvents: response.totalEvents,
              hasMoreData: hasMoreData,
            ),
          );
        } else {
          print('🎯 Emitting EventsError - API status is false');
          emit(
            EventsError(
              message: 'There is a problem retrieving events. Try again later.',
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreEvents({int limit = 10}) async {
    final currentState = state;
    if (currentState is EventsLoaded && currentState.hasMoreData) {
      await loadEvents(page: currentState.currentPage + 1, limit: limit);
    }
  }

  Future<void> refreshEvents({int limit = 10}) async {
    await loadEvents(page: 1, limit: limit);
  }
}
