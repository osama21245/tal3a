import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/biking_type_model.dart';
import '../../data/models/biking_gender_model.dart';
import '../../data/models/biking_friend_model.dart';
import '../../data/models/biking_time_model.dart';
import '../../data/models/biking_group_type_model.dart';
import '../../data/models/biking_group_location_model.dart';
import '../../data/models/biking_group_time_model.dart';
import 'biking_state.dart';

class BikingCubit extends Cubit<BikingState> {
  BikingCubit() : super(const BikingState());

  // Biking Type Methods
  void selectBikingType(BikingTypeModel bikingType) {
    emit(state.copyWith(selectedBikingType: bikingType, error: null));
  }

  void clearBikingType() {
    emit(
      state.copyWith(
        clearSelectedBikingType: true,
        clearSelectedBikingGender: true,
        clearSelectedBikingFriend: true,
        clearSelectedBikingTime: true,
        error: null,
      ),
    );
  }

  // Biking Gender Methods
  void selectBikingGender(BikingGenderModel bikingGender) {
    emit(state.copyWith(selectedBikingGender: bikingGender, error: null));
  }

  void clearBikingGender() {
    emit(
      state.copyWith(
        clearSelectedBikingGender: true,
        clearSelectedBikingFriend: true,
        clearSelectedBikingTime: true,
        error: null,
      ),
    );
  }

  // Biking Friend Methods
  void selectBikingFriend(BikingFriendModel bikingFriend) {
    emit(state.copyWith(selectedBikingFriend: bikingFriend, error: null));
  }

  void clearBikingFriend() {
    emit(
      state.copyWith(
        clearSelectedBikingFriend: true,
        clearSelectedBikingTime: true,
        error: null,
      ),
    );
  }

  // Biking Time Methods
  void selectBikingTime(BikingTimeModel bikingTime) {
    emit(state.copyWith(selectedBikingTime: bikingTime, error: null));
  }

  void clearBikingTime() {
    emit(state.copyWith(clearSelectedBikingTime: true, error: null));
  }

  // Biking Group Type Methods
  void selectBikingGroupType(BikingGroupTypeModel bikingGroupType) {
    emit(state.copyWith(selectedBikingGroupType: bikingGroupType, error: null));
  }

  void clearBikingGroupType() {
    emit(
      state.copyWith(
        clearSelectedBikingGroupType: true,
        clearSelectedBikingGroupLocation: true,
        clearSelectedBikingGroupTime: true,
        error: null,
      ),
    );
  }

  // Biking Group Location Methods
  void selectBikingGroupLocation(BikingGroupLocationModel bikingGroupLocation) {
    emit(
      state.copyWith(
        selectedBikingGroupLocation: bikingGroupLocation,
        error: null,
      ),
    );
  }

  void clearBikingGroupLocation() {
    emit(
      state.copyWith(
        clearSelectedBikingGroupLocation: true,
        clearSelectedBikingGroupTime: true,
        error: null,
      ),
    );
  }

  // Biking Group Time Methods
  void selectBikingGroupTime(BikingGroupTimeModel bikingGroupTime) {
    emit(state.copyWith(selectedBikingGroupTime: bikingGroupTime, error: null));
  }

  void clearBikingGroupTime() {
    emit(state.copyWith(clearSelectedBikingGroupTime: true, error: null));
  }

  // Navigation History Methods
  void addNavigationNode(String screenName, {Map<String, dynamic>? data}) {
    final navigationHistory = List<Map<String, dynamic>>.from(
      state.navigationHistory,
    );
    navigationHistory.add({
      'screenName': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    });
    emit(state.copyWith(navigationHistory: navigationHistory));
  }

  void removeLastNavigationNode() {
    if (state.navigationHistory.isNotEmpty) {
      final navigationHistory = List<Map<String, dynamic>>.from(
        state.navigationHistory,
      );
      navigationHistory.removeLast();
      emit(state.copyWith(navigationHistory: navigationHistory));
    }
  }

  void clearNavigationHistory() {
    emit(state.copyWith(navigationHistory: []));
  }

  // Reset all selections
  void resetAll() {
    emit(const BikingState());
  }

  // Set loading state
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  // Set error
  void setError(String error) {
    emit(state.copyWith(error: error, isLoading: false));
  }

  // Clear error
  void clearError() {
    emit(state.copyWith(error: null));
  }
}
