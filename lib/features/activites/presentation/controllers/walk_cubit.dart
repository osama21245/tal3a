import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/features/activites/data/repositories/group_repository_impl.dart';
import 'package:tal3a/features/activites/data/repositories/walk_repository_impl.dart';
import '../../data/models/walk_type_model.dart';
import '../../data/models/walk_gender_model.dart';
import '../../data/models/walk_friend_model.dart';
import '../../data/models/walk_time_model.dart';
import '../../data/models/walk_location_model.dart';
import '../../data/models/walk_request_payload.dart';
import '../../data/models/group_type_model.dart';
import '../../data/models/group_location_model.dart';
import '../../data/models/group_time_model.dart';
import '../../data/models/group_tal3a_location_model.dart';
import '../../data/models/group_request_payload.dart';

import '../../data/datasources/walk_remote_datasource.dart';
import '../../data/datasources/group_remote_datasource.dart';
import 'walk_state.dart';

class WalkCubit extends Cubit<WalkState> {
  final WalkRepository _walkRepository;
  final GroupRepository _groupRepository;

  WalkCubit({WalkRepository? walkRepository, GroupRepository? groupRepository})
    : _walkRepository =
          walkRepository ??
          WalkRepositoryImpl(remoteDataSource: WalkRemoteDataSourceImpl()),
      _groupRepository =
          groupRepository ?? GroupRepositoryImpl(GroupRemoteDataSourceImpl()),
      super(WalkState(status: WalkStatus.initial));

  // Navigation History Management
  void addNavigationNode(String screenName, {Map<String, dynamic>? data}) {
    final newNode = WalkNavigationNode(screenName: screenName, data: data);
    final updatedHistory = List<WalkNavigationNode>.from(
      state.navigationHistory,
    )..add(newNode);

    emit(state.copyWith(navigationHistory: updatedHistory));
  }

  void removeLastNavigationNode() {
    if (state.navigationHistory.isNotEmpty) {
      final updatedHistory = List<WalkNavigationNode>.from(
        state.navigationHistory,
      )..removeLast();
      emit(state.copyWith(navigationHistory: updatedHistory));
    }
  }

  void clearNavigationHistory() {
    emit(state.copyWith(navigationHistory: []));
  }

