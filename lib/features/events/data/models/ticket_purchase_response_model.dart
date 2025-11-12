import 'package:equatable/equatable.dart';

class TicketPurchaseResponseModel extends Equatable {
  final bool status;
  final String message;
  final String? transactionId;
  final String? qrCode;

  const TicketPurchaseResponseModel({
    required this.status,
    required this.message,
    this.transactionId,
    this.qrCode,
  });

  factory TicketPurchaseResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketPurchaseResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      transactionId: json['transactionId'] as String?,
      qrCode: json['qrCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'transactionId': transactionId,
      'qrCode': qrCode,
    };
  }

  @override
  List<Object?> get props => [status, message, transactionId, qrCode];
}
