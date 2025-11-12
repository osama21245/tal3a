import 'package:equatable/equatable.dart';

class TicketTypeModel extends Equatable {
  final String id;
  final String name;
  final int price;
  final int ticketAvailable;
  final String ticketSellEndDate;
  final int ticketSold;

  const TicketTypeModel({
    required this.id,
    required this.name,
    required this.price,
    required this.ticketAvailable,
    required this.ticketSellEndDate,
    required this.ticketSold,
  });

  factory TicketTypeModel.fromJson(Map<String, dynamic> json) {
    return TicketTypeModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      ticketAvailable: json['ticketAvailable'] as int,
      ticketSellEndDate: json['ticketSellEndDate'] as String,
      ticketSold: json['ticketSold'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'ticketAvailable': ticketAvailable,
      'ticketSellEndDate': ticketSellEndDate,
      'ticketSold': ticketSold,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    ticketAvailable,
    ticketSellEndDate,
    ticketSold,
  ];
}
