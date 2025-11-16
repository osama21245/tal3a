import '../datasources/walk_remote_datasource.dart';
import '../models/walk_type_model.dart';
import '../models/walk_gender_model.dart';
import '../models/walk_friend_model.dart';
import '../models/walk_time_model.dart';
import '../models/walk_request_payload.dart';

abstract class WalkRepository {
  Future<List<WalkTypeModel>> getWalkTypes();
  Future<List<WalkGenderModel>> getWalkGenders();
  Future<List<WalkFriendModel>> getWalkFriends(String gender);
  Future<List<WalkTimeModel>> getWalkTimes();
  Future<void> sendWalkRequest(WalkRequestPayload payload);
}

class WalkRepositoryImpl implements WalkRepository {
  final WalkRemoteDataSource _remoteDataSource;

  WalkRepositoryImpl({required WalkRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<List<WalkTypeModel>> getWalkTypes() {
    return _remoteDataSource.getWalkTypes();
  }

  @override
  Future<List<WalkGenderModel>> getWalkGenders() {
    return _remoteDataSource.getWalkGenders();
  }

  @override
  Future<List<WalkFriendModel>> getWalkFriends(String gender) {
    return _remoteDataSource.getWalkFriends(gender);
  }

  @override
  Future<List<WalkTimeModel>> getWalkTimes() {
    return _remoteDataSource.getWalkTimes();
  }

  @override
  Future<void> sendWalkRequest(WalkRequestPayload payload) {
    return _remoteDataSource.sendWalkRequest(payload);
  }
}
