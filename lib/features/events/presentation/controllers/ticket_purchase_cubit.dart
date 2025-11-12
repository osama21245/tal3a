import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/ticket_purchase_request_model.dart';
import '../../data/models/ticket_purchase_response_model.dart';
import '../../domain/repositories/events_repository.dart';
import 'ticket_purchase_state.dart';

class TicketPurchaseCubit extends Cubit<TicketPurchaseState> {
  final EventsRepository eventsRepository;

  TicketPurchaseCubit({required this.eventsRepository})
    : super(TicketPurchaseInitial());

  Future<void> purchaseTicket(TicketPurchaseRequestModel request) async {
    emit(TicketPurchaseLoading());

    final result = await eventsRepository.purchaseTicket(request);

    result.fold(
      (failure) {
        emit(TicketPurchaseError(failure.message));
      },
      (response) {
        emit(TicketPurchaseSuccess(response));
      },
    );
  }

  Future<void> purchaseMultipleTickets(
    List<TicketPurchaseRequestModel> requests,
  ) async {
    emit(TicketPurchaseLoading());

    try {
      final List<TicketPurchaseResponseModel> responses = [];

      for (var request in requests) {
        final result = await eventsRepository.purchaseTicket(request);

        result.fold(
          (failure) {
            emit(TicketPurchaseError(failure.message));
            return;
          },
          (response) {
            responses.add(response);
          },
        );
      }

      if (responses.length == requests.length) {
        emit(TicketPurchaseMultipleSuccess(responses));
      }
    } catch (e) {
      emit(TicketPurchaseError(e.toString()));
    }
  }
}
