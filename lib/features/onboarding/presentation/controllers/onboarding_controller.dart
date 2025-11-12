import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import 'onboarding_state.dart';

class OnboardingController extends Cubit<OnboardingState> {
  OnboardingController()
    : super(
        OnboardingState(
          state: OnboardingStatus.initial,
          isOnboardingCompleted: false,
        ),
      );

  // Check if onboarding is completed on app start
  Future<void> checkOnboardingStatus() async {
    emit(state.copyWith(state: OnboardingStatus.loading));

    try {
      final isCompleted = await SecureStorageHelper.isOnboardingCompleted();
      emit(
        state.copyWith(
          state: OnboardingStatus.success,
          isOnboardingCompleted: isCompleted,
        ),
      );
    } catch (e) {
      emit(state.copyWith(state: OnboardingStatus.error, error: e.toString()));
    }
  }

  // Mark onboarding as completed
  Future<void> completeOnboarding() async {
    emit(state.copyWith(state: OnboardingStatus.loading));

    try {
      await SecureStorageHelper.setOnboardingCompleted(true);
      emit(
        state.copyWith(
          state: OnboardingStatus.success,
          isOnboardingCompleted: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(state: OnboardingStatus.error, error: e.toString()));
    }
  }

  // Reset onboarding (for testing or logout)
  Future<void> resetOnboarding() async {
    emit(state.copyWith(state: OnboardingStatus.loading));

    try {
      await SecureStorageHelper.clearOnboardingData();
      emit(
        state.copyWith(
          state: OnboardingStatus.success,
          isOnboardingCompleted: false,
          currentPageIndex: 0,
        ),
      );
    } catch (e) {
      emit(state.copyWith(state: OnboardingStatus.error, error: e.toString()));
    }
  }

  // Update current page index
  void updateCurrentPage(int pageIndex) {
    emit(state.copyWith(currentPageIndex: pageIndex));
  }

  // Navigate to next page
  void nextPage(int totalPages) {
    if (state.currentPageIndex < totalPages - 1) {
      emit(state.copyWith(currentPageIndex: state.currentPageIndex + 1));
    }
  }

  // Navigate to previous page
  void previousPage() {
    if (state.currentPageIndex > 0) {
      emit(state.copyWith(currentPageIndex: state.currentPageIndex - 1));
    }
  }

  // Check if it's the last page
  bool isLastPage(int totalPages) {
    return state.currentPageIndex == totalPages - 1;
  }

  // Check if it's the first page
  bool isFirstPage() {
    return state.currentPageIndex == 0;
  }
}
