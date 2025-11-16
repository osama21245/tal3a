import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/biking_type_model.dart';
import '../../data/models/biking_gender_model.dart';
import '../../data/models/biking_friend_model.dart';
import '../../data/models/biking_time_model.dart';
import '../../data/models/biking_location_model.dart';
import '../../data/models/biking_group_type_model.dart';
import '../../data/models/biking_group_location_model.dart';
import '../../data/models/biking_group_time_model.dart';
import '../../data/models/group_tal3a_location_model.dart';
import '../../data/repositories/walk_repository_impl.dart';
import '../../data/repositories/group_repository_impl.dart';
import '../../data/datasources/walk_remote_datasource.dart';
import '../../data/datasources/group_remote_datasource.dart';
import '../../data/models/walk_request_payload.dart';
import '../../data/models/group_request_payload.dart';
import 'biking_state.dart';

class BikingCubit extends Cubit<BikingState> {
  final WalkRepository _walkRepository;
  final GroupRepository _groupRepository;

  BikingCubit({
    WalkRepository? walkRepository,
    GroupRepository? groupRepository,
  })
      : _walkRepository = walkRepository ??
            WalkRepositoryImpl(remoteDataSource: WalkRemoteDataSourceImpl()),
        _groupRepository = groupRepository ??
            GroupRepositoryImpl(GroupRemoteDataSourceImpl()),
        super(const BikingState());

  // Biking Type Methods
  void selectBikingType(BikingTypeModel bikingType) {
    emit(state.copyWith(selectedBikingType: bikingType, error: null));
  }

  void clearBikingType() {
    emit(
      state.copyWith(
        clearSelectedBikingType: true,
        clearSelectedBikingGender: true,
        clearSelectedBikingFriend: true,
        clearSelectedBikingTime: true,
        error: null,
      ),
    );
  }

  // Biking Gender Methods
  void selectBikingGender(BikingGenderModel bikingGender) {
    emit(state.copyWith(selectedBikingGender: bikingGender, error: null));
  }

  void clearBikingGender() {
    emit(
      state.copyWith(
        clearSelectedBikingGender: true,
        clearSelectedBikingFriend: true,
        clearSelectedBikingTime: true,
        error: null,
      ),
    );
  }

  // Biking Friend Methods
  void selectBikingFriend(BikingFriendModel bikingFriend) {
    final updatedFriends = state.bikingFriends.map((friend) {
      return friend.id == bikingFriend.id ? bikingFriend : friend;
    }).toList();
    emit(state.copyWith(
      selectedBikingFriend: bikingFriend,
      bikingFriends: updatedFriends,
      error: null,
    ));
  }

  void clearBikingFriend() {
    emit(
      state.copyWith(
        clearSelectedBikingFriend: true,
        clearSelectedBikingLocation: true,
        clearSelectedBikingTime: true,
        error: null,
      ),
    );
  }

  // Biking Location Methods
  void selectBikingLocation(BikingLocationModel bikingLocation) {
    emit(state.copyWith(selectedBikingLocation: bikingLocation, error: null));
  }

  void clearBikingLocation() {
    emit(
      state.copyWith(
        clearSelectedBikingLocation: true,
        clearSelectedBikingTime: true,
        error: null,
      ),
    );
  }

  // Biking Time Methods
  void selectBikingTime(BikingTimeModel bikingTime) {
    emit(state.copyWith(selectedBikingTime: bikingTime, error: null));
  }

  void clearBikingTime() {
    emit(state.copyWith(clearSelectedBikingTime: true, error: null));
  }

  // Biking Group Type Methods
  void selectBikingGroupType(BikingGroupTypeModel bikingGroupType) {
    emit(state.copyWith(selectedBikingGroupType: bikingGroupType, error: null));
  }

  void clearBikingGroupType() {
    emit(
      state.copyWith(
        clearSelectedBikingGroupType: true,
        clearSelectedBikingGroupLocation: true,
        clearSelectedBikingGroupTime: true,
        error: null,
      ),
    );
  }

  // Biking Group Location Methods
  void selectBikingGroupLocation(BikingGroupLocationModel bikingGroupLocation) {
    emit(
      state.copyWith(
        selectedBikingGroupLocation: bikingGroupLocation,
        error: null,
      ),
    );
  }

  void clearBikingGroupLocation() {
    emit(
      state.copyWith(
        clearSelectedBikingGroupLocation: true,
        clearSelectedBikingGroupTime: true,
        error: null,
      ),
    );
  }

  // Biking Group Time Methods
  void selectBikingGroupTime(BikingGroupTimeModel bikingGroupTime) {
    emit(state.copyWith(selectedBikingGroupTime: bikingGroupTime, error: null));
  }

