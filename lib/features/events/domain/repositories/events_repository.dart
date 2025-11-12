import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import '../../data/models/events_response_model.dart';
import '../../data/models/event_details_response_model.dart';
import '../../data/models/ticket_purchase_request_model.dart';
import '../../data/models/ticket_purchase_response_model.dart';
import '../../data/models/purchased_tickets_response_model.dart';

abstract class EventsRepository {
  Future<Either<Failure, EventsResponseModel>> getAllEvents({
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, EventDetailsResponseModel>> getEventDetails(
    String eventId,
  );
  Future<Either<Failure, TicketPurchaseResponseModel>> purchaseTicket(
    TicketPurchaseRequestModel request,
  );
  Future<Either<Failure, PurchasedTicketsResponseModel>> getMyPurchases({
    int page = 1,
    int limit = 10,
  });
}
