import 'package:equatable/equatable.dart';
import '../../data/models/ticket_purchase_response_model.dart';

abstract class TicketPurchaseState extends Equatable {
  const TicketPurchaseState();

  @override
  List<Object?> get props => [];
}

class TicketPurchaseInitial extends TicketPurchaseState {}

class TicketPurchaseLoading extends TicketPurchaseState {}

class TicketPurchaseSuccess extends TicketPurchaseState {
  final TicketPurchaseResponseModel response;

  const TicketPurchaseSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class TicketPurchaseMultipleSuccess extends TicketPurchaseState {
  final List<TicketPurchaseResponseModel> responses;

  const TicketPurchaseMultipleSuccess(this.responses);

  @override
  List<Object?> get props => [responses];
}

class TicketPurchaseError extends TicketPurchaseState {
  final String message;

  const TicketPurchaseError(this.message);

  @override
  List<Object?> get props => [message];
}