  void clearBikingGroupTime() {
    emit(state.copyWith(clearSelectedBikingGroupTime: true, error: null));
  }

  // Load group tal3a locations from API
  Future<void> loadGroupTal3aLocations(String tal3aType) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final locations = await _groupRepository.getGroupTal3aLocations(tal3aType);
      emit(
        state.copyWith(
          isLoading: false,
          groupTal3aLocations: locations,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
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
        isLoading: false,
        groupTal3aLocations: updatedLocations,
      ),
    );
  }

  // Get group tal3a details by location name
  Future<void> loadGroupTal3aByLocation(String locationName) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final details = await _groupRepository.getGroupTal3aByLocation(locationName);
      if (details.isNotEmpty) {
        // Use the first detail (or you can let user select if multiple)
        emit(
          state.copyWith(
            isLoading: false,
            selectedGroupTal3aDetail: details.first,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'No group tal3a found for this location',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
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
          isLoading: false,
          error: 'No group tal3a selected',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

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
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // Navigation History Methods
  void addNavigationNode(String screenName, {Map<String, dynamic>? data}) {
    final navigationHistory = List<Map<String, dynamic>>.from(
      state.navigationHistory,
    );
    navigationHistory.add({
      'screenName': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    });
    emit(state.copyWith(navigationHistory: navigationHistory));
  }

  void removeLastNavigationNode() {
    if (state.navigationHistory.isNotEmpty) {
      final navigationHistory = List<Map<String, dynamic>>.from(
        state.navigationHistory,
      );
      navigationHistory.removeLast();
      emit(state.copyWith(navigationHistory: navigationHistory));
    }
  }

  void clearNavigationHistory() {
    emit(state.copyWith(navigationHistory: []));
  }

  // Reset all selections
  void resetAll() {
    emit(const BikingState());
  }

  // Set loading state
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  // Set error
  void setError(String error) {
    emit(state.copyWith(error: error, isLoading: false));
  }

  // Clear error
  void clearError() {
    emit(state.copyWith(error: null));
  }

  // Data loading methods
  Future<void> loadBikingGenders() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _walkRepository.getWalkGenders();
      // Note: Gender data is loaded but not stored in state as it's static
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadBikingFriends({String? gender}) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final resolvedGender = _resolveGender(gender);
      final walkFriends = await _walkRepository.getWalkFriends(resolvedGender);
      // Convert WalkFriendModel to BikingFriendModel
      final bikingFriends = walkFriends.map((walkFriend) {
        return BikingFriendModel(
          id: walkFriend.id,
          name: walkFriend.name,
          age: int.tryParse(walkFriend.age) ?? 0,
          weight: int.tryParse(walkFriend.weight) ?? 0,
          imageUrl: walkFriend.imageUrl,
        );
      }).toList();
      emit(state.copyWith(isLoading: false, bikingFriends: bikingFriends));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  String _resolveGender(String? gender) {
    if (gender != null && gender.isNotEmpty) {
      return _mapGenderValue(gender);
    }

    final selectedGender = state.selectedBikingGender;
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

  // Send biking request
  Future<void> sendBikingRequest() async {
    final selectedFriend = state.selectedBikingFriend;
    final selectedLocation = state.selectedBikingLocation;
    final selectedTime = state.selectedBikingTime;

    if (selectedFriend == null ||
        selectedLocation == null ||
        selectedTime == null) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Missing required data to send request.',
        ),
      );
      return;
    }

    final scheduledAt = _resolveScheduledDateTime(selectedTime);
    final payload = WalkRequestPayload(
      requestReceiverId: selectedFriend.id,
      type: 'biking', // Set type to "biking" instead of "walking"
      scheduledAt: scheduledAt,
      location: WalkRequestLocationPayload(
        type: 'Point',
        coordinates: [selectedLocation.longitude, selectedLocation.latitude],
        locationName: selectedLocation.locationName,
      ),
    );

    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _walkRepository.sendWalkRequest(payload);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  DateTime _resolveScheduledDateTime(BikingTimeModel bikingTime) {
    // Use scheduledAt if available
    if (bikingTime.scheduledAt != null) {
      return bikingTime.scheduledAt!;
    }

    // Parse timeSlot (e.g., "6:00 AM" or "6:00 PM")
    final match = RegExp(
      r'(\d{1,2}):(\d{2})\s*(AM|PM)',
      caseSensitive: false,
    ).firstMatch(bikingTime.timeSlot);

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

    // Default to 1 hour from now if parsing fails
    return DateTime.now().add(const Duration(hours: 1));
  }
}
