import 'package:equatable/equatable.dart';

class TicketPurchaseRequestModel extends Equatable {
  final String eventId;
  final String ticketType;
  final int quantity;

  const TicketPurchaseRequestModel({
    required this.eventId,
    required this.ticketType,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {'eventId': eventId, 'ticketType': ticketType, 'quantity': quantity};
  }

  @override
  List<Object?> get props => [eventId, ticketType, quantity];
}
