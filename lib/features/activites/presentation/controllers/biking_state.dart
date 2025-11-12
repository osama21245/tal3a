import '../../data/models/biking_type_model.dart';
import '../../data/models/biking_gender_model.dart';
import '../../data/models/biking_friend_model.dart';
import '../../data/models/biking_time_model.dart';
import '../../data/models/biking_group_type_model.dart';
import '../../data/models/biking_group_location_model.dart';
import '../../data/models/biking_group_time_model.dart';

class BikingState {
  final BikingTypeModel? selectedBikingType;
  final BikingGenderModel? selectedBikingGender;
  final BikingFriendModel? selectedBikingFriend;
  final BikingTimeModel? selectedBikingTime;
  final BikingGroupTypeModel? selectedBikingGroupType;
  final BikingGroupLocationModel? selectedBikingGroupLocation;
  final BikingGroupTimeModel? selectedBikingGroupTime;
  final List<Map<String, dynamic>> navigationHistory;
  final bool isLoading;
  final String? error;

  const BikingState({
    this.selectedBikingType,
    this.selectedBikingGender,
    this.selectedBikingFriend,
    this.selectedBikingTime,
    this.selectedBikingGroupType,
    this.selectedBikingGroupLocation,
    this.selectedBikingGroupTime,
    this.navigationHistory = const [],
    this.isLoading = false,
    this.error,
  });

  BikingState copyWith({
    BikingTypeModel? selectedBikingType,
    BikingGenderModel? selectedBikingGender,
    BikingFriendModel? selectedBikingFriend,
    BikingTimeModel? selectedBikingTime,
    BikingGroupTypeModel? selectedBikingGroupType,
    BikingGroupLocationModel? selectedBikingGroupLocation,
    BikingGroupTimeModel? selectedBikingGroupTime,
    List<Map<String, dynamic>>? navigationHistory,
    bool? isLoading,
    String? error,
    bool clearSelectedBikingType = false,
    bool clearSelectedBikingGender = false,
    bool clearSelectedBikingFriend = false,
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
      navigationHistory: navigationHistory ?? this.navigationHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BikingState &&
        other.selectedBikingType == selectedBikingType &&
        other.selectedBikingGender == selectedBikingGender &&
        other.selectedBikingFriend == selectedBikingFriend &&
        other.selectedBikingTime == selectedBikingTime &&
        other.selectedBikingGroupType == selectedBikingGroupType &&
        other.selectedBikingGroupLocation == selectedBikingGroupLocation &&
        other.selectedBikingGroupTime == selectedBikingGroupTime &&
        other.navigationHistory == navigationHistory &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode =>
      selectedBikingType.hashCode ^
      selectedBikingGender.hashCode ^
      selectedBikingFriend.hashCode ^
      selectedBikingTime.hashCode ^
      selectedBikingGroupType.hashCode ^
      selectedBikingGroupLocation.hashCode ^
      selectedBikingGroupTime.hashCode ^
      navigationHistory.hashCode ^
      isLoading.hashCode ^
      error.hashCode;
}
