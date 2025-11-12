import 'package:flutter_bloc/flutter_bloc.dart';
import 'tal3a_type_state.dart';
import '../../data/models/walk_type_model.dart';
import '../../data/models/walk_gender_model.dart';
import '../../data/models/walk_friend_model.dart';
import '../../data/models/walk_time_model.dart';

class TrainingCubit extends Cubit<Tal3aTypeState> {
  TrainingCubit() : super(Tal3aTypeState(status: Tal3aTypeStatus.initial));

  // Navigation History Management
  void addNavigationNode(String screenName, {Map<String, dynamic>? data}) {
    final newNode = NavigationNode(screenName: screenName, data: data);
    final updatedHistory = List<NavigationNode>.from(state.navigationHistory)
      ..add(newNode);

    emit(state.copyWith(navigationHistory: updatedHistory));
  }

  void removeLastNavigationNode() {
    if (state.navigationHistory.isNotEmpty) {
      final updatedHistory = List<NavigationNode>.from(state.navigationHistory)
        ..removeLast();
      emit(state.copyWith(navigationHistory: updatedHistory));
    }
  }

  void clearNavigationHistory() {
    emit(state.copyWith(navigationHistory: []));
  }

  // Training-specific methods
  void selectTal3aType(Tal3aTypeData tal3aType) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedTal3aType: tal3aType,
        currentStep: 1,
      ),
    );
  }

  void selectCoach(CoachData coach) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedCoach: coach,
        currentStep: 2,
      ),
    );
  }

  void selectMode(String mode) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedMode: mode,
        currentStep: 3,
      ),
    );
  }

  // Update coach data with additional information
  void updateCoachData(CoachData coach) {
    emit(state.copyWith(selectedCoach: coach));
  }

  // Reset state
  void reset() {
    emit(Tal3aTypeState(status: Tal3aTypeStatus.initial));
  }

  // Get current header data for display
  Tal3aTypeData? getCurrentTal3aTypeData() {
    return state.selectedTal3aType;
  }

  // Get current coach data for display
  CoachData? getCurrentCoachData() {
    return state.selectedCoach;
  }

  // Check if we have all required data for a specific step
  bool hasRequiredDataForStep(int step) {
    switch (step) {
      case 1:
        return state.selectedTal3aType != null;
      case 2:
        return state.selectedTal3aType != null && state.selectedCoach != null;
      case 3:
        return state.selectedTal3aType != null &&
            state.selectedCoach != null &&
            state.selectedMode != null;
      default:
        return false;
    }
  }

  // Training-specific methods
  void startTraining() {
    emit(state.copyWith(status: Tal3aTypeStatus.loading));
    // TODO: Implement training start logic
    emit(state.copyWith(status: Tal3aTypeStatus.success));
  }

  void pauseTraining() {
    // TODO: Implement training pause logic
  }

  void stopTraining() {
    // TODO: Implement training stop logic
  }

  void completeTraining() {
    // TODO: Implement training completion logic
    emit(state.copyWith(status: Tal3aTypeStatus.success));
  }

  // Walk-specific methods
  void selectWalkType(WalkTypeModel walkType) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedWalkType: walkType,
        currentStep: 1,
      ),
    );
  }

  void selectWalkGender(WalkGenderModel walkGender) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedWalkGender: walkGender,
        currentStep: 2,
      ),
    );
  }

  void selectWalkFriend(WalkFriendModel walkFriend) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedWalkFriend: walkFriend,
        currentStep: 3,
      ),
    );
  }

  void selectWalkTime(WalkTimeModel walkTime) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
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
    emit(state.copyWith(status: Tal3aTypeStatus.loading));
    // TODO: Implement walk start logic
    emit(state.copyWith(status: Tal3aTypeStatus.success));
  }
}
