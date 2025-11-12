import 'purchased_ticket_model.dart';

class PurchasedTicketsResponseModel {
  final bool status;
  final String message;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<PurchasedTicketModel> purchases;

  const PurchasedTicketsResponseModel({
    required this.status,
    required this.message,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.purchases,
  });

  factory PurchasedTicketsResponseModel.fromJson(Map<String, dynamic> json) {
    return PurchasedTicketsResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      totalPages: json['totalPages'] as int,
      purchases:
          (json['purchases'] as List<dynamic>)
              .map(
                (e) => PurchasedTicketModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'purchases': purchases.map((e) => e.toJson()).toList(),
    };
  }

  PurchasedTicketsResponseModel copyWith({
    bool? status,
    String? message,
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    List<PurchasedTicketModel>? purchases,
  }) {
    return PurchasedTicketsResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      purchases: purchases ?? this.purchases,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PurchasedTicketsResponseModel &&
        other.status == status &&
        other.message == message &&
        other.page == page &&
        other.limit == limit &&
        other.total == total &&
        other.totalPages == totalPages &&
        other.purchases == purchases;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        total.hashCode ^
        totalPages.hashCode ^
        purchases.hashCode;
  }

  @override
  String toString() {
    return 'PurchasedTicketsResponseModel(status: $status, message: $message, page: $page, limit: $limit, total: $total, totalPages: $totalPages, purchases: $purchases)';
  }
}
