import 'package:tal3a/core/constants/api_constants.dart';
import 'package:tal3a/core/network/api_client.dart';
import 'package:tal3a/core/exceptions/app_exceptions.dart';
import 'package:tal3a/features/activites/data/models/group_location_model.dart';
import 'package:tal3a/features/activites/data/models/group_time_model.dart';
import 'package:tal3a/features/activites/data/models/group_tal3a_location_model.dart';
import 'package:tal3a/features/activites/data/models/group_tal3a_detail_model.dart';
import 'package:tal3a/features/activites/data/models/group_request_payload.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupLocationModel>> getGroupLocations();
  Future<List<GroupTimeModel>> getGroupTimes();
  Future<List<GroupTal3aLocationModel>> getGroupTal3aLocations(
    String tal3aType,
  );
  Future<List<GroupTal3aDetailModel>> getGroupTal3aByLocation(
    String locationName,
  );
  Future<void> createGroupRequest(GroupRequestPayload payload);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final ApiClient _apiClient;

  GroupRemoteDataSourceImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();
  @override
  Future<List<GroupLocationModel>> getGroupLocations() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock data based on Figma designs
    return [
      const GroupLocationModel(
        id: 'location_1',
        name: 'King Fahd Park',
        address: 'Riyadh, Saudi Arabia',
        latitude: 24.7136,
        longitude: 46.6753,
        imageUrl: 'assets/images/map_placeholder.png',
        isSelected: false,
      ),
      const GroupLocationModel(
        id: 'location_2',
        name: 'Al Bujairi Heritage Park',
        address: 'Diriyah, Saudi Arabia',
        latitude: 24.7338,
        longitude: 46.5724,
        imageUrl: 'assets/images/map_placeholder.png',
        isSelected: false,
      ),
      const GroupLocationModel(
        id: 'location_3',
        name: 'Wadi Hanifa',
        address: 'Riyadh, Saudi Arabia',
        latitude: 24.6889,
        longitude: 46.7219,
        imageUrl: 'assets/images/map_placeholder.png',
        isSelected: true, // This will be selected by default in Figma
      ),
      const GroupLocationModel(
        id: 'location_4',
        name: 'King Abdullah Park',
        address: 'Riyadh, Saudi Arabia',
        latitude: 24.6874,
        longitude: 46.7219,
        imageUrl: 'assets/images/map_placeholder.png',
        isSelected: false,
      ),
    ];
  }

  @override
  Future<List<GroupTimeModel>> getGroupTimes() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock data based on Figma designs - showing calendar with time slots
    return [
      const GroupTimeModel(
        id: 'time_1',
        timeSlot: '11:30 PM',
        day: 'Sun',
        date: '19',
        isSelected: false,
        isAvailable: true,
      ),
      const GroupTimeModel(
        id: 'time_2',
        timeSlot: '3:30 AM',
        day: 'Tue',
        date: '21',
        isSelected: true, // This will be selected by default in Figma
        isAvailable: true,
      ),
      const GroupTimeModel(
        id: 'time_3',
        timeSlot: '6:00 AM',
        day: 'Wed',
        date: '22',
        isSelected: false,
        isAvailable: true,
      ),
      const GroupTimeModel(
        id: 'time_4',
        timeSlot: '8:30 AM',
        day: 'Thu',
        date: '23',
        isSelected: false,
        isAvailable: true,
      ),
      const GroupTimeModel(
        id: 'time_5',
        timeSlot: '10:00 AM',
        day: 'Fri',
        date: '24',
        isSelected: false,
        isAvailable: false, // Not available
      ),
    ];
  }

  @override
  Future<List<GroupTal3aLocationModel>> getGroupTal3aLocations(
    String tal3aType,
  ) async {
    try {
      final response = await _apiClient.getAuthenticated(
        ApiConstants.getGroupTal3aLocationsEndpoint,
        queryParams: {'tal3aType': tal3aType},
      );

      if (response.isSuccess) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final status = data['status'] as bool? ?? false;
          if (!status) {
            throw ServerException(
              message:
                  data['message']?.toString() ??
                  'Failed to fetch group tal3a locations',
              statusCode: response.statusCode,
            );
          }

          final locationsData = data['data'] as List<dynamic>? ?? [];
          return locationsData
              .map(
                (location) => GroupTal3aLocationModel.fromJson(
                  location as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw ServerException(
          message: 'Invalid response format',
          statusCode: response.statusCode,
        );
      }

      throw ServerException(
        message: response.error ?? 'Failed to fetch group tal3a locations',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to fetch group tal3a locations: $e',
      );
    }
  }

  @override
  Future<List<GroupTal3aDetailModel>> getGroupTal3aByLocation(
    String locationName,
  ) async {
    try {
      final response = await _apiClient.getAuthenticated(
        ApiConstants.getGroupTal3aByLocationEndpoint,
        queryParams: {'locationName': locationName},
      );

      if (response.isSuccess) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final status = data['status'] as bool? ?? false;
          if (!status) {
            throw ServerException(
              message:
                  data['message']?.toString() ??
                  'Failed to fetch group tal3a by location',
              statusCode: response.statusCode,
            );
          }

          final detailsData = data['data'] as List<dynamic>? ?? [];
          return detailsData
              .map(
                (detail) => GroupTal3aDetailModel.fromJson(
                  detail as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw ServerException(
          message: 'Invalid response format',
          statusCode: response.statusCode,
        );
      }

      throw ServerException(
        message: response.error ?? 'Failed to fetch group tal3a by location',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to fetch group tal3a by location: $e',
      );
    }
  }

  @override
  Future<void> createGroupRequest(GroupRequestPayload payload) async {
    try {
      final response = await _apiClient.postAuthenticated(
        ApiConstants.createGroupRequestEndpoint,
        body: payload.toJson(),
      );

      if (response.isSuccess) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final status = data['status'] as bool? ?? true;
          if (!status) {
            throw ServerException(
              message:
                  data['message']?.toString() ??
                  'Failed to create group request',
              statusCode: response.statusCode,
            );
          }
        }
        return;
      }

      throw ServerException(
        message: response.error ?? 'Failed to create group request',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to create group request: $e');
    }
  }
}
