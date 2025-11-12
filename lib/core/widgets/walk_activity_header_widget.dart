import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import 'package:tal3a/features/activites/data/models/walk_friend_model.dart';
import 'package:tal3a/features/activites/data/models/walk_gender_model.dart';
import 'package:tal3a/features/activites/data/models/walk_type_model.dart';
import 'package:tal3a/features/activites/data/models/group_type_model.dart';
import 'package:tal3a/features/activites/data/models/group_location_model.dart';
import 'package:tal3a/features/activites/data/models/group_time_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_state.dart';

class WalkActivityHeaderWidget extends StatelessWidget {
  final String title;
  final String? tal3aType;
  final bool showTal3aType;
  final bool showProgressBar;
  final int activeSteps;
  final VoidCallback? onBackPressed;

  const WalkActivityHeaderWidget({
    super.key,
    required this.title,
    this.tal3aType,
    this.showTal3aType = false,
    this.showProgressBar = false,
    this.activeSteps = 1,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      width: double.infinity,
      color: ColorPalette.forgotPasswordBg,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h), // Top padding
            // Back Button
            GestureDetector(
              onTap: () {
                print('Back button tapped');
                _handleBackButton(context);
              },
              child: Container(
                width: 48,
                height: 48.h,
                child: Center(
                  child: Image.asset(
                    'assets/icons/back_button.png',
                    width: 48,
                    height: 48.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // Title
            Text(title, style: AppTextStyles.trainingTitleStyle),

            SizedBox(height: 10.h),

            // Progress Indicators (conditionally rendered)
            Opacity(
              opacity: showProgressBar ? 1.0 : 0.0,
              child: Row(
                children: [
                  // Active step indicator (blue) - Vector 1
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 1
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Active step indicator - Vector 2
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 2
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Active step indicator - Vector 3
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 3
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  // Active step indicator - Vector 4
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 4
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 29.h),

            // Tal3a Type Section (conditionally rendered)
            if (showTal3aType) ...[
              _buildTal3aTypeSection(),
              SizedBox(height: 20.h),
            ],

            const Spacer(), // Push content to top
          ],
        ),
      ),
    );
  }

  Widget _buildTal3aTypeSection() {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        final walkTypeData = state.selectedWalkType;
        final walkGenderData = state.selectedWalkGender;
        final walkFriendData = state.selectedWalkFriend;

        // Group data
        final groupTypeData = state.selectedGroupType;
        final groupLocationData = state.selectedGroupLocation;
        final groupTimeData = state.selectedGroupTime;

        // Determine if we're in group flow
        final isGroupFlow = walkTypeData?.id == 'group';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tal3a Type', style: AppTextStyles.tal3aTypeLabelStyle),

            SizedBox(height: 9.h),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildDynamicNodes(
                    walkTypeData,
                    walkGenderData,
                    walkFriendData,
                    groupTypeData,
                    groupLocationData,
                    groupTimeData,
                    isGroupFlow,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildDynamicNodes(
    WalkTypeModel? walkTypeData,
    WalkGenderModel? walkGenderData,
    WalkFriendModel? walkFriendData,
    GroupTypeModel? groupTypeData,
    GroupLocationModel? groupLocationData,
    GroupTimeModel? groupTimeData,
    bool isGroupFlow,
  ) {
    List<Widget> nodes = [];

    // Always add "Walking" as the tal3a type
    nodes.add(_buildTal3aTypeCard());

    // Add Walk Type Card if available (1-on-1 or Group)
    if (walkTypeData != null) {
      nodes.add(_buildWalkTypeCard(walkTypeData));
    }

    if (isGroupFlow) {
      // Group flow: Add Group Type, Location, Time
      if (groupTypeData != null) {
        nodes.add(_buildGroupTypeCard(groupTypeData));
      }
      if (groupLocationData != null) {
        nodes.add(_buildGroupLocationCard(groupLocationData));
      }
      if (groupTimeData != null) {
        nodes.add(_buildGroupTimeCard(groupTimeData));
      }
    } else {
      // 1-on-1 flow: Add Gender and Friend
      if (walkGenderData != null) {
        nodes.add(_buildWalkGenderCard(walkGenderData));
      }
      if (walkFriendData != null) {
        nodes.add(_buildWalkFriendCard(walkFriendData));
      }
    }

    // Add separator lines between all nodes with animations
    List<Widget> result = [];
    for (int i = 0; i < nodes.length; i++) {
      // Add animated node using AnimationHelper
      result.add(AnimationHelper.nodeAnimation(child: nodes[i], index: i));

      // Add separator line after each node (except the last one)
      if (i < nodes.length - 1) {
        result.add(SizedBox(width: 10.w));
        result.add(
          AnimationHelper.separatorAnimation(
            child: _buildSeparatorLine(),
            index: i,
          ),
        );
        result.add(SizedBox(width: 10.w));
      }
    }

    return result;
  }

  Widget _buildTal3aTypeCard() {
    return Container(
      width: 52.w,
      height: 55.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorPalette.tal3aTypeBg.withOpacity(0.35),
            offset: const Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 2,
          ),
        ],
        color: ColorPalette.tal3aTypeBg,
        borderRadius: BorderRadius.circular(6.7.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Image
          Container(
            width: 23.w,
            height: 23.h,
            child: SvgPicture.asset(
              'assets/icons/1on1.svg',
              width: 20,
              height: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),

          // Tal3a Type Text
          Text(
            'Walking',
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSeparatorLine() {
    return Container(
      height: 55.h,
      child: Center(
        child: Container(width: 17, height: 1.3, color: Colors.white),
      ),
    );
  }

  Widget _buildWalkTypeCard(WalkTypeModel walkTypeData) {
    return Container(
      width: 52.w,
      height: 55.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorPalette.tal3aTypeBg.withOpacity(0.35),
            offset: const Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 2,
          ),
        ],
        color: ColorPalette.tal3aTypeBg,
        borderRadius: BorderRadius.circular(6.7.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Image
          Container(
            width: 23.w,
            height: 23.h,
            child: SvgPicture.asset(
              _getWalkTypeIconPath(walkTypeData.id),
              width: 20,
              height: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),

          SizedBox(height: 4.h),

          // Walk Type Text
          Text(
            walkTypeData.name,
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWalkGenderCard(WalkGenderModel walkGenderData) {
    return Container(
      width: 52.w,
      height: 55.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorPalette.tal3aTypeBg.withOpacity(0.35),
            offset: const Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 2,
          ),
        ],
        color: ColorPalette.tal3aTypeBg,
        borderRadius: BorderRadius.circular(6.7.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Image
          Container(
            width: 23.w,
            height: 23.h,
            child: SvgPicture.asset(
              _getWalkGenderIconPath(walkGenderData.id),
              width: 20,
              height: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),

          // Walk Gender Text
          Text(
            walkGenderData.name,
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWalkFriendCard(WalkFriendModel walkFriendData) {
    return Container(
      width: 153.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: ColorPalette.coachCardSelected,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          // Left shadow
          BoxShadow(
            color: ColorPalette.coachCardSelected.withOpacity(0.35),
            offset: const Offset(-4, 0),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          // Right shadow
          BoxShadow(
            color: ColorPalette.coachCardSelected.withOpacity(0.35),
            offset: const Offset(4, 0),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          // Top shadow
          BoxShadow(
            color: ColorPalette.coachCardSelected.withOpacity(0.35),
            offset: const Offset(0, -4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          // Bottom shadow
          BoxShadow(
            color: ColorPalette.coachCardSelected.withOpacity(0.35),
            offset: const Offset(0, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Friend Image
          Container(
            width: 50.w,
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child:
                  walkFriendData.imageUrl != null
                      ? Image.asset(walkFriendData.imageUrl!, fit: BoxFit.cover)
                      : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
            ),
          ),

          // Friend Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFriendNameWithDifferentWeights(walkFriendData.name),
                  const SizedBox(height: 1),
                  Text(
                    '${walkFriendData.age} years • ${walkFriendData.weight}kg',
                    style: AppTextStyles.coachTitleSelectedStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Group flow cards
  Widget _buildGroupTypeCard(GroupTypeModel groupTypeData) {
    return Container(
      width: 52.w,
      height: 55.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorPalette.tal3aTypeBg.withOpacity(0.35),
            offset: const Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 2,
          ),
        ],
        color: ColorPalette.tal3aTypeBg,
        borderRadius: BorderRadius.circular(6.7.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 23.w,
            height: 23.h,
            child: SvgPicture.asset(
              groupTypeData.iconPath,
              width: 20,
              height: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),

          SizedBox(height: 4.h),

          // Group Type Text
          Text(
            groupTypeData.name,
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupLocationCard(GroupLocationModel groupLocationData) {
    return Container(
      width: 52.w,
      height: 55.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorPalette.tal3aTypeBg.withOpacity(0.35),
            offset: const Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 2,
          ),
        ],
        color: ColorPalette.tal3aTypeBg,
        borderRadius: BorderRadius.circular(6.7.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 23.w,
            height: 23.h,
            child: Icon(Icons.location_on, color: Colors.white, size: 20),
          ),

          SizedBox(height: 4.h),

          // Location Text (shortened)
          Text(
            _shortenLocationName(groupLocationData.name),
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTimeCard(GroupTimeModel groupTimeData) {
    return Container(
      width: 52.w,
      height: 55.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorPalette.tal3aTypeBg.withOpacity(0.35),
            offset: const Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 2,
          ),
        ],
        color: ColorPalette.tal3aTypeBg,
        borderRadius: BorderRadius.circular(6.7.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 23.w,
            height: 23.h,
            child: Icon(Icons.access_time, color: Colors.white, size: 20),
          ),

          SizedBox(height: 4.h),

          // Time Text
          Text(
            groupTimeData.timeSlot,
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFriendNameWithDifferentWeights(String name) {
    // Parse the name to identify different parts
    // Example: "Capt.george n." -> "Capt." (light), "george" (bold), " n." (light)
    final parts = _parseFriendName(name);

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children:
            parts.map((part) {
              return TextSpan(
                text: part.text,
                style:
                    part.isBold
                        ? AppTextStyles.coachNameBoldStyle
                        : AppTextStyles.coachNameLightStyle,
              );
            }).toList(),
      ),
    );
  }

  List<_NamePart> _parseFriendName(String name) {
    // Super simple: Just two parts - "Capt." (light) and everything else (bold)

    if (name.toLowerCase().startsWith('capt.')) {
      final withoutCapt = name.substring(5).trim(); // Remove "Capt." and trim
      return [
        _NamePart('Capt.', false), // "Capt." (light)
        _NamePart(withoutCapt, true), // Everything else (bold)
      ];
    }

    // Fallback: if no "Capt.", make the whole name bold
    return [_NamePart(name, true)];
  }

  String _getWalkTypeIconPath(String walkTypeId) {
    switch (walkTypeId) {
      case 'one_on_one':
        return 'assets/icons/1on1.svg';
      case 'group':
        return 'assets/icons/group.svg';
      default:
        return 'assets/icons/1on1.svg';
    }
  }

  String _getWalkGenderIconPath(String walkGenderId) {
    switch (walkGenderId) {
      case 'man':
        return 'assets/icons/male.svg';
      case 'woman':
        return 'assets/icons/female.svg';
      default:
        return 'assets/icons/male.svg';
    }
  }

  String _shortenLocationName(String locationName) {
    // Shorten long location names to fit in the small card
    if (locationName.length > 8) {
      return locationName.substring(0, 8);
    }
    return locationName;
  }

  void _handleBackButton(BuildContext context) {
    final walkCubit = context.read<WalkCubit>();
    final state = walkCubit.state;

    print('Back button pressed - Current state:');
    print('Walk Type: ${state.selectedWalkType?.name}');
    print('Walk Gender: ${state.selectedWalkGender?.name}');
    print('Walk Friend: ${state.selectedWalkFriend?.name}');
    print('Walk Time: ${state.selectedWalkTime?.timeSlot}');
    print('Group Type: ${state.selectedGroupType?.name}');
    print('Group Location: ${state.selectedGroupLocation?.name}');
    print('Group Time: ${state.selectedGroupTime?.timeSlot}');

    try {
      // Determine if we're in group flow
      final isGroupFlow = state.selectedWalkType?.id == 'group';

      if (isGroupFlow) {
        // Group flow back button logic
        if (state.selectedGroupTime != null) {
          print('Clearing group time selection');
          walkCubit.clearGroupTime();
        } else if (state.selectedGroupLocation != null) {
          print(
            'Clearing group location selection and navigating to location screen',
          );
          walkCubit.clearGroupLocation();
          Navigator.of(context).pop();
        } else if (state.selectedGroupType != null) {
          print(
            'Clearing group type selection and navigating to group type screen',
          );
          walkCubit.clearGroupType();
          Navigator.of(context).pop();
        } else if (state.selectedWalkType != null) {
          print(
            'Clearing walk type selection and navigating to walk type screen',
          );
          walkCubit.clearWalkType();
          Navigator.of(context).pop();
        } else {
          print('Nothing selected, popping navigation');
          Navigator.of(context).pop();
        }
      } else {
        // 1-on-1 flow back button logic
        if (state.selectedWalkTime != null) {
          print('Clearing walk time selection');
          walkCubit.clearWalkTime();
        } else if (state.selectedWalkFriend != null) {
          print('Clearing friend selection and navigating to friend screen');
          walkCubit.clearWalkFriend();
          Navigator.of(context).pop();
        } else if (state.selectedWalkGender != null) {
          print('Clearing gender selection and navigating to gender screen');
          walkCubit.clearWalkGender();
          Navigator.of(context).pop();
        } else if (state.selectedWalkType != null) {
          print('Clearing walk type selection and navigating to type screen');
          walkCubit.clearWalkType();
          Navigator.of(context).pop();
        } else {
          print('Nothing selected, popping navigation');
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print('Error in back button: $e');
      // Fallback: just pop navigation
      Navigator.of(context).pop();
    }
  }
}

class _NamePart {
  final String text;
  final bool isBold;

  _NamePart(this.text, this.isBold);
}
