import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/events_repository.dart';
import 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final EventsRepository _eventsRepository;

  EventDetailsCubit({required EventsRepository eventsRepository})
    : _eventsRepository = eventsRepository,
      super(EventDetailsInitial());

  Future<void> loadEventDetails(String eventId) async {
    print('🎯 EventDetailsCubit: Loading event details for ID: $eventId');
    emit(EventDetailsLoading());

    final result = await _eventsRepository.getEventDetails(eventId);

    result.fold(
      (failure) {
        print('🎯 EventDetailsCubit: Error - ${failure.message}');
        emit(
          EventDetailsError(
            message:
                'There is a problem retrieving event details. Try again later.',
          ),
        );
      },
      (response) {
        print('🎯 EventDetailsCubit: API Response received');
        print('🎯 Status: ${response.status}');
        print('🎯 Event: ${response.event.name}');

        if (response.status) {
          print('🎯 EventDetailsCubit: Emitting EventDetailsLoaded');
          emit(EventDetailsLoaded(eventDetails: response.event));
        } else {
          print(
            '🎯 EventDetailsCubit: Emitting EventDetailsError - API status is false',
          );
          emit(
            EventDetailsError(
              message:
                  'There is a problem retrieving event details. Try again later.',
            ),
          );
        }
      },
    );
  }
}
