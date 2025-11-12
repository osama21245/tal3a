import 'package:flutter_bloc/flutter_bloc.dart';
import 'tal3a_type_state.dart';

class Tal3aTypeCubit extends Cubit<Tal3aTypeState> {
  Tal3aTypeCubit() : super(Tal3aTypeState(status: Tal3aTypeStatus.initial));

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

  // Select Tal3a Type (e.g., Training, Walking, Biking)
  void selectTal3aType(Tal3aTypeData tal3aType) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedTal3aType: tal3aType,
        currentStep: 1,
      ),
    );
  }

  // Select Coach
  void selectCoach(CoachData coach) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedCoach: coach,
        currentStep: 2,
      ),
    );
  }

  // Select Mode
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
}
