import '../../data/models/biking_type_model.dart';
import '../../data/models/biking_gender_model.dart';
import '../../data/models/biking_friend_model.dart';
import '../../data/models/biking_time_model.dart';
import '../../data/models/biking_location_model.dart';
import '../../data/models/biking_group_type_model.dart';
import '../../data/models/biking_group_location_model.dart';
import '../../data/models/biking_group_time_model.dart';
import '../../data/models/group_tal3a_location_model.dart';
import '../../data/models/group_tal3a_detail_model.dart';

class BikingState {
  final BikingTypeModel? selectedBikingType;
  final BikingGenderModel? selectedBikingGender;
  final BikingFriendModel? selectedBikingFriend;
  final BikingLocationModel? selectedBikingLocation;
  final BikingTimeModel? selectedBikingTime;
  final BikingGroupTypeModel? selectedBikingGroupType;
  final BikingGroupLocationModel? selectedBikingGroupLocation;
  final BikingGroupTimeModel? selectedBikingGroupTime;
  final List<BikingFriendModel> bikingFriends;
  final List<Map<String, dynamic>> navigationHistory;
  final bool isLoading;
  final String? error;
  // Group tal3a data (from API)
  final List<GroupTal3aLocationModel> groupTal3aLocations;
  final GroupTal3aDetailModel? selectedGroupTal3aDetail;

  const BikingState({
    this.selectedBikingType,
    this.selectedBikingGender,
    this.selectedBikingFriend,
    this.selectedBikingLocation,
    this.selectedBikingTime,
    this.selectedBikingGroupType,
    this.selectedBikingGroupLocation,
    this.selectedBikingGroupTime,
    this.bikingFriends = const [],
    this.navigationHistory = const [],
    this.isLoading = false,
    this.error,
    this.groupTal3aLocations = const [],
    this.selectedGroupTal3aDetail,
  });

  BikingState copyWith({
    BikingTypeModel? selectedBikingType,
    BikingGenderModel? selectedBikingGender,
    BikingFriendModel? selectedBikingFriend,
    BikingLocationModel? selectedBikingLocation,
    BikingTimeModel? selectedBikingTime,
    BikingGroupTypeModel? selectedBikingGroupType,
    BikingGroupLocationModel? selectedBikingGroupLocation,
    BikingGroupTimeModel? selectedBikingGroupTime,
    List<BikingFriendModel>? bikingFriends,
    List<Map<String, dynamic>>? navigationHistory,
    bool? isLoading,
    String? error,
    List<GroupTal3aLocationModel>? groupTal3aLocations,
    GroupTal3aDetailModel? selectedGroupTal3aDetail,
    bool clearSelectedBikingType = false,
    bool clearSelectedBikingGender = false,
    bool clearSelectedBikingFriend = false,
    bool clearSelectedBikingLocation = false,
    bool clearSelectedBikingTime = false,
    bool clearSelectedBikingGroupType = false,
    bool clearSelectedBikingGroupLocation = false,
    bool clearSelectedBikingGroupTime = false,
  }) {
    return BikingState(
      selectedBikingType:
          clearSelectedBikingType
              ? null
              : (selectedBikingType ?? this.selectedBikingType),
      selectedBikingGender:
          clearSelectedBikingGender
              ? null
              : (selectedBikingGender ?? this.selectedBikingGender),
      selectedBikingFriend:
          clearSelectedBikingFriend
              ? null
              : (selectedBikingFriend ?? this.selectedBikingFriend),
      selectedBikingLocation:
          clearSelectedBikingLocation
              ? null
              : (selectedBikingLocation ?? this.selectedBikingLocation),
      selectedBikingTime:
          clearSelectedBikingTime
              ? null
              : (selectedBikingTime ?? this.selectedBikingTime),
      selectedBikingGroupType:
          clearSelectedBikingGroupType
              ? null
              : (selectedBikingGroupType ?? this.selectedBikingGroupType),
      selectedBikingGroupLocation:
          clearSelectedBikingGroupLocation
              ? null
              : (selectedBikingGroupLocation ??
                  this.selectedBikingGroupLocation),
      selectedBikingGroupTime:
          clearSelectedBikingGroupTime
              ? null
              : (selectedBikingGroupTime ?? this.selectedBikingGroupTime),
      bikingFriends: bikingFriends ?? this.bikingFriends,
      navigationHistory: navigationHistory ?? this.navigationHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      groupTal3aLocations: groupTal3aLocations ?? this.groupTal3aLocations,
      selectedGroupTal3aDetail:
          selectedGroupTal3aDetail ?? this.selectedGroupTal3aDetail,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingState &&
        other.selectedBikingType == selectedBikingType &&
        other.selectedBikingGender == selectedBikingGender &&
        other.selectedBikingFriend == selectedBikingFriend &&
        other.selectedBikingLocation == selectedBikingLocation &&
        other.selectedBikingTime == selectedBikingTime &&
        other.selectedBikingGroupType == selectedBikingGroupType &&
        other.selectedBikingGroupLocation == selectedBikingGroupLocation &&
        other.selectedBikingGroupTime == selectedBikingGroupTime &&
        other.bikingFriends == bikingFriends &&
        other.navigationHistory == navigationHistory &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode =>
      selectedBikingType.hashCode ^
      selectedBikingGender.hashCode ^
      selectedBikingFriend.hashCode ^
      selectedBikingLocation.hashCode ^
      selectedBikingTime.hashCode ^
      selectedBikingGroupType.hashCode ^
      selectedBikingGroupLocation.hashCode ^
      selectedBikingGroupTime.hashCode ^
      bikingFriends.hashCode ^
      navigationHistory.hashCode ^
      isLoading.hashCode ^
      error.hashCode;
}
