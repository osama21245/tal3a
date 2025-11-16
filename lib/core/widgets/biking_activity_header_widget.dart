import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import 'package:tal3a/features/activites/data/models/biking_friend_model.dart';
import 'package:tal3a/features/activites/data/models/biking_gender_model.dart';
import 'package:tal3a/features/activites/data/models/biking_type_model.dart';
import 'package:tal3a/features/activites/data/models/biking_group_type_model.dart';
import 'package:tal3a/features/activites/data/models/biking_group_location_model.dart';
import 'package:tal3a/features/activites/data/models/biking_group_time_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_state.dart';

class BikingActivityHeaderWidget extends StatelessWidget {
  final String title;
  final String? tal3aType;
  final bool showTal3aType;
  final bool showProgressBar;
  final int activeSteps;
  final VoidCallback? onBackPressed;

  const BikingActivityHeaderWidget({
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
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Container(
      height: screenHeight,
      width: double.infinity,
      color: ColorPalette.forgotPasswordBg,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: statusBarHeight - 30), // Top padding
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
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        final bikingTypeData = state.selectedBikingType;
        final bikingGenderData = state.selectedBikingGender;
        final bikingFriendData = state.selectedBikingFriend;

        // Group data
        final bikingGroupTypeData = state.selectedBikingGroupType;
        final bikingGroupLocationData = state.selectedBikingGroupLocation;
        final bikingGroupTimeData = state.selectedBikingGroupTime;

        // Determine if we're in group flow
        final isGroupFlow = bikingTypeData?.id == 'group';

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
                    bikingTypeData,
                    bikingGenderData,
                    bikingFriendData,
                    bikingGroupTypeData,
                    bikingGroupLocationData,
                    bikingGroupTimeData,
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
    BikingTypeModel? bikingTypeData,
    BikingGenderModel? bikingGenderData,
    BikingFriendModel? bikingFriendData,
    BikingGroupTypeModel? bikingGroupTypeData,
    BikingGroupLocationModel? bikingGroupLocationData,
    BikingGroupTimeModel? bikingGroupTimeData,
    bool isGroupFlow,
  ) {
    List<Widget> nodes = [];

    // Always add "Biking" as the tal3a type
    nodes.add(_buildTal3aTypeCard());

    // Add Biking Type Card if available (1-on-1 or Group)
    if (bikingTypeData != null) {
      nodes.add(_buildBikingTypeCard(bikingTypeData));
    }

    if (isGroupFlow) {
      // Group flow: Add Group Type, Location, Time
      if (bikingGroupTypeData != null) {
        nodes.add(_buildBikingGroupTypeCard(bikingGroupTypeData));
      }
      if (bikingGroupLocationData != null) {
        nodes.add(_buildBikingGroupLocationCard(bikingGroupLocationData));
      }
      if (bikingGroupTimeData != null) {
        nodes.add(_buildBikingGroupTimeCard(bikingGroupTimeData));
      }
    } else {
      // 1-on-1 flow: Add Gender and Friend
      if (bikingGenderData != null) {
        nodes.add(_buildBikingGenderCard(bikingGenderData));
      }
      if (bikingFriendData != null) {
        nodes.add(_buildBikingFriendCard(bikingFriendData));
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
              'assets/icons/1on1biking.svg',
              width: 20,
              height: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),

          // Tal3a Type Text
          Text(
            'Biking',
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

  Widget _buildBikingTypeCard(BikingTypeModel bikingTypeData) {
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
              _getBikingTypeIconPath(bikingTypeData.id),
              width: 20,
              height: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),

          SizedBox(height: 4.h),

          // Biking Type Text
          Text(
            bikingTypeData.name,
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBikingGenderCard(BikingGenderModel bikingGenderData) {
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
              _getBikingGenderIconPath(bikingGenderData.id),
              width: 20,
              height: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),

          // Biking Gender Text
          Text(
            bikingGenderData.name,
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBikingFriendCard(BikingFriendModel bikingFriendData) {
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
                  bikingFriendData.imageUrl != null
                      ? Image.network(
                        bikingFriendData.imageUrl!,
                        fit: BoxFit.cover,
                      )
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
                  _buildFriendNameWithDifferentWeights(bikingFriendData.name),
                  const SizedBox(height: 1),
                  Text(
                    '${bikingFriendData.age} years • ${bikingFriendData.weight}kg',
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
  Widget _buildBikingGroupTypeCard(BikingGroupTypeModel bikingGroupTypeData) {
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
              bikingGroupTypeData.iconPath,
              width: 20,
              height: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),

          SizedBox(height: 4.h),

          // Group Type Text
          Text(
            bikingGroupTypeData.name,
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBikingGroupLocationCard(
    BikingGroupLocationModel bikingGroupLocationData,
  ) {
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
            _shortenLocationName(bikingGroupLocationData.name),
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBikingGroupTimeCard(BikingGroupTimeModel bikingGroupTimeData) {
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
            bikingGroupTimeData.timeSlot,
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

  String _getBikingTypeIconPath(String bikingTypeId) {
    switch (bikingTypeId) {
      case 'one_on_one':
        return 'assets/icons/1on1biking.svg';
      case 'group':
        return 'assets/icons/groupbiking.svg';
      default:
        return 'assets/icons/1on1biking.svg';
    }
  }

  String _getBikingGenderIconPath(String bikingGenderId) {
    switch (bikingGenderId) {
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
    final bikingCubit = context.read<BikingCubit>();
    final state = bikingCubit.state;

    print('Back button pressed - Current state:');
    print('Biking Type: ${state.selectedBikingType?.name}');
    print('Biking Gender: ${state.selectedBikingGender?.name}');
    print('Biking Friend: ${state.selectedBikingFriend?.name}');
    print('Biking Time: ${state.selectedBikingTime?.timeSlot}');
    print('Biking Group Type: ${state.selectedBikingGroupType?.name}');
    print('Biking Group Location: ${state.selectedBikingGroupLocation?.name}');
    print('Biking Group Time: ${state.selectedBikingGroupTime?.timeSlot}');

    try {
      // Determine if we're in group flow
      final isGroupFlow = state.selectedBikingType?.id == 'group';

      if (isGroupFlow) {
        // Group flow back button logic
        if (state.selectedBikingGroupTime != null) {
          print('Clearing biking group time selection');
          bikingCubit.clearBikingGroupTime();
        } else if (state.selectedBikingGroupLocation != null) {
          print(
            'Clearing biking group location selection and navigating to location screen',
          );
          bikingCubit.clearBikingGroupLocation();
          Navigator.of(context).pop();
        } else if (state.selectedBikingGroupType != null) {
          print(
            'Clearing biking group type selection and navigating to group type screen',
          );
          bikingCubit.clearBikingGroupType();
          Navigator.of(context).pop();
        } else if (state.selectedBikingType != null) {
          print(
            'Clearing biking type selection and navigating to biking type screen',
          );
          bikingCubit.clearBikingType();
          Navigator.of(context).pop();
        } else {
          print('Nothing selected, popping navigation');
          Navigator.of(context).pop();
        }
      } else {
        // 1-on-1 flow back button logic
        if (state.selectedBikingTime != null) {
          print('Clearing biking time selection');
          bikingCubit.clearBikingTime();
        } else if (state.selectedBikingFriend != null) {
          print('Clearing friend selection and navigating to friend screen');
          bikingCubit.clearBikingFriend();
          Navigator.of(context).pop();
        } else if (state.selectedBikingGender != null) {
          print('Clearing gender selection and navigating to gender screen');
          bikingCubit.clearBikingGender();
          Navigator.of(context).pop();
        } else if (state.selectedBikingType != null) {
          print('Clearing biking type selection and navigating to type screen');
          bikingCubit.clearBikingType();
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
