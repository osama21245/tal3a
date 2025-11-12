class PurchasedTicketModel {
  final String eventId;
  final String eventName;
  final String eventIcon;
  final String ticketType;
  final int quantity;
  final String purchasedAt;

  const PurchasedTicketModel({
    required this.eventId,
    required this.eventName,
    required this.eventIcon,
    required this.ticketType,
    required this.quantity,
    required this.purchasedAt,
  });

  factory PurchasedTicketModel.fromJson(Map<String, dynamic> json) {
    return PurchasedTicketModel(
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      eventIcon: json['eventIcon'] as String,
      ticketType: json['ticketType'] as String,
      quantity: json['quantity'] as int,
      purchasedAt: json['purchasedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'eventIcon': eventIcon,
      'ticketType': ticketType,
      'quantity': quantity,
      'purchasedAt': purchasedAt,
    };
  }

  PurchasedTicketModel copyWith({
    String? eventId,
    String? eventName,
    String? eventIcon,
    String? ticketType,
    int? quantity,
    String? purchasedAt,
  }) {
    return PurchasedTicketModel(
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      eventIcon: eventIcon ?? this.eventIcon,
      ticketType: ticketType ?? this.ticketType,
      quantity: quantity ?? this.quantity,
      purchasedAt: purchasedAt ?? this.purchasedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PurchasedTicketModel &&
        other.eventId == eventId &&
        other.eventName == eventName &&
        other.eventIcon == eventIcon &&
        other.ticketType == ticketType &&
        other.quantity == quantity &&
        other.purchasedAt == purchasedAt;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^
        eventName.hashCode ^
        eventIcon.hashCode ^
        ticketType.hashCode ^
        quantity.hashCode ^
        purchasedAt.hashCode;
  }

  @override
  String toString() {
    return 'PurchasedTicketModel(eventId: $eventId, eventName: $eventName, eventIcon: $eventIcon, ticketType: $ticketType, quantity: $quantity, purchasedAt: $purchasedAt)';
  }
}
