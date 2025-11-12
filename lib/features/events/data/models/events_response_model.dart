import 'event_model.dart';

class EventsResponseModel {
  final bool status;
  final String message;
  final int page;
  final int totalPages;
  final int totalEvents;
  final List<EventModel> events;

  EventsResponseModel({
    required this.status,
    required this.message,
    required this.page,
    required this.totalPages,
    required this.totalEvents,
    required this.events,
  });

  factory EventsResponseModel.fromJson(Map<String, dynamic> json) {
    return EventsResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      page: json['page'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalEvents: json['totalEvents'] ?? 0,
      events:
          (json['events'] as List<dynamic>?)
              ?.map((eventJson) => EventModel.fromJson(eventJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'page': page,
      'totalPages': totalPages,
      'totalEvents': totalEvents,
      'events': events.map((event) => event.toJson()).toList(),
    };
  }

  EventsResponseModel copyWith({
    bool? status,
    String? message,
    int? page,
    int? totalPages,
    int? totalEvents,
    List<EventModel>? events,
  }) {
    return EventsResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      totalEvents: totalEvents ?? this.totalEvents,
      events: events ?? this.events,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventsResponseModel &&
        other.status == status &&
        other.message == message &&
        other.page == page &&
        other.totalPages == totalPages &&
        other.totalEvents == totalEvents &&
        other.events.toString() == events.toString();
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        page.hashCode ^
        totalPages.hashCode ^
        totalEvents.hashCode ^
        events.hashCode;
  }

  @override
  String toString() {
    return 'EventsResponseModel(status: $status, message: $message, page: $page, totalPages: $totalPages, totalEvents: $totalEvents, events: $events)';
  }
}
