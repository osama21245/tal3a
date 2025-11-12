import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/features/activites/data/repositories/group_repository_impl.dart';
import 'package:tal3a/features/activites/data/repositories/walk_repository_impl.dart';
import '../../data/models/walk_type_model.dart';
import '../../data/models/walk_gender_model.dart';
import '../../data/models/walk_friend_model.dart';
import '../../data/models/walk_time_model.dart';
import '../../data/models/group_type_model.dart';
import '../../data/models/group_location_model.dart';
import '../../data/models/group_time_model.dart';

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

  Future<void> loadWalkFriends() async {
    try {
      emit(state.copyWith(status: WalkStatus.loading));
      final walkFriends = await _walkRepository.getWalkFriends();
      emit(
        state.copyWith(status: WalkStatus.success, walkFriends: walkFriends),
      );
    } catch (e) {
      emit(state.copyWith(status: WalkStatus.error, error: e.toString()));
    }
  }

  Future<void> loadWalkTimes() async {
    try {
      emit(state.copyWith(status: WalkStatus.loading));
      final walkTimes = await _walkRepository.getWalkTimes();
      emit(state.copyWith(status: WalkStatus.success, walkTimes: walkTimes));
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
    emit(
      state.copyWith(
        status: WalkStatus.success,
        selectedWalkFriend: walkFriend,
        currentStep: 3,
      ),
    );
  }

  void selectWalkTime(WalkTimeModel walkTime) {
    emit(
      state.copyWith(
        status: WalkStatus.success,
        selectedWalkTime: walkTime,
        currentStep: 4,
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
            state.selectedWalkTime != null;
      default:
        return false;
    }
  }

  // Start walk session
  void startWalk() {
    emit(state.copyWith(status: WalkStatus.loading));
    // TODO: Implement walk start logic
    emit(state.copyWith(status: WalkStatus.success));
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
        selectedWalkTime: state.selectedWalkTime,
        currentStep: 2,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
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
        selectedWalkTime: state.selectedWalkTime,
        currentStep: 1,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
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
        selectedWalkTime: state.selectedWalkTime,
        currentStep: 0,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
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
        selectedWalkTime: null, // Clear only walk time
        currentStep: 3,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
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
      WalkState(
        status: WalkStatus.success,
        error: state.error,
        selectedWalkType: state.selectedWalkType,
        selectedWalkGender: state.selectedWalkGender,
        selectedWalkFriend: state.selectedWalkFriend,
        selectedWalkTime: state.selectedWalkTime,
        currentStep: 1,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
        // Group data
        selectedGroupType: state.selectedGroupType,
        selectedGroupLocation: null, // Clear only location
        selectedGroupTime: state.selectedGroupTime,
        groupTypes: state.groupTypes,
        groupLocations: state.groupLocations,
        groupTimes: state.groupTimes,
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
        currentStep: 0,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
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
        currentStep: 2,
        navigationHistory: state.navigationHistory,
        walkTypes: state.walkTypes,
        walkGenders: state.walkGenders,
        walkFriends: state.walkFriends,
        walkTimes: state.walkTimes,
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
}