  // Data loading methods
  Future<void> loadWalkTypes() async {
    try {
      emit(state.copyWith(status: WalkStatus.loading));
      final walkTypes = await _walkRepository.getWalkTypes();
      emit(state.copyWith(status: WalkStatus.success, walkTypes: walkTypes));
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  Future<void> loadWalkGenders() async {
    try {
      emit(state.copyWith(status: WalkStatus.loading));
      final walkGenders = await _walkRepository.getWalkGenders();
      emit(
        state.copyWith(status: WalkStatus.success, walkGenders: walkGenders),
      );
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  Future<void> loadWalkFriends({String? gender}) async {
    try {
      emit(state.copyWith(status: WalkStatus.loading));
      final walkFriends = await _walkRepository.getWalkFriends(
        _resolveGender(gender),
      );
      emit(
        state.copyWith(status: WalkStatus.success, walkFriends: walkFriends),
      );
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  void loadWalkLocations() {
    final selectedLocation = state.selectedWalkLocation;
    emit(
      state.copyWith(
        status: WalkStatus.success,
        walkLocations:
            selectedLocation != null
                ? [selectedLocation.copyWith(isSelected: true)]
                : const [],
      ),
    );
  }

  String _resolveGender(String? gender) {
    if (gender != null && gender.isNotEmpty) {
      return _mapGenderValue(gender);
    }

    final selectedGender = state.selectedWalkGender;
    if (selectedGender != null) {
      return _mapGenderValue(selectedGender.id);
    }

    return 'male';
  }

  String _mapGenderValue(String value) {
    final normalizedValue = value.toLowerCase();
    if (normalizedValue.contains('man') || normalizedValue.contains('male')) {
      return 'male';
    }

    if (normalizedValue.contains('woman') ||
        normalizedValue.contains('female') ||
        normalizedValue.contains('women')) {
      return 'female';
    }

    return 'male';
  }

  Future<void> loadWalkTimes() async {
    try {
      emit(state.copyWith(status: WalkStatus.loading));
      final walkTimes = await _walkRepository.getWalkTimes();
      final selectedTimeId = state.selectedWalkTime?.id;
      final times =
          walkTimes
              .map(
                (time) => time.copyWith(
                  isSelected: time.id == selectedTimeId,
                  scheduledAt: time.scheduledAt,
                ),
              )
              .toList();

      emit(state.copyWith(status: WalkStatus.success, walkTimes: times));
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  // Walk-specific methods
  void selectWalkType(WalkTypeModel walkType) {
    emit(
      state.copyWith(
        status: WalkStatus.success,
        selectedWalkType: walkType,
        currentStep: 1,
      ),
    );
  }

  void selectWalkGender(WalkGenderModel walkGender) {
    emit(
      state.copyWith(
        status: WalkStatus.success,
        selectedWalkGender: walkGender,
        currentStep: 2,
      ),
    );
  }

  void selectWalkFriend(WalkFriendModel walkFriend) {
    final updatedFriends =
        state.walkFriends.map((friend) {
          return friend.copyWith(isSelected: friend.id == walkFriend.id);
        }).toList();

    emit(
      state.copyWith(
        status: WalkStatus.success,
        selectedWalkFriend: walkFriend.copyWith(isSelected: true),
        walkFriends: updatedFriends,
        selectedWalkLocation: null,
        walkLocations: const [],
        selectedWalkTime: null,
        currentStep: 3,
      ),
    );
  }

  void selectWalkLocation(WalkLocationModel walkLocation) {
    final updatedLocations = [walkLocation.copyWith(isSelected: true)];

    emit(
      state.copyWith(
        status: WalkStatus.success,
        selectedWalkLocation: walkLocation.copyWith(isSelected: true),
        walkLocations: updatedLocations,
        currentStep: 4,
      ),
    );
  }

  void selectWalkTime(WalkTimeModel walkTime) {
    final updatedTimes =
        state.walkTimes
            .map((time) => time.copyWith(isSelected: time.id == walkTime.id))
            .toList();

    emit(
      state.copyWith(
        status: WalkStatus.success,
        selectedWalkTime: walkTime.copyWith(isSelected: true),
        walkTimes: updatedTimes,
        currentStep: 5,
      ),
    );
  }

  // Get current walk data for display
  WalkTypeModel? getCurrentWalkTypeData() {
    return state.selectedWalkType;
  }

  WalkGenderModel? getCurrentWalkGenderData() {
    return state.selectedWalkGender;
  }

  WalkFriendModel? getCurrentWalkFriendData() {
    return state.selectedWalkFriend;
  }

  WalkTimeModel? getCurrentWalkTimeData() {
    return state.selectedWalkTime;
  }

  // Check if we have all required data for walk steps
  bool hasRequiredWalkDataForStep(int step) {
    switch (step) {
      case 1:
        return state.selectedWalkType != null;
      case 2:
        return state.selectedWalkType != null &&
            state.selectedWalkGender != null;
      case 3:
        return state.selectedWalkType != null &&
            state.selectedWalkGender != null &&
            state.selectedWalkFriend != null;
      case 4:
        return state.selectedWalkType != null &&
            state.selectedWalkGender != null &&
            state.selectedWalkFriend != null &&
            state.selectedWalkLocation != null;
      case 5:
        return state.selectedWalkType != null &&
            state.selectedWalkGender != null &&
            state.selectedWalkFriend != null &&
            state.selectedWalkLocation != null &&
            state.selectedWalkTime != null;
      default:
        return false;
    }
  }

  // Start walk session
  Future<void> sendWalkRequest() async {
    final selectedFriend = state.selectedWalkFriend;
    final selectedLocation = state.selectedWalkLocation;
    final selectedTime = state.selectedWalkTime;

    if (selectedFriend == null ||
        selectedLocation == null ||
        selectedTime == null) {
      emit(
        state.copyWith(
          status: WalkStatus.error,
          error: 'Missing required data to send request.',
        ),
      );
      return;
    }

    final scheduledAt = _resolveScheduledDateTime(selectedTime);
    final payload = WalkRequestPayload(
      requestReceiverId: selectedFriend.id,
      type: _resolveActivityType(),
      scheduledAt: scheduledAt,
      location: WalkRequestLocationPayload(
        type: 'Point',
        coordinates: [selectedLocation.longitude, selectedLocation.latitude],
        locationName: selectedLocation.locationName,
      ),
    );

    emit(state.copyWith(status: WalkStatus.loading));

    try {
      await _walkRepository.sendWalkRequest(payload);
      emit(state.copyWith(status: WalkStatus.success));
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  void pauseWalk() {
    // TODO: Implement walk pause logic
  }

  void stopWalk() {
    // TODO: Implement walk stop logic
  }

  void completeWalk() {
    // TODO: Implement walk completion logic
    emit(state.copyWith(status: WalkStatus.success));
  }

  // Reset state
  void reset() {
    emit(WalkState(status: WalkStatus.initial));
  }

  // Methods to clear only the last selection without affecting others
  void clearWalkFriend() {
    emit(
      WalkState(
        status: WalkStatus.success,
        error: state.error,
        selectedWalkType: state.selectedWalkType,
        selectedWalkGender: state.selectedWalkGender,
        selectedWalkFriend: null, // Clear only friend
        selectedWalkLocation: null,
        selectedWalkTime: state.selectedWalkTime,
        currentStep: 2,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
        walkLocations: state.walkLocations,
        // Group data
        selectedGroupType: state.selectedGroupType,
        selectedGroupLocation: state.selectedGroupLocation,
        selectedGroupTime: state.selectedGroupTime,
        groupTypes: state.groupTypes,
        groupLocations: state.groupLocations,
        groupTimes: state.groupTimes,
      ),
    );
  }

  void clearWalkGender() {
    emit(
      WalkState(
        status: WalkStatus.success,
        error: state.error,
        selectedWalkType: state.selectedWalkType,
        selectedWalkGender: null, // Clear only gender
        selectedWalkFriend: state.selectedWalkFriend,
        selectedWalkLocation: state.selectedWalkLocation,
        selectedWalkTime: state.selectedWalkTime,
        currentStep: 1,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
        walkLocations: state.walkLocations,
        // Group data
        selectedGroupType: state.selectedGroupType,
        selectedGroupLocation: state.selectedGroupLocation,
        selectedGroupTime: state.selectedGroupTime,
        groupTypes: state.groupTypes,
        groupLocations: state.groupLocations,
        groupTimes: state.groupTimes,
      ),
    );
  }

  void clearWalkType() {
    emit(
      WalkState(
        status: WalkStatus.success,
        error: state.error,
        selectedWalkType: null, // Clear only walk type
        selectedWalkGender: state.selectedWalkGender,
        selectedWalkFriend: state.selectedWalkFriend,
        selectedWalkLocation: state.selectedWalkLocation,
        selectedWalkTime: state.selectedWalkTime,
        currentStep: 0,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
        walkLocations: state.walkLocations,
        // Group data
        selectedGroupType: state.selectedGroupType,
        selectedGroupLocation: state.selectedGroupLocation,
        selectedGroupTime: state.selectedGroupTime,
        groupTypes: state.groupTypes,
        groupLocations: state.groupLocations,
        groupTimes: state.groupTimes,
      ),
    );
  }

  void clearWalkTime() {
    emit(
      WalkState(
        status: WalkStatus.success,
        error: state.error,
        selectedWalkType: state.selectedWalkType,
        selectedWalkGender: state.selectedWalkGender,
        selectedWalkFriend: state.selectedWalkFriend,
        selectedWalkLocation: state.selectedWalkLocation,
        selectedWalkTime: null, // Clear only walk time
        currentStep: 3,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
        walkLocations: state.walkLocations,
        // Group data
        selectedGroupType: state.selectedGroupType,
        selectedGroupLocation: state.selectedGroupLocation,
        selectedGroupTime: state.selectedGroupTime,
        groupTypes: state.groupTypes,
        groupLocations: state.groupLocations,
        groupTimes: state.groupTimes,
      ),
    );
  }

  // Static group types data (as requested)
  static const List<GroupTypeModel> _groupTypes = [
    GroupTypeModel(
      id: 'group_ma',
      name: 'Group Ma',
      iconPath: 'assets/icons/group_ma_icon.svg',
      isSelected: false,
    ),
    GroupTypeModel(
      id: 'mix_group',
      name: 'Mix Group',
      iconPath: 'assets/icons/mix_group_icon.svg',
      isSelected: false,
    ),
    GroupTypeModel(
      id: 'group_wo',
      name: 'Group wo',
      iconPath: 'assets/icons/group_wo_icon.svg',
      isSelected: false,
    ),
  ];

  // Group functionality methods
  void loadGroupTypes() {
    emit(state.copyWith(status: WalkStatus.success, groupTypes: _groupTypes));
  }

  void loadGroupLocations() async {
    emit(state.copyWith(status: WalkStatus.loading));

    try {
      final locations = await _groupRepository.getGroupLocations();
      emit(
        state.copyWith(status: WalkStatus.success, groupLocations: locations),
      );
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  // Load group tal3a locations from API
  Future<void> loadGroupTal3aLocations(String tal3aType) async {
    emit(state.copyWith(status: WalkStatus.loading));

    try {
      final locations = await _groupRepository.getGroupTal3aLocations(tal3aType);
      emit(
        state.copyWith(
          status: WalkStatus.success,
          groupTal3aLocations: locations,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  // Select group tal3a location
  void selectGroupTal3aLocation(GroupTal3aLocationModel location) {
    final updatedLocations = state.groupTal3aLocations.map((loc) {
      return loc.locationName == location.locationName
          ? loc.copyWith(isSelected: true)
          : loc.copyWith(isSelected: false);
    }).toList();

    emit(
      state.copyWith(
        status: WalkStatus.success,
        groupTal3aLocations: updatedLocations,
      ),
    );
  }

  // Get group tal3a details by location name
  Future<void> loadGroupTal3aByLocation(String locationName) async {
    emit(state.copyWith(status: WalkStatus.loading));

    try {
      final details = await _groupRepository.getGroupTal3aByLocation(locationName);
      if (details.isNotEmpty) {
        // Use the first detail (or you can let user select if multiple)
        emit(
          state.copyWith(
            status: WalkStatus.success,
            selectedGroupTal3aDetail: details.first,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: WalkStatus.error,
            error: 'No group tal3a found for this location',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  // Send group request
  Future<void> sendGroupRequest({
    required String groupType, // "group_mix", "group_man", "group_woman"
    required String date, // Format: "2025-11-01"
    required String time, // Format: "06:00" (from timeslot startTime)
  }) async {
    final selectedDetail = state.selectedGroupTal3aDetail;
    if (selectedDetail == null) {
      emit(
        state.copyWith(
          status: WalkStatus.error,
          error: 'No group tal3a selected',
        ),
      );
      return;
    }

    emit(state.copyWith(status: WalkStatus.loading));

    try {
      final payload = GroupRequestPayload(
        groupTal3a: selectedDetail.id,
        groupType: groupType,
        location: GroupRequestLocationPayload(
          type: selectedDetail.location.type,
          coordinates: selectedDetail.location.coordinates,
          locationName: selectedDetail.locationName,
        ),
        date: date,
        time: time,
      );

      await _groupRepository.createGroupRequest(payload);
      emit(state.copyWith(status: WalkStatus.success));
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  void loadGroupTimes() async {
    emit(state.copyWith(status: WalkStatus.loading));

    try {
      final times = await _groupRepository.getGroupTimes();
      emit(state.copyWith(status: WalkStatus.success, groupTimes: times));
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  void selectGroupType(GroupTypeModel groupType) {
    final updatedGroupTypes =
        state.groupTypes.map((type) {
          return type.id == groupType.id
              ? type.copyWith(isSelected: true)
              : type.copyWith(isSelected: false);
        }).toList();

    emit(
      state.copyWith(
        selectedGroupType: groupType.copyWith(isSelected: true),
        groupTypes: updatedGroupTypes,
        currentStep: 1,
        navigationHistory: [
          ...state.navigationHistory,
          WalkNavigationNode(
            screenName: 'group_type_selection',
            data: {'groupType': groupType.name},
          ),
        ],
      ),
    );
  }

  void selectGroupLocation(GroupLocationModel groupLocation) {
    final updatedGroupLocations =
        state.groupLocations.map((location) {
          return location.id == groupLocation.id
              ? location.copyWith(isSelected: true)
              : location.copyWith(isSelected: false);
        }).toList();

    emit(
      state.copyWith(
        selectedGroupLocation: groupLocation.copyWith(isSelected: true),
        groupLocations: updatedGroupLocations,
        currentStep: 2,
        navigationHistory: [
          ...state.navigationHistory,
          WalkNavigationNode(
            screenName: 'group_location_selection',
            data: {'groupLocation': groupLocation.name},
          ),
        ],
      ),
    );
  }

  void selectGroupTime(GroupTimeModel groupTime) {
    final updatedGroupTimes =
        state.groupTimes.map((time) {
          return time.id == groupTime.id
              ? time.copyWith(isSelected: true)
              : time.copyWith(isSelected: false);
        }).toList();

    emit(
      state.copyWith(
        selectedGroupTime: groupTime.copyWith(isSelected: true),
        groupTimes: updatedGroupTimes,
        currentStep: 3,
        navigationHistory: [
          ...state.navigationHistory,
          WalkNavigationNode(
            screenName: 'group_time_selection',
            data: {'groupTime': groupTime.timeSlot},
          ),
        ],
      ),
    );
  }

  // Group clear methods for back button functionality
  void clearGroupLocation() {
    emit(
      state.copyWith(
        selectedGroupLocation: null, // Clear only location
        selectedGroupTal3aDetail: null, // Clear group tal3a detail
        currentStep: 1,
      ),
    );
  }

  void clearGroupType() {
    emit(
      WalkState(
        status: WalkStatus.success,
        error: state.error,
        selectedWalkType: state.selectedWalkType,
        selectedWalkGender: state.selectedWalkGender,
        selectedWalkFriend: state.selectedWalkFriend,
        selectedWalkTime: state.selectedWalkTime,
        selectedWalkLocation: state.selectedWalkLocation,
        currentStep: 0,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
        walkLocations: state.walkLocations,
        // Group data
        selectedGroupType: null, // Clear only group type
        selectedGroupLocation: state.selectedGroupLocation,
        selectedGroupTime: state.selectedGroupTime,
        groupTypes: state.groupTypes,
        groupLocations: state.groupLocations,
        groupTimes: state.groupTimes,
      ),
    );
  }

  void clearGroupTime() {
    emit(
      WalkState(
        status: WalkStatus.success,
        error: state.error,
        selectedWalkType: state.selectedWalkType,
        selectedWalkGender: state.selectedWalkGender,
        selectedWalkFriend: state.selectedWalkFriend,
        selectedWalkTime: state.selectedWalkTime,
        selectedWalkLocation: state.selectedWalkLocation,
        currentStep: 2,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
        walkLocations: state.walkLocations,
        // Group data
        selectedGroupType: state.selectedGroupType,
        selectedGroupLocation: state.selectedGroupLocation,
        selectedGroupTime: null, // Clear only group time
        groupTypes: state.groupTypes,
        groupLocations: state.groupLocations,
        groupTimes: state.groupTimes,
      ),
    );
  }

  // Check if required group data is available
  bool hasRequiredGroupType() => state.selectedGroupType != null;
  bool hasRequiredGroupLocation() => state.selectedGroupLocation != null;
  bool hasRequiredGroupTime() => state.selectedGroupTime != null;

  DateTime _resolveScheduledDateTime(WalkTimeModel walkTime) {
    if (walkTime.scheduledAt != null) {
      return walkTime.scheduledAt!;
    }

    final match = RegExp(
      r'(\d{1,2}):(\d{2})\s*(AM|PM)',
      caseSensitive: false,
    ).firstMatch(walkTime.timeSlot);

    if (match != null) {
      final hour = int.tryParse(match.group(1)!);
      final minute = int.tryParse(match.group(2)!);
      final period = match.group(3)!.toUpperCase();

      if (hour != null && minute != null) {
        var resolvedHour = hour % 12;
        if (period == 'PM') {
          resolvedHour += 12;
        }

        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, resolvedHour, minute);
      }
    }

    return DateTime.now().add(const Duration(hours: 1));
  }

  String _resolveActivityType() {
    return 'walking';
  }
}
