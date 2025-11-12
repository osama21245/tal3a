// ignore_for_file: public_member_api_docs, sort_constructors_first

enum OnboardingStatus { initial, loading, success, error }

extension OnboardingStateExtension on OnboardingState {
  bool get isInitial => state == OnboardingStatus.initial;
  bool get isLoading => state == OnboardingStatus.loading;
  bool get isSuccess => state == OnboardingStatus.success;
  bool get isError => state == OnboardingStatus.error;
}

class OnboardingState {
  final OnboardingStatus state;
  final String? error;
  final bool? isOnboardingCompleted;
  final int currentPageIndex;

  OnboardingState({
    required this.state,
    this.error,
    this.isOnboardingCompleted,
    this.currentPageIndex = 0,
  });

  OnboardingState copyWith({
    OnboardingStatus? state,
    String? error,
    bool? isOnboardingCompleted,
    int? currentPageIndex,
  }) {
    return OnboardingState(
      state: state ?? this.state,
      error: error ?? this.error,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }

  @override
  String toString() =>
      'OnboardingState(state: $state, error: $error, isOnboardingCompleted: $isOnboardingCompleted, currentPageIndex: $currentPageIndex)';
}
