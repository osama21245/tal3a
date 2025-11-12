import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import '../../features/auth/data/models/profile_setup_request_model.dart';

// Profile Setup Status
enum ProfileSetupStatus { initial, loading, success, error }

// Profile Setup State
class ProfileSetupState {
  final ProfileSetupStatus status;
  final List<String> interests;
  final String gender;
  final String birthDate;
  final String weight;
  final String height;
  final String? error;

  ProfileSetupState({
    this.status = ProfileSetupStatus.initial,
    this.interests = const [],
    this.gender = '',
    this.birthDate = '',
    this.weight = '',
    this.height = '',
    this.error,
  });

  ProfileSetupState copyWith({
    ProfileSetupStatus? status,
    List<String>? interests,
    String? gender,
    String? birthDate,
    String? weight,
    String? height,
    String? error,
  }) {
    return ProfileSetupState(
      status: status ?? this.status,
      interests: interests ?? this.interests,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      error: error ?? this.error,
    );
  }
}

// Extension for easy state checking
extension ProfileSetupStateExtension on ProfileSetupState {
  bool get isInitial => status == ProfileSetupStatus.initial;
  bool get isLoading => status == ProfileSetupStatus.loading;
  bool get isSuccess => status == ProfileSetupStatus.success;
  bool get isError => status == ProfileSetupStatus.error;
}

// Profile Setup Controller
class ProfileSetupController extends Cubit<ProfileSetupState> {
  final AuthService _authService = AuthService();

  ProfileSetupController() : super(ProfileSetupState());

  // Set interests
  void setInterests(List<String> interests) {
    emit(state.copyWith(interests: interests));
  }

  // Set gender
  void setGender(String gender) {
    emit(state.copyWith(gender: gender));
  }

  // Set birth date
  void setBirthDate(String birthDate) {
    emit(state.copyWith(birthDate: birthDate));
  }

  // Set weight
  void setWeight(String weight) {
    emit(state.copyWith(weight: weight));
  }

  // Set height
  void setHeight(String height) {
    emit(state.copyWith(height: height));
  }

  // Complete profile setup
  Future<void> completeProfileSetup() async {
    print('🔍 ProfileSetupController: Starting profile setup completion');
    print(
      '🔍 Current state: ${state.interests}, ${state.gender}, ${state.birthDate}, ${state.weight}, ${state.height}',
    );

    emit(state.copyWith(status: ProfileSetupStatus.loading));

    try {
      final request = ProfileSetupRequestModel(
        interests: state.interests,
        gender: state.gender,
        birthDate: state.birthDate,
        weight: state.weight,
        height: state.height,
      );

      print('🔍 Sending request to API: ${request.toJson()}');
      print('🔍 Request details:');
      print(
        '  - Interests: ${request.interests} (type: ${request.interests.runtimeType})',
      );
      print('  - Gender: ${request.gender}');
      print('  - BirthDate: ${request.birthDate}');
      print('  - Weight: ${request.weight}');
      print('  - Height: ${request.height}');

      await _authService.completeProfileSetup(request);

      // Profile setup is already marked as completed in AuthService when API succeeds
      print('🔍 Profile setup completed successfully');
      emit(state.copyWith(status: ProfileSetupStatus.success));
    } catch (e) {
      print('🔍 Profile setup failed: $e');
      emit(
        state.copyWith(status: ProfileSetupStatus.error, error: e.toString()),
      );
    }
  }

  // Check if all required data is collected
  bool get isComplete {
    final hasInterests = state.interests.isNotEmpty;
    final hasGender = state.gender.isNotEmpty;
    final hasBirthDate = state.birthDate.isNotEmpty;
    final hasWeight = state.weight.isNotEmpty;
    final hasHeight = state.height.isNotEmpty;

    print('🔍 ProfileSetupController isComplete check:');
    print('  - Interests: $hasInterests (${state.interests})');
    print('  - Gender: $hasGender (${state.gender})');
    print('  - BirthDate: $hasBirthDate (${state.birthDate})');
    print('  - Weight: $hasWeight (${state.weight})');
    print('  - Height: $hasHeight (${state.height})');

    return hasInterests && hasGender && hasBirthDate && hasWeight && hasHeight;
  }
}
