// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../data/models/walk_type_model.dart';
import '../../data/models/walk_gender_model.dart';
import '../../data/models/walk_friend_model.dart';
import '../../data/models/walk_time_model.dart';

enum Tal3aTypeStatus { initial, loading, success, error }

extension Tal3aTypeStateExtension on Tal3aTypeState {
  bool get isInitial => status == Tal3aTypeStatus.initial;
  bool get isLoading => status == Tal3aTypeStatus.loading;
  bool get isSuccess => status == Tal3aTypeStatus.success;
  bool get isError => status == Tal3aTypeStatus.error;
}

class Tal3aTypeData {
  final String id;
  final String name;
  final String? iconPath;
  final String? imagePath;
  final Map<String, dynamic>? additionalData;

  Tal3aTypeData({
    required this.id,
    required this.name,
    this.iconPath,
    this.imagePath,
    this.additionalData,
  });

  Tal3aTypeData copyWith({
    String? id,
    String? name,
    String? iconPath,
    String? imagePath,
    Map<String, dynamic>? additionalData,
  }) {
    return Tal3aTypeData(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      imagePath: imagePath ?? this.imagePath,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}

class CoachData {
  final String id;
  final String name;
  final String title;
  final double rating;
  final String? imageUrl;
  final Map<String, dynamic>? additionalData;

  CoachData({
    required this.id,
    required this.name,
    required this.title,
    required this.rating,
    this.imageUrl,
    this.additionalData,
  });

  CoachData copyWith({
    String? id,
    String? name,
    String? title,
    double? rating,
    String? imageUrl,
    Map<String, dynamic>? additionalData,
  }) {
    return CoachData(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}

// Navigation node for tracking the flow
class NavigationNode {
  final String screenName;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  NavigationNode({required this.screenName, this.data, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  NavigationNode copyWith({
    String? screenName,
    Map<String, dynamic>? data,
    DateTime? timestamp,
  }) {
    return NavigationNode(
      screenName: screenName ?? this.screenName,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class Tal3aTypeState {
  final Tal3aTypeStatus status;
  final String? error;
  final Tal3aTypeData? selectedTal3aType;
  final CoachData? selectedCoach;
  final String? selectedMode;
  final int currentStep;
  final List<NavigationNode> navigationHistory;

  // Walk-specific data
  final WalkTypeModel? selectedWalkType;
  final WalkGenderModel? selectedWalkGender;
  final WalkFriendModel? selectedWalkFriend;
  final WalkTimeModel? selectedWalkTime;

  Tal3aTypeState({
    required this.status,
    this.error,
    this.selectedTal3aType,
    this.selectedCoach,
    this.selectedMode,
    this.currentStep = 0,
    this.navigationHistory = const [],
    this.selectedWalkType,
    this.selectedWalkGender,
    this.selectedWalkFriend,
    this.selectedWalkTime,
  });

  Tal3aTypeState copyWith({
    Tal3aTypeStatus? status,
    String? error,
    Tal3aTypeData? selectedTal3aType,
    CoachData? selectedCoach,
    String? selectedMode,
    int? currentStep,
    List<NavigationNode>? navigationHistory,
    WalkTypeModel? selectedWalkType,
    WalkGenderModel? selectedWalkGender,
    WalkFriendModel? selectedWalkFriend,
    WalkTimeModel? selectedWalkTime,
  }) {
    return Tal3aTypeState(
      status: status ?? this.status,
      error: error ?? this.error,
      selectedTal3aType: selectedTal3aType ?? this.selectedTal3aType,
      selectedCoach: selectedCoach ?? this.selectedCoach,
      selectedMode: selectedMode ?? this.selectedMode,
      currentStep: currentStep ?? this.currentStep,
      navigationHistory: navigationHistory ?? this.navigationHistory,
      selectedWalkType: selectedWalkType ?? this.selectedWalkType,
      selectedWalkGender: selectedWalkGender ?? this.selectedWalkGender,
      selectedWalkFriend: selectedWalkFriend ?? this.selectedWalkFriend,
      selectedWalkTime: selectedWalkTime ?? this.selectedWalkTime,
    );
  }

  // Helper methods for navigation history
  bool get canGoBack => navigationHistory.isNotEmpty;
  NavigationNode? get lastNode =>
      navigationHistory.isNotEmpty ? navigationHistory.last : null;
  List<String> get nodeNames =>
      navigationHistory.map((node) => node.screenName).toList();

  @override
  String toString() =>
      'Tal3aTypeState(status: $status, error: $error, selectedTal3aType: $selectedTal3aType, selectedCoach: $selectedCoach, selectedMode: $selectedMode, currentStep: $currentStep, navigationHistory: ${nodeNames}, selectedWalkType: $selectedWalkType, selectedWalkGender: $selectedWalkGender, selectedWalkFriend: $selectedWalkFriend, selectedWalkTime: $selectedWalkTime)';
}
