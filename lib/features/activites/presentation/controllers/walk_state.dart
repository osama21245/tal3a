// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../data/models/walk_type_model.dart';
import '../../data/models/walk_gender_model.dart';
import '../../data/models/walk_friend_model.dart';
import '../../data/models/walk_time_model.dart';
import '../../data/models/walk_location_model.dart';
import '../../data/models/group_type_model.dart';
import '../../data/models/group_location_model.dart';
import '../../data/models/group_time_model.dart';
import '../../data/models/group_tal3a_location_model.dart';
import '../../data/models/group_tal3a_detail_model.dart';

enum WalkStatus { initial, loading, success, error }

extension WalkStateExtension on WalkState {
  bool get isInitial => status == WalkStatus.initial;
  bool get isLoading => status == WalkStatus.loading;
  bool get isSuccess => status == WalkStatus.success;
  bool get isError => status == WalkStatus.error;
}

// Navigation node for tracking the walk flow
class WalkNavigationNode {
  final String screenName;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  WalkNavigationNode({required this.screenName, this.data, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  WalkNavigationNode copyWith({
    String? screenName,
    Map<String, dynamic>? data,
    DateTime? timestamp,
  }) {
    return WalkNavigationNode(
      screenName: screenName ?? this.screenName,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class WalkState {
  final WalkStatus status;
  final String? error;
  final WalkTypeModel? selectedWalkType;
  final WalkGenderModel? selectedWalkGender;
  final WalkFriendModel? selectedWalkFriend;
  final WalkTimeModel? selectedWalkTime;
  final WalkLocationModel? selectedWalkLocation;
  final int currentStep;
  final List<WalkNavigationNode> navigationHistory;

  // Walk data lists
  final List<WalkTypeModel> walkTypes;
  final List<WalkGenderModel> walkGenders;
  final List<WalkFriendModel> walkFriends;
  final List<WalkTimeModel> walkTimes;
  final List<WalkLocationModel> walkLocations;

  // Group data (when user selects "Group" walk type)
  final GroupTypeModel? selectedGroupType;
  final GroupLocationModel? selectedGroupLocation;
  final GroupTimeModel? selectedGroupTime;
  final List<GroupTypeModel> groupTypes;
  final List<GroupLocationModel> groupLocations;
  final List<GroupTimeModel> groupTimes;
  // Group tal3a data (from API)
  final List<GroupTal3aLocationModel> groupTal3aLocations;
  final GroupTal3aDetailModel? selectedGroupTal3aDetail;

  WalkState({
    required this.status,
    this.error,
    this.selectedWalkType,
    this.selectedWalkGender,
    this.selectedWalkFriend,
    this.selectedWalkTime,
    this.selectedWalkLocation,
    this.currentStep = 0,
    this.navigationHistory = const [],
    this.walkTypes = const [],
    this.walkGenders = const [],
    this.walkFriends = const [],
    this.walkTimes = const [],
    this.walkLocations = const [],
    // Group data
    this.selectedGroupType,
    this.selectedGroupLocation,
    this.selectedGroupTime,
    this.groupTypes = const [],
    this.groupLocations = const [],
    this.groupTimes = const [],
    this.groupTal3aLocations = const [],
    this.selectedGroupTal3aDetail,
  });

  WalkState copyWith({
    WalkStatus? status,
    String? error,
    WalkTypeModel? selectedWalkType,
    WalkGenderModel? selectedWalkGender,
    WalkFriendModel? selectedWalkFriend,
    WalkTimeModel? selectedWalkTime,
    WalkLocationModel? selectedWalkLocation,
    int? currentStep,
    List<WalkNavigationNode>? navigationHistory,
    List<WalkTypeModel>? walkTypes,
    List<WalkGenderModel>? walkGenders,
    List<WalkFriendModel>? walkFriends,
    List<WalkTimeModel>? walkTimes,
    List<WalkLocationModel>? walkLocations,
    // Group data
    GroupTypeModel? selectedGroupType,
    GroupLocationModel? selectedGroupLocation,
    GroupTimeModel? selectedGroupTime,
    List<GroupTypeModel>? groupTypes,
    List<GroupLocationModel>? groupLocations,
    List<GroupTimeModel>? groupTimes,
    List<GroupTal3aLocationModel>? groupTal3aLocations,
    GroupTal3aDetailModel? selectedGroupTal3aDetail,
  }) {
    return WalkState(
      status: status ?? this.status,
      error: error ?? this.error,
      selectedWalkType: selectedWalkType ?? this.selectedWalkType,
      selectedWalkGender: selectedWalkGender ?? this.selectedWalkGender,
      selectedWalkFriend: selectedWalkFriend ?? this.selectedWalkFriend,
      selectedWalkTime: selectedWalkTime ?? this.selectedWalkTime,
      selectedWalkLocation: selectedWalkLocation ?? this.selectedWalkLocation,
      currentStep: currentStep ?? this.currentStep,
      navigationHistory: navigationHistory ?? this.navigationHistory,
      walkTypes: walkTypes ?? this.walkTypes,
      walkGenders: walkGenders ?? this.walkGenders,
      walkFriends: walkFriends ?? this.walkFriends,
      walkTimes: walkTimes ?? this.walkTimes,
      walkLocations: walkLocations ?? this.walkLocations,
      // Group data
      selectedGroupType: selectedGroupType ?? this.selectedGroupType,
      selectedGroupLocation:
          selectedGroupLocation ?? this.selectedGroupLocation,
      selectedGroupTime: selectedGroupTime ?? this.selectedGroupTime,
      groupTypes: groupTypes ?? this.groupTypes,
      groupLocations: groupLocations ?? this.groupLocations,
      groupTimes: groupTimes ?? this.groupTimes,
      groupTal3aLocations: groupTal3aLocations ?? this.groupTal3aLocations,
      selectedGroupTal3aDetail:
          selectedGroupTal3aDetail ?? this.selectedGroupTal3aDetail,
    );
  }

  // Helper methods for navigation history
  bool get canGoBack => navigationHistory.isNotEmpty;
  WalkNavigationNode? get lastNode =>
      navigationHistory.isNotEmpty ? navigationHistory.last : null;
  List<String> get nodeNames =>
      navigationHistory.map((node) => node.screenName).toList();

  @override
  String toString() =>
      'WalkState(status: $status, error: $error, selectedWalkType: $selectedWalkType, selectedWalkGender: $selectedWalkGender, selectedWalkFriend: $selectedWalkFriend, selectedWalkLocation: $selectedWalkLocation, selectedWalkTime: $selectedWalkTime, currentStep: $currentStep, navigationHistory: ${nodeNames})';
}
