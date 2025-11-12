import 'package:equatable/equatable.dart';
import '../../data/models/event_details_model.dart';

abstract class EventDetailsState extends Equatable {
  const EventDetailsState();

  @override
  List<Object?> get props => [];
}

class EventDetailsInitial extends EventDetailsState {}

class EventDetailsLoading extends EventDetailsState {}

class EventDetailsLoaded extends EventDetailsState {
  final EventDetailsModel eventDetails;

  const EventDetailsLoaded({required this.eventDetails});

  @override
  List<Object?> get props => [eventDetails];
}

class EventDetailsError extends EventDetailsState {
  final String message;

  const EventDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
