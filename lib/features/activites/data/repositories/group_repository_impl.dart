import '../datasources/group_remote_datasource.dart';
import '../models/group_location_model.dart';
import '../models/group_time_model.dart';
import '../models/group_tal3a_location_model.dart';
import '../models/group_tal3a_detail_model.dart';
import '../models/group_request_payload.dart';

abstract class GroupRepository {
  Future<List<GroupLocationModel>> getGroupLocations();
  Future<List<GroupTimeModel>> getGroupTimes();
  Future<List<GroupTal3aLocationModel>> getGroupTal3aLocations(
      String tal3aType);
  Future<List<GroupTal3aDetailModel>> getGroupTal3aByLocation(
      String locationName);
  Future<void> createGroupRequest(GroupRequestPayload payload);
}

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource _remoteDataSource;

  GroupRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<GroupLocationModel>> getGroupLocations() async {
    return await _remoteDataSource.getGroupLocations();
  }

  @override
  Future<List<GroupTimeModel>> getGroupTimes() async {
    return await _remoteDataSource.getGroupTimes();
  }

  @override
  Future<List<GroupTal3aLocationModel>> getGroupTal3aLocations(
      String tal3aType) async {
    return await _remoteDataSource.getGroupTal3aLocations(tal3aType);
  }

  @override
  Future<List<GroupTal3aDetailModel>> getGroupTal3aByLocation(
      String locationName) async {
    return await _remoteDataSource.getGroupTal3aByLocation(locationName);
  }

  @override
  Future<void> createGroupRequest(GroupRequestPayload payload) async {
    return await _remoteDataSource.createGroupRequest(payload);
  }
}
