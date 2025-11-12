import 'package:equatable/equatable.dart';
import '../../data/models/event_model.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {
  final List<EventModel> events;

  const EventsLoading({this.events = const []});

  @override
  List<Object?> get props => [events];
}

class EventsLoaded extends EventsState {
  final List<EventModel> events;
  final int currentPage;
  final int totalPages;
  final int totalEvents;
  final bool hasMoreData;

  const EventsLoaded({
    required this.events,
    required this.currentPage,
    required this.totalPages,
    required this.totalEvents,
    required this.hasMoreData,
  });

  @override
  List<Object?> get props => [
    events,
    currentPage,
    totalPages,
    totalEvents,
    hasMoreData,
  ];

  EventsLoaded copyWith({
    List<EventModel>? events,
    int? currentPage,
    int? totalPages,
    int? totalEvents,
    bool? hasMoreData,
  }) {
    return EventsLoaded(
      events: events ?? this.events,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalEvents: totalEvents ?? this.totalEvents,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}

class EventsError extends EventsState {
  final String message;

  const EventsError({required this.message});

  @override
  List<Object?> get props => [message];
}
