import '../../data/models/purchased_ticket_model.dart';

abstract class PurchasedTicketsState {}

class PurchasedTicketsInitial extends PurchasedTicketsState {}

class PurchasedTicketsLoading extends PurchasedTicketsState {}

class PurchasedTicketsLoaded extends PurchasedTicketsState {
  final List<PurchasedTicketModel> purchases;
  final int total;
  final int page;
  final int totalPages;

  PurchasedTicketsLoaded({
    required this.purchases,
    required this.total,
    required this.page,
    required this.totalPages,
  });
}

class PurchasedTicketsError extends PurchasedTicketsState {
  final String message;

  PurchasedTicketsError({required this.message});
}
