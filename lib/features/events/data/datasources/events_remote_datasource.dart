import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../models/events_response_model.dart';
import '../models/event_details_response_model.dart';
import '../models/ticket_purchase_request_model.dart';
import '../models/ticket_purchase_response_model.dart';
import '../models/purchased_tickets_response_model.dart';

abstract class EventsRemoteDataSource {
  Future<EventsResponseModel> getAllEvents({int page = 1, int limit = 10});
  Future<EventDetailsResponseModel> getEventDetails(String eventId);
  Future<TicketPurchaseResponseModel> purchaseTicket(
    TicketPurchaseRequestModel request,
  );
  Future<PurchasedTicketsResponseModel> getMyPurchases({
    int page = 1,
    int limit = 10,
  });
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final ApiClient _apiClient;

  EventsRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<EventsResponseModel> getAllEvents({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiClient.getAuthenticated(
        ApiConstants.getAllEventsEndpoint,
        queryParams: queryParameters,
      );

      print('🎯 EventsRemoteDataSource: API response received');
      print('🎯 IsSuccess: ${response.isSuccess}');
      print('🎯 Data: ${response.data}');

      if (response.isSuccess) {
        print('🎯 EventsRemoteDataSource: Parsing response data');
        print('🎯 Response.data type: ${response.data.runtimeType}');

        // response.data is already a Map, no need to jsonDecode
        final parsedResponse = EventsResponseModel.fromJson(response.data);
        print(
          '🎯 EventsRemoteDataSource: Parsed successfully - ${parsedResponse.events.length} events',
        );
        return parsedResponse;
      } else {
        print('🎯 EventsRemoteDataSource: API call failed - ${response.error}');
        throw ServerException(
          message: 'Failed to fetch events: ${response.error}',
        );
      }
    } catch (e) {
      throw ServerException(message: 'Failed to fetch events: $e');
    }
  }

  @override
  Future<EventDetailsResponseModel> getEventDetails(String eventId) async {
    try {
      final endpoint = '${ApiConstants.getEventDetailsEndpoint}/$eventId';

      print('🎯 EventsRemoteDataSource: Calling API for event $eventId');
      print('🎯 Endpoint: $endpoint');

      final response = await _apiClient.getAuthenticated(endpoint);

      print('🎯 EventsRemoteDataSource: API response received');
      print('🎯 IsSuccess: ${response.isSuccess}');
      print('🎯 Data: ${response.data}');

      if (response.isSuccess) {
        print('🎯 EventsRemoteDataSource: Parsing response data');
        print('🎯 Response.data type: ${response.data.runtimeType}');

        // response.data is already a Map, no need to jsonDecode
        final parsedResponse = EventDetailsResponseModel.fromJson(
          response.data,
        );
        print(
          '🎯 EventsRemoteDataSource: Parsed successfully - Event: ${parsedResponse.event.name}',
        );
        return parsedResponse;
      } else {
        print('🎯 EventsRemoteDataSource: API call failed - ${response.error}');
        throw Exception('Failed to fetch event details: ${response.error}');
      }
    } catch (e) {
      print('🎯 EventsRemoteDataSource: Exception - $e');
      throw Exception('Failed to fetch event details: $e');
    }
  }

  @override
  Future<TicketPurchaseResponseModel> purchaseTicket(
    TicketPurchaseRequestModel request,
  ) async {
    try {
      final response = await _apiClient.postAuthenticated(
        ApiConstants.purchaseTicketEndpoint,
        body: request.toJson(),
      );

      if (response.isSuccess) {
        return TicketPurchaseResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to purchase ticket: ${response.error}');
      }
    } catch (e) {
      throw Exception('Failed to purchase ticket: $e');
    }
  }

  @override
  Future<PurchasedTicketsResponseModel> getMyPurchases({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiClient.getAuthenticated(
        ApiConstants.myPurchasesEndpoint,
        queryParams: queryParameters,
      );

      print('🎯 EventsRemoteDataSource: My Purchases API response received');
      print('🎯 IsSuccess: ${response.isSuccess}');
      print('🎯 Data: ${response.data}');

      if (response.isSuccess) {
        print('🎯 EventsRemoteDataSource: Parsing my purchases response data');
        print('🎯 Response.data type: ${response.data.runtimeType}');

        // response.data is already a Map, no need to jsonDecode
        final parsedResponse = PurchasedTicketsResponseModel.fromJson(
          response.data,
        );
        print(
          '🎯 EventsRemoteDataSource: Parsed successfully - ${parsedResponse.purchases.length} purchases',
        );
        return parsedResponse;
      } else {
        print(
          '🎯 EventsRemoteDataSource: My Purchases API call failed - ${response.error}',
        );
        throw Exception('Failed to fetch my purchases: ${response.error}');
      }
    } catch (e) {
      throw Exception('Failed to fetch my purchases: $e');
    }
  }
}
