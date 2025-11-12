import 'package:tal3a/features/activites/data/models/group_location_model.dart';
import 'package:tal3a/features/activites/data/models/group_time_model.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupLocationModel>> getGroupLocations();
  Future<List<GroupTimeModel>> getGroupTimes();
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
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
}
