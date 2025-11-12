import '../datasources/group_remote_datasource.dart';
import '../models/group_location_model.dart';
import '../models/group_time_model.dart';

abstract class GroupRepository {
  Future<List<GroupLocationModel>> getGroupLocations();
  Future<List<GroupTimeModel>> getGroupTimes();
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
}
