import 'package:fpdart/fpdart.dart';
import 'package:tal3a/core/exceptions/failure.dart';
import 'package:tal3a/core/utils/try_and_catch.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_remote_datasource.dart';
import '../models/events_response_model.dart';
import '../models/event_details_response_model.dart';
import '../models/ticket_purchase_request_model.dart';
import '../models/ticket_purchase_response_model.dart';
import '../models/purchased_tickets_response_model.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource _dataSource;

  EventsRepositoryImpl({required EventsRemoteDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, EventsResponseModel>> getAllEvents({
    int page = 1,
    int limit = 10,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getAllEvents(page: page, limit: limit);
    });
  }

  @override
  Future<Either<Failure, EventDetailsResponseModel>> getEventDetails(
    String eventId,
  ) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getEventDetails(eventId);
    });
  }

  @override
  Future<Either<Failure, TicketPurchaseResponseModel>> purchaseTicket(
    TicketPurchaseRequestModel request,
  ) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.purchaseTicket(request);
    });
  }

  @override
  Future<Either<Failure, PurchasedTicketsResponseModel>> getMyPurchases({
    int page = 1,
    int limit = 10,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await _dataSource.getMyPurchases(page: page, limit: limit);
    });
  }
}
