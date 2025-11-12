import '../datasources/walk_remote_datasource.dart';
import '../models/walk_type_model.dart';
import '../models/walk_gender_model.dart';
import '../models/walk_friend_model.dart';
import '../models/walk_time_model.dart';

abstract class WalkRepository {
  Future<List<WalkTypeModel>> getWalkTypes();
  Future<List<WalkGenderModel>> getWalkGenders();
  Future<List<WalkFriendModel>> getWalkFriends();
  Future<List<WalkTimeModel>> getWalkTimes();
}

class WalkRepositoryImpl implements WalkRepository {
  final WalkRemoteDataSource _remoteDataSource;

  WalkRepositoryImpl({required WalkRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<List<WalkTypeModel>> getWalkTypes() async {
    try {
      return await _remoteDataSource.getWalkTypes();
    } catch (e) {
      throw Exception('Failed to get walk types: $e');
    }
  }

  @override
  Future<List<WalkGenderModel>> getWalkGenders() async {
    try {
      return await _remoteDataSource.getWalkGenders();
    } catch (e) {
      throw Exception('Failed to get walk genders: $e');
    }
  }

  @override
  Future<List<WalkFriendModel>> getWalkFriends() async {
    try {
      return await _remoteDataSource.getWalkFriends();
    } catch (e) {
      throw Exception('Failed to get walk friends: $e');
    }
  }

  @override
  Future<List<WalkTimeModel>> getWalkTimes() async {
    try {
      return await _remoteDataSource.getWalkTimes();
    } catch (e) {
      throw Exception('Failed to get walk times: $e');
    }
  }
}
