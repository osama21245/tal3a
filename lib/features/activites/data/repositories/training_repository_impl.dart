import '../datasources/training_remote_datasource.dart';
import '../../presentation/controllers/tal3a_type_state.dart';
import '../models/training_mode_model.dart';
import '../models/training_video_series_model.dart';

abstract class TrainingRepository {
  Future<List<CoachData>> getCoaches();
  Future<List<TrainingModeModel>> getCoachDetail(String coachId);
  Future<List<TrainingVideoSeriesModel>> getVideoSeries({
    required String coachId,
    required String trainingModeId,
  });
  Future<Map<String, dynamic>> rateCoach({
    required String coachId,
    required int rating,
    required String comment,
  });
}

class TrainingRepositoryImpl implements TrainingRepository {
  final TrainingRemoteDataSource _remoteDataSource;

  TrainingRepositoryImpl({required TrainingRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<List<CoachData>> getCoaches() {
    return _remoteDataSource.getCoaches();
  }

  @override
  Future<List<TrainingModeModel>> getCoachDetail(String coachId) {
    return _remoteDataSource.getCoachDetail(coachId);
  }

  @override
  Future<List<TrainingVideoSeriesModel>> getVideoSeries({
    required String coachId,
    required String trainingModeId,
  }) {
    return _remoteDataSource.getVideoSeries(
      coachId: coachId,
      trainingModeId: trainingModeId,
    );
  }

  @override
  Future<Map<String, dynamic>> rateCoach({
    required String coachId,
    required int rating,
    required String comment,
  }) {
    return _remoteDataSource.rateCoach(
      coachId: coachId,
      rating: rating,
      comment: comment,
    );
  }
}
