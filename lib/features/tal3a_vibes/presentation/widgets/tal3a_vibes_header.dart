import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/routing/routes.dart';
import 'package:tal3a/features/story/presentation/controllers/story_cubit.dart';
import 'package:tal3a/features/story/presentation/controllers/story_state.dart';

class Tal3aVibesHeader extends StatefulWidget {
  const Tal3aVibesHeader({super.key, required this.title});
  final String title;

  @override
  State<Tal3aVibesHeader> createState() => _Tal3aVibesHeaderState();
}

class _Tal3aVibesHeaderState extends State<Tal3aVibesHeader> {
  @override
  void initState() {
    // Load users with stories when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryCubit>().loadUsersWithStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 229.h,
      width: double.infinity,
      decoration: BoxDecoration(color: ColorPalette.tal3aVibesHeaderBg),
      child: Stack(
        children: [
          Positioned(
            bottom: -150,
            right: -270,
            child: SvgPicture.asset(
              'assets/icons/high_five_icon.svg',
              width: 350.w,
              height: 350.h,
              color: Color(0xFF354F5C),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20, top: 50,bottom: 0),
            child: Column(
              children: [
                Container(
                  height: 72.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          widget.title,
                          style: AppTextStyles.trainingAppBarTitleStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<StoryCubit, StoryState>(
                  builder: (context, state) {
                    return _buildUserProfilesSection(state);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfilesSection(StoryState state) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAddButton(),
            if (state.isLoadingUsers) ...[
              SizedBox(width: 13),
              _buildShimmerStories(),
            ] else if (state.storyUsers.isEmpty) ...[
              SizedBox(width: 13),
            ] else ...[
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
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white.withOpacity(0.9),
            period: Duration(milliseconds: 1000 + (index * 200)),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Name shimmer with professional gradient
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white.withOpacity(0.9),
            period: Duration(milliseconds: 1000 + (index * 200)),
            child: Container(
              width: 50,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey,
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
