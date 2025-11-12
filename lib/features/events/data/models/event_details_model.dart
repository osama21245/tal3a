import 'package:equatable/equatable.dart';
import 'ticket_type_model.dart';

class EventDetailsModel extends Equatable {
  final String id;
  final String eventIcon;
  final String name;
  final String description;
  final String dateOfEvent;
  final String location;
  final List<TicketTypeModel> ticketTypes;
  final String createdAt;
  final String updatedAt;
  final bool isActive;

  const EventDetailsModel({
    required this.id,
    required this.eventIcon,
    required this.name,
    required this.description,
    required this.dateOfEvent,
    required this.location,
    required this.ticketTypes,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsModel(
      id: json['_id'] as String,
      eventIcon: json['eventIcon'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      dateOfEvent: json['dateOfEvent'] as String,
      location: json['location'] as String,
      ticketTypes:
          (json['ticketTypes'] as List<dynamic>)
              .map((e) => TicketTypeModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'eventIcon': eventIcon,
      'name': name,
      'description': description,
      'dateOfEvent': dateOfEvent,
      'location': location,
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
    id,
    eventIcon,
    name,
    description,
    dateOfEvent,
    location,
    ticketTypes,
    createdAt,
    updatedAt,
    isActive,
  ];
}
