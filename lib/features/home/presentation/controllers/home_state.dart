// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../data/models/user_models.dart';

enum HomeStatus { initial, loading, success, error }

extension HomeStateExtension on HomeState {
  bool get isInitial => state == HomeStatus.initial;
  bool get isLoading => state == HomeStatus.loading;
  bool get isSuccess => state == HomeStatus.success;
  bool get isError => state == HomeStatus.error;
}

class HomeState {
  final HomeStatus state;
  final String? error;
  final List<User> users;
  final bool isLiveTala3aActive;
  final int currentPage;
  final int totalPages;
  final bool hasMoreUsers;

  HomeState({
    required this.state,
    this.error,
    this.users = const [],
    this.isLiveTala3aActive = true,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMoreUsers = true,
  });

  HomeState copyWith({
    HomeStatus? state,
    String? error,
    List<User>? users,
    bool? isLiveTala3aActive,
    int? currentPage,
    int? totalPages,
    bool? hasMoreUsers,
  }) {
    return HomeState(
      state: state ?? this.state,
      error: error ?? this.error,
      users: users ?? this.users,
      isLiveTala3aActive: isLiveTala3aActive ?? this.isLiveTala3aActive,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMoreUsers: hasMoreUsers ?? this.hasMoreUsers,
    );
  }

  @override
  String toString() =>
      'HomeState(state: $state, error: $error, users: ${users.length}, isLiveTala3aActive: $isLiveTala3aActive, currentPage: $currentPage, totalPages: $totalPages, hasMoreUsers: $hasMoreUsers)';
}
