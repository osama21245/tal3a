import '../models/walk_type_model.dart';
import '../models/walk_gender_model.dart';
import '../models/walk_friend_model.dart';
import '../models/walk_time_model.dart';

abstract class WalkRemoteDataSource {
  Future<List<WalkTypeModel>> getWalkTypes();
  Future<List<WalkGenderModel>> getWalkGenders();
  Future<List<WalkFriendModel>> getWalkFriends();
  Future<List<WalkTimeModel>> getWalkTimes();
}

class WalkRemoteDataSourceImpl implements WalkRemoteDataSource {
  // Simulate network delay
  static const Duration _networkDelay = Duration(milliseconds: 500);

  @override
  Future<List<WalkTypeModel>> getWalkTypes() async {
    await Future.delayed(_networkDelay);

    // Mock data based on Figma design - "How Do You Want to Walk?"
    return [
      const WalkTypeModel(id: 'one_on_one', name: '1-on-1'),
      const WalkTypeModel(id: 'group', name: 'Group'),
    ];
  }

  @override
  Future<List<WalkGenderModel>> getWalkGenders() async {
    await Future.delayed(_networkDelay);

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
  Future<List<WalkFriendModel>> getWalkFriends() async {
    await Future.delayed(_networkDelay);

    // Mock data based on Figma design - friend selection with name, age, weight
    return [
      const WalkFriendModel(
        id: 'friend_1',
        name: 'George Mikaiel',
        age: '20',
        weight: '80',
        imageUrl: 'assets/images/fitness_partner.png',
      ),
      const WalkFriendModel(
        id: 'friend_2',
        name: 'George Mikaiel',
        age: '20',
        weight: '80',
        imageUrl: 'assets/images/fitness_partner.png',
      ),
      const WalkFriendModel(
        id: 'friend_3',
        name: 'George Mikaiel',
        age: '20',
        weight: '80',
        imageUrl: 'assets/images/fitness_partner.png',
      ),
    ];
  }

  @override
  Future<List<WalkTimeModel>> getWalkTimes() async {
    await Future.delayed(_networkDelay);

    // Mock data based on Figma design - time selection
    return [
      const WalkTimeModel(
        id: 'time_1',
        timeSlot: '05:30 AM',
        isAvailable: true,
      ),
      const WalkTimeModel(
        id: 'time_2',
        timeSlot: '06:00 AM',
        isAvailable: true,
      ),
      const WalkTimeModel(
        id: 'time_3',
        timeSlot: '06:30 AM',
        isAvailable: true,
      ),
      const WalkTimeModel(
        id: 'time_4',
        timeSlot: '07:00 AM',
        isAvailable: true,
      ),
    ];
  }
}
