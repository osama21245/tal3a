import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

// Cubit
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(HomeState(state: HomeStatus.initial));

  // Load users from API
  Future<void> loadUsers({int? page, int? limit}) async {
    emit(state.copyWith(state: HomeStatus.loading));

    final result = await _homeRepository.getAllUsersExceptSelf(
      page: page ?? state.currentPage,
      limit: limit ?? 10,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(state: HomeStatus.error, error: failure.message));
      },
      (response) {
        emit(
          state.copyWith(
            state: HomeStatus.success,
            users: response.users,
            currentPage: response.currentPage,
            totalPages: response.totalPages,
            hasMoreUsers: response.currentPage < response.totalPages,
          ),
        );
      },
    );
  }

  // Load more users (pagination)
  Future<void> loadMoreUsers() async {
    if (!state.hasMoreUsers || state.isLoading) return;

    final result = await _homeRepository.getAllUsersExceptSelf(
      page: state.currentPage + 1,
      limit: 10,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(state: HomeStatus.error, error: failure.message));
      },
      (response) {
        final updatedUsers = [...state.users, ...response.users];
        emit(
          state.copyWith(
            state: HomeStatus.success,
            users: updatedUsers,
            currentPage: response.currentPage,
            totalPages: response.totalPages,
            hasMoreUsers: response.currentPage < response.totalPages,
          ),
        );
      },
    );
  }

  // Refresh users
  Future<void> refreshUsers() async {
    emit(
      state.copyWith(
        state: HomeStatus.initial,
        users: [],
        currentPage: 1,
        hasMoreUsers: true,
      ),
    );
    await loadUsers(page: 1, limit: 10);
  }

  // Toggle between Live Tala3a and Let's Tala3a
  void toggleTab(bool isLiveTala3aActive) {
    emit(state.copyWith(isLiveTala3aActive: isLiveTala3aActive));
  }
}
