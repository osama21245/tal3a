import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../presentation/controllers/tal3a_type_state.dart';
import '../models/training_mode_model.dart';
import '../models/training_video_series_model.dart';

abstract class TrainingRemoteDataSource {
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

class TrainingRemoteDataSourceImpl implements TrainingRemoteDataSource {
  final ApiClient _apiClient;

  TrainingRemoteDataSourceImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<CoachData>> getCoaches() async {
    final response = await _apiClient.getAuthenticated(
      ApiConstants.getCoachesEndpoint,
    );

    if (response.isSuccess) {
      final decodedResponse = Map<String, dynamic>.from(
        response.data as Map<dynamic, dynamic>,
      );
      final status = decodedResponse['status'] as bool? ?? false;

      if (!status) {
        final message = decodedResponse['message']?.toString();
        throw ServerException(
          message: message ?? 'Request returned unsuccessful status',
          statusCode: response.statusCode,
        );
      }

      final coachesList = decodedResponse['coaches'] as List<dynamic>? ?? [];
      final coaches =
          coachesList
              .whereType<Map<String, dynamic>>()
              .map((json) => CoachData.fromJson(json))
              .toList();

      return coaches;
    }

    throw ServerException(
      message: response.error ?? 'Failed to load coaches',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<List<TrainingModeModel>> getCoachDetail(String coachId) async {
    final endpoint = '${ApiConstants.getCoachDetailEndpoint}/$coachId';
    final response = await _apiClient.getAuthenticated(endpoint);

    if (response.isSuccess) {
      final decodedResponse = Map<String, dynamic>.from(
        response.data as Map<dynamic, dynamic>,
      );
      final status = decodedResponse['status'] as bool? ?? false;

      if (!status) {
        final message = decodedResponse['message']?.toString();
        throw ServerException(
          message: message ?? 'Request returned unsuccessful status',
          statusCode: response.statusCode,
        );
      }

      final coachData = decodedResponse['coach'] as Map<String, dynamic>?;
      if (coachData == null) {
        throw ServerException(
          message: 'Coach data not found',
          statusCode: response.statusCode,
        );
      }

      final trainingModesList =
          coachData['trainingMode'] as List<dynamic>? ?? [];
      final trainingModes =
          trainingModesList
              .whereType<Map<String, dynamic>>()
              .map((json) => TrainingModeModel.fromJson(json))
              .toList();

      return trainingModes;
    }

    throw ServerException(
      message: response.error ?? 'Failed to load coach detail',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<List<TrainingVideoSeriesModel>> getVideoSeries({
    required String coachId,
    required String trainingModeId,
  }) async {
    final queryParams = {'coach': coachId, 'trainingMode': trainingModeId};

    final response = await _apiClient.getAuthenticated(
      ApiConstants.getVideoSeriesEndpoint,
      queryParams: queryParams,
    );

    if (response.isSuccess) {
      final decodedResponse = Map<String, dynamic>.from(
        response.data as Map<dynamic, dynamic>,
      );
      final success = decodedResponse['success'] as bool? ?? false;

      if (!success) {
        final message = decodedResponse['message']?.toString();
        throw ServerException(
          message: message ?? 'Request returned unsuccessful status',
          statusCode: response.statusCode,
        );
      }

      final dataList = decodedResponse['data'] as List<dynamic>? ?? [];
      final videoSeries =
          dataList
              .whereType<Map<String, dynamic>>()
              .map((json) => TrainingVideoSeriesModel.fromJson(json))
              .toList();

      // Sort by seriesOrder
      videoSeries.sort((a, b) => a.seriesOrder.compareTo(b.seriesOrder));

      return videoSeries;
    }

    throw ServerException(
      message: response.error ?? 'Failed to load video series',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<Map<String, dynamic>> rateCoach({
    required String coachId,
    required int rating,
    required String comment,
  }) async {
    final endpoint = '${ApiConstants.rateCoachEndpoint}/$coachId';
    final body = {'rating': rating, 'comment': comment};

    final response = await _apiClient.postAuthenticated(endpoint, body: body);

    if (response.isSuccess) {
      final decodedResponse = Map<String, dynamic>.from(
        response.data as Map<dynamic, dynamic>,
      );
      final status = decodedResponse['status'] as bool? ?? false;

      if (!status) {
        final message = decodedResponse['message']?.toString();
        throw ServerException(
          message: message ?? 'Request returned unsuccessful status',
          statusCode: response.statusCode,
        );
      }

      return {
        'averageRating': decodedResponse['averageRating'] as num? ?? 0.0,
        'totalRatings': decodedResponse['totalRatings'] as int? ?? 0,
      };
    }

    throw ServerException(
      message: response.error ?? 'Failed to submit rating',
      statusCode: response.statusCode,
    );
  }
}
