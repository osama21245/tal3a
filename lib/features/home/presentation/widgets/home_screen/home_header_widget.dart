import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/core/controller/user_controller.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../story/presentation/controllers/story_cubit.dart';
import '../../../../story/presentation/controllers/story_state.dart';
import '../../../../../core/routing/routes.dart';

class HomeHeaderWidget extends StatefulWidget {
  const HomeHeaderWidget({super.key});

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  @override
  void initState() {
    super.initState();
    // Load users with stories when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryCubit>().loadUsersWithStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserController>().state.user;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // Status Bar
          SizedBox(height: 10),
          // Main Header Content
          Row(
            children: [
              // Date and Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.getCurrentDateFormatted(context),
                      style: AppTextStyles.homeDateStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'home.good_morning'.tr(),
                      style: AppTextStyles.homeGreetingStyle,
                    ),
                  ],
                ),
              ),

              // Notification and Profile Buttons
              Row(
                children: [
                  // Notification Button
                  Container(
                    padding: EdgeInsets.only(top: 14, bottom: 4),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ColorPalette.homeNotificationBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/notification-bing.svg',
                      width: 21,
                      height: 21,
                      color: ColorPalette.homeTabActive,
                    ),
                  ),

                  const SizedBox(width: 7),

                  // Profile Button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage('assets/images/fitness_partner.png'),
                        // image: CachedNetworkImageProvider(
                        //   user?.profilePic ?? '',
                        // ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // User Profiles Section
          BlocBuilder<StoryCubit, StoryState>(
            builder: (context, state) {
              return _buildUserProfilesSection(state);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfilesSection(StoryState state) {
    return SizedBox(
      height: 200,
      width: double.infinity, // Increased height to prevent overflow
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add Button - Always on the left
            _buildAddButton(),

            // Show shimmer effect if loading
            if (state.isLoadingUsers) ...[
              SizedBox(width: 13),
              _buildShimmerStories(),
            ] else if (state.storyUsers.isEmpty) ...[
              SizedBox(width: 13),
            ] else ...[
              // Show real users from API with minimal spacing
              for (int i = 0; i < state.storyUsers.length; i++) ...[
                SizedBox(width: 13),
                _buildUserProfile(
                  state.storyUsers[i].id,
                  state.storyUsers[i].profilePic,
                  state.storyUsers[i].fullName,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerStories() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Padding(
          padding: EdgeInsets.only(right: 13),
          child: _buildProfessionalShimmerItem(index),
        );
      }),
    );
  }

  Widget _buildProfessionalShimmerItem(int index) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          // Profile picture shimmer with professional gradient
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.12),
            highlightColor: Colors.white.withOpacity(0.9),
            period: Duration(milliseconds: 1000 + (index * 200)),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.15),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Name shimmer with professional gradient
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.12),
            highlightColor: Colors.white.withOpacity(0.9),
            period: Duration(milliseconds: 1000 + (index * 200)),
            child: Container(
              width: 50,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _navigateToCamera(),
      child: SizedBox(
        width: 64, // Fixed width to match other items
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: ColorPalette.homeTabActive,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x6D47B8FF).withOpacity(0.12),
                    offset: const Offset(0, 1),
                    blurRadius: 5,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(Icons.add, color: ColorPalette.textWhite, size: 28),
            ),
            const SizedBox(height: 5),
            Text(
              'home.add'.tr(),
              style: AppTextStyles.homeProfileNameStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(String userId, String? imagePath, String name) {
    return SizedBox(
      width: 64, // Fixed width to prevent horizontal expansion
      child: GestureDetector(
        onTap: () => _navigateToUserStories(userId, name, imagePath),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent),
          ),
          child: Column(
            children: [
              Container(
                width: 64, // Match the add button size
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorPalette.homeProfileBorder,
                    width: 2,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        imagePath != null
                            ? DecorationImage(
                              image: NetworkImage(imagePath),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                // Handle network image error
                              },
                            )
                            : null,
                    color:
                        imagePath == null ? Colors.grey.withOpacity(0.3) : null,
                  ),
                  child:
                      imagePath == null
                          ? Icon(Icons.person, color: Colors.white, size: 32)
                          : null,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                name,
                style: AppTextStyles.homeProfileNameStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToUserStories(
    String userId,
    String userName,
    String? userProfilePic,
  ) {
    Navigator.of(context).pushNamed(
      Routes.storyViewOthersScreen,
      arguments: {
        'userId': userId,
        'userName': userName,
        'userProfilePic': userProfilePic,
      },
    );
  }

  void _navigateToCamera() {
    Navigator.of(context).pushNamed(Routes.storyCameraScreen);
  }
}
