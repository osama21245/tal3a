import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/change_password_models.dart';
import '../../data/repositories/change_password_repository_impl.dart';

// Change Password Status Enum
enum ChangePasswordStatus { initial, loading, success, error }

// Extension for easy state checking
extension ChangePasswordStateExtension on ChangePasswordState {
  bool get isInitial => status == ChangePasswordStatus.initial;
  bool get isLoading => status == ChangePasswordStatus.loading;
  bool get isSuccess => status == ChangePasswordStatus.success;
  bool get isError => status == ChangePasswordStatus.error;
}

// Change Password State Class
class ChangePasswordState {
  final ChangePasswordStatus status;
  final String? error;
  final String? successMessage;
  final ChangePasswordResponseModel? response;

  ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.error,
    this.successMessage,
    this.response,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? error,
    String? successMessage,
    ChangePasswordResponseModel? response,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
      response: response ?? this.response,
    );
  }

  @override
  String toString() =>
      'ChangePasswordState(status: $status, error: $error, successMessage: $successMessage)';
}

// Change Password Cubit
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepository repository;

  ChangePasswordCubit({required this.repository})
    : super(ChangePasswordState());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));

    try {
      final request = ChangePasswordRequestModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      final response = await repository.changePassword(request);

      if (response.success) {
        emit(
          state.copyWith(
            status: ChangePasswordStatus.success,
            successMessage: response.message ?? 'Password changed successfully',
            response: response,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ChangePasswordStatus.error,
            error: response.error ?? 'Failed to change password',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ChangePasswordStatus.error, error: e.toString()),
      );
    }
  }

  void resetState() {
    emit(ChangePasswordState());
  }
}
