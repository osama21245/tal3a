import 'package:equatable/equatable.dart';
import 'event_details_model.dart';

class EventDetailsResponseModel extends Equatable {
  final bool status;
  final String message;
  final EventDetailsModel event;

  const EventDetailsResponseModel({
    required this.status,
    required this.message,
    required this.event,
  });

  factory EventDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      event: EventDetailsModel.fromJson(json['event'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'event': event.toJson()};
  }

  @override
  List<Object?> get props => [status, message, event];
}
