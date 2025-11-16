import 'package:flutter_bloc/flutter_bloc.dart';
import 'tal3a_type_state.dart';
import '../../data/models/walk_type_model.dart';
import '../../data/models/walk_gender_model.dart';
import '../../data/models/walk_friend_model.dart';
import '../../data/models/walk_time_model.dart';
import '../../data/models/training_mode_model.dart';
import '../../data/models/training_video_series_model.dart';
import '../../data/repositories/training_repository_impl.dart';
import '../../data/datasources/training_remote_datasource.dart';

class TrainingCubit extends Cubit<Tal3aTypeState> {
  final TrainingRepository _trainingRepository;

  TrainingCubit({TrainingRepository? trainingRepository})
    : _trainingRepository =
          trainingRepository ??
          TrainingRepositoryImpl(
            remoteDataSource: TrainingRemoteDataSourceImpl(),
          ),
      super(Tal3aTypeState(status: Tal3aTypeStatus.initial));

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

  void selectMode(TrainingModeModel mode) {
    emit(
      state.copyWith(
        status: Tal3aTypeStatus.success,
        selectedMode: mode,
        currentStep: 3,
      ),
    );
  }

  void clearMode() {
    emit(state.copyWith(selectedMode: null, currentStep: 2));
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

  // Data loading methods
  Future<void> loadCoaches() async {
    try {
      emit(state.copyWith(status: Tal3aTypeStatus.loading));
      final coaches = await _trainingRepository.getCoaches();
      emit(
        state.copyWith(
          status: Tal3aTypeStatus.success,
          coaches: coaches,
          // Preserve existing training modes when loading coaches
          trainingModes: state.trainingModes,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Tal3aTypeStatus.error,
          error: e.toString(),
          // Preserve existing data on error
          coaches: state.coaches,
          trainingModes: state.trainingModes,
        ),
      );
    }
  }

  Future<void> loadCoachDetail(String coachId) async {
    try {
      emit(state.copyWith(status: Tal3aTypeStatus.loading));
      final trainingModes = await _trainingRepository.getCoachDetail(coachId);
      emit(
        state.copyWith(
          status: Tal3aTypeStatus.success,
          trainingModes: trainingModes,
          // Preserve existing coaches list when loading coach detail
          coaches: state.coaches,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Tal3aTypeStatus.error,
          error: e.toString(),
          // Preserve existing data on error
          coaches: state.coaches,
          trainingModes: state.trainingModes,
        ),
      );
    }
  }

  Future<void> loadVideoSeries({
    required String coachId,
    required String trainingModeId,
  }) async {
    try {
      emit(state.copyWith(status: Tal3aTypeStatus.loading));
      final videoSeries = await _trainingRepository.getVideoSeries(
        coachId: coachId,
        trainingModeId: trainingModeId,
      );
      // Set first video as selected by default
      final selectedVideo = videoSeries.isNotEmpty ? videoSeries.first : null;
      emit(
        state.copyWith(
          status: Tal3aTypeStatus.success,
          videoSeries: videoSeries,
          selectedVideo: selectedVideo,
          // Preserve existing data
          coaches: state.coaches,
          trainingModes: state.trainingModes,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Tal3aTypeStatus.error,
          error: e.toString(),
          // Preserve existing data on error
          coaches: state.coaches,
          trainingModes: state.trainingModes,
          videoSeries: state.videoSeries,
        ),
      );
    }
  }

  void selectVideo(TrainingVideoSeriesModel video) {
    emit(
      state.copyWith(
        selectedVideo: video,
        // Preserve existing data
        coaches: state.coaches,
        trainingModes: state.trainingModes,
        videoSeries: state.videoSeries,
      ),
    );
  }

  Future<void> rateCoach({
    required String coachId,
    required int rating,
    required String comment,
  }) async {
    try {
      emit(state.copyWith(status: Tal3aTypeStatus.loading));
      final result = await _trainingRepository.rateCoach(
        coachId: coachId,
        rating: rating,
        comment: comment,
      );

      // Update coach rating in the coaches list
      final updatedCoaches =
          state.coaches.map((coach) {
            if (coach.id == coachId) {
              return coach.copyWith(
                rating:
                    (result['averageRating'] as num?)?.toDouble() ??
                    coach.rating,
                totalRatings:
                    result['totalRatings'] as int? ?? coach.totalRatings,
              );
            }
            return coach;
          }).toList();

      // Update selected coach if it's the same
      CoachData? updatedSelectedCoach = state.selectedCoach;
      if (updatedSelectedCoach?.id == coachId) {
        updatedSelectedCoach = updatedSelectedCoach!.copyWith(
          rating:
              (result['averageRating'] as num?)?.toDouble() ??
              updatedSelectedCoach.rating,
          totalRatings:
              result['totalRatings'] as int? ??
              updatedSelectedCoach.totalRatings,
        );
      }

      emit(
        state.copyWith(
          status: Tal3aTypeStatus.success,
          coaches: updatedCoaches,
          selectedCoach: updatedSelectedCoach,
          // Preserve existing data
          trainingModes: state.trainingModes,
          videoSeries: state.videoSeries,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Tal3aTypeStatus.error,
          error: e.toString(),
          // Preserve existing data on error
          coaches: state.coaches,
          trainingModes: state.trainingModes,
          videoSeries: state.videoSeries,
        ),
      );
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
