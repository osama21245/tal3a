// ignore_for_file: public_member_api_docs, sort_constructors_first

enum TrainingStatus { initial, loading, success, error }

extension TrainingStateExtension on TrainingState {
  bool get isInitial => state == TrainingStatus.initial;
  bool get isLoading => state == TrainingStatus.loading;
  bool get isSuccess => state == TrainingStatus.success;
  bool get isError => state == TrainingStatus.error;
}

class TrainingState {
  final TrainingStatus state;
  final String? error;
  final String? selectedTal3aType;
  final String? selectedCoach;
  final String? selectedMode;
  final int currentStep;

  TrainingState({
    required this.state,
    this.error,
    this.selectedTal3aType,
    this.selectedCoach,
    this.selectedMode,
    this.currentStep = 1,
  });

  TrainingState copyWith({
    TrainingStatus? state,
    String? error,
    String? selectedTal3aType,
    String? selectedCoach,
    String? selectedMode,
    int? currentStep,
  }) {
    return TrainingState(
      state: state ?? this.state,
      error: error ?? this.error,
      selectedTal3aType: selectedTal3aType ?? this.selectedTal3aType,
      selectedCoach: selectedCoach ?? this.selectedCoach,
      selectedMode: selectedMode ?? this.selectedMode,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  String toString() =>
      'TrainingState(state: $state, error: $error, selectedTal3aType: $selectedTal3aType, selectedCoach: $selectedCoach, selectedMode: $selectedMode, currentStep: $currentStep)';
}
