import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/events_repository.dart';
import 'purchased_tickets_state.dart';

class PurchasedTicketsCubit extends Cubit<PurchasedTicketsState> {
  final EventsRepository _eventsRepository;

  PurchasedTicketsCubit({required EventsRepository eventsRepository})
    : _eventsRepository = eventsRepository,
      super(PurchasedTicketsInitial());

  Future<void> loadPurchasedTickets({int page = 1, int limit = 10}) async {
    print('🎯 PurchasedTicketsCubit: Loading purchased tickets');
    emit(PurchasedTicketsLoading());

    final result = await _eventsRepository.getMyPurchases(
      page: page,
      limit: limit,
    );

    result.fold(
      (failure) {
        print('🎯 PurchasedTicketsCubit: Error - ${failure.message}');
        emit(
          PurchasedTicketsError(
            message:
                'There is a problem retrieving your tickets. Try again later.',
          ),
        );
      },
      (response) {
        print('🎯 PurchasedTicketsCubit: API Response received');
        print('🎯 Status: ${response.status}');
        print('🎯 Total: ${response.total}');

        if (response.status) {
          print('🎯 PurchasedTicketsCubit: Emitting PurchasedTicketsLoaded');
          emit(
            PurchasedTicketsLoaded(
              purchases: response.purchases,
              total: response.total,
              page: response.page,
              totalPages: response.totalPages,
            ),
          );
        } else {
          print(
            '🎯 PurchasedTicketsCubit: Emitting PurchasedTicketsError - API status is false',
          );
          emit(PurchasedTicketsError(message: response.message));
        }
      },
    );
  }
}
