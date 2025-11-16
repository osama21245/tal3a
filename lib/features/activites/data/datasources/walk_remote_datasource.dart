import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/walk_type_model.dart';
import '../models/walk_gender_model.dart';
import '../models/walk_friend_model.dart';
import '../models/walk_time_model.dart';
import '../models/walk_request_payload.dart';

abstract class WalkRemoteDataSource {
  Future<List<WalkTypeModel>> getWalkTypes();
  Future<List<WalkGenderModel>> getWalkGenders();
  Future<List<WalkFriendModel>> getWalkFriends(String gender);
  Future<List<WalkTimeModel>> getWalkTimes();
  Future<void> sendWalkRequest(WalkRequestPayload payload);
}

class WalkRemoteDataSourceImpl implements WalkRemoteDataSource {
  final ApiClient _apiClient;

  WalkRemoteDataSourceImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<WalkTypeModel>> getWalkTypes() async {
    // Mock data based on Figma design - "How Do You Want to Walk?"
    return [
      const WalkTypeModel(id: 'one_on_one', name: '1-on-1'),
      const WalkTypeModel(id: 'group', name: 'Group'),
    ];
  }

  @override
  Future<List<WalkGenderModel>> getWalkGenders() async {
    // Mock data based on Figma design - "With Who?"
    return [
      const WalkGenderModel(
        id: 'man',
        name: 'man',
        iconPath: 'assets/icons/male_icon.svg',
      ),
      const WalkGenderModel(
        id: 'woman',
        name: 'woman',
        iconPath: 'assets/icons/female_icon.svg',
      ),
    ];
  }

  @override
  Future<List<WalkFriendModel>> getWalkFriends(String gender) async {
    final response = await _apiClient.getAuthenticated(
      ApiConstants.getUserByGenderEndpoint,
      queryParams: {'Gender': gender},
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

      final users =
          (decodedResponse['users'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(WalkFriendModel.fromJson)
              .toList();

      return users;
    }

    throw ServerException(
      message: response.error ?? 'Failed to load walk friends',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<List<WalkTimeModel>> getWalkTimes() async {
    // Mock data based on Figma design - time selection
    final baseDate = DateTime.now().add(const Duration(days: 1));

    return [
      WalkTimeModel(
        id: 'time_1',
        timeSlot: '05:30 AM',
        isAvailable: true,
        scheduledAt: DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          5,
          30,
        ),
      ),
      WalkTimeModel(
        id: 'time_2',
        timeSlot: '06:00 AM',
        isAvailable: true,
        scheduledAt: DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          6,
          0,
        ),
      ),
      WalkTimeModel(
        id: 'time_3',
        timeSlot: '06:30 AM',
        isAvailable: true,
        scheduledAt: DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          6,
          30,
        ),
      ),
      WalkTimeModel(
        id: 'time_4',
        timeSlot: '07:00 AM',
        isAvailable: true,
        scheduledAt: DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          7,
          0,
        ),
      ),
    ];
  }

  @override
  Future<void> sendWalkRequest(WalkRequestPayload payload) async {
    final response = await _apiClient.postAuthenticated(
      ApiConstants.sendWalkRequestEndpoint,
      body: payload.toJson(),
    );

    if (response.isSuccess) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final status = data['status'] as bool? ?? true;
        if (!status) {
          throw ServerException(
            message:
                data['message']?.toString() ?? 'Failed to send walk request',
            statusCode: response.statusCode,
          );
        }
      }
      return;
    }

    throw ServerException(
      message: response.error ?? 'Failed to send walk request',
      statusCode: response.statusCode,
    );
  }
}
