import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/features/tal3a_vibes/tal3a_vibes_feature.dart';
import '../widgets/home_screen/custom_fluid_bottom_nav_widget.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/network/api_client.dart';
import '../../data/data_sources/home_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../controllers/home_cubit.dart';
import '../widgets/home_screen/home_header_widget.dart';
import '../widgets/home_screen/home_tab_selector_widget.dart';
import '../widgets/home_screen/home_activity_grid_widget.dart';
import '../../../events/events_feature.dart';
import '../../../settings_and_profile/settings_and_profile_feature.dart';
import '../../../story/presentation/controllers/story_cubit.dart';
import '../../../story/data/data_sources/story_data_source.dart';
import '../../../story/data/repositories/story_repository_impl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreenIndex = 0;

  void _handleNavigationChange(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final apiClient = ApiClient();
            final dataSource = HomeDataSourceImpl(apiClient: apiClient);
            final repository = HomeRepositoryImpl(dataSource: dataSource);
            final cubit = HomeCubit(homeRepository: repository);

            // Load users on initialization
            cubit.loadUsers();

            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final apiClient = ApiClient();
            final storyDataSource = StoryDataSourceImpl(apiClient: apiClient);
            final storyRepository = StoryRepositoryImpl(
              dataSource: storyDataSource,
            );
            return StoryCubit(storyRepository: storyRepository);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorPalette.homeMainBg,
        extendBody: true,
        body: _buildCurrentScreen(),
        bottomNavigationBar: CustomFluidBottomNavWidget(
          currentIndex: _currentScreenIndex,
          onTap: _handleNavigationChange,
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreenIndex) {
      case 0: // Home
        return _buildHomeScreen();
      case 1: // Events
        return _buildEventsScreen();
      case 2: // Chat
        return _buildChatScreen();
      case 3: // Community
        return _buildCommunityScreen();
      case 4: // Profile
        return _buildProfileScreen();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    return Stack(
      children: [
        // Background content (dark blue header and light grey content)
        Column(
          children: [
            // Home Header Section (Dark Blue)
            Container(
              height: 230.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ColorPalette.homeHeaderBg,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: const HomeHeaderWidget(),
            ),

            // Home Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                color: ColorPalette.homeMainBg,
                child: SingleChildScrollView(
                  child: Column(children: [const HomeActivityGridWidget()]),
                ),
              ),
            ),
          ],
        ),

        // Positioned HomeTabSelectorWidget to overlap between header and content
        Positioned(
          top: 270.h - 66.h, // Header height - offset for overlap
          left:
              (MediaQuery.of(context).size.width - 363.w) /
              2, // Center horizontally
          child: Container(
            width: 370.w,
            height: 57.h,
            child: const HomeTabSelectorWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildChatScreen() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: ColorPalette.homeMainBg,
      child: Column(
        children: [
          // Chat Header
          Container(
            height: 100.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: ColorPalette.homeHeaderBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: const SafeArea(
              child: Center(
                child: Text(
                  'Chat',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Chat Content
          Expanded(
            child: Container(
              width: double.infinity,
              color: ColorPalette.homeMainBg,
              child: const Center(
                child: Text(
                  'Chat Content',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityScreen() {
    return Tal3aVibesFeature.getTal3aVibesScreen();
  }

  Widget _buildProfileScreen() {
    // Show Settings content within the Home screen (keeps bottom nav bar)
    return SettingsAndProfileFeature.getSettingsContent();
  }

  Widget _buildEventsScreen() {
    return EventsFeature.getEventsScreen();
  }
}
