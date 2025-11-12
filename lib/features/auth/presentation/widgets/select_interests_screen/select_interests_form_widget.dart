import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/const/dimentions.dart';
import 'package:tal3a/core/routing/routes.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/utils/animation_helper.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/controller/profile_setup_controller.dart';

class SelectInterestsFormWidget extends StatefulWidget {
  const SelectInterestsFormWidget({super.key});

  @override
  State<SelectInterestsFormWidget> createState() =>
      _SelectInterestsFormWidgetState();
}

class _SelectInterestsFormWidgetState extends State<SelectInterestsFormWidget> {
  final Set<String> selectedInterests = <String>{};

  // Interest data with exact Figma icons and labels
  final List<Map<String, dynamic>> interests = [
    {
      'id': 'jogging',
      'label': 'Jogging',
      'icon': 'assets/icons/jogging_icon.svg',
    },
    {
      'id': 'walking',
      'label': 'Walking',
      'icon': 'assets/icons/walking_icon.svg',
    },
    {'id': 'hiking', 'label': 'Hiking', 'icon': 'assets/icons/hiking_icon.svg'},
    {
      'id': 'skating',
      'label': 'Skating',
      'icon': 'assets/icons/skating_icon.svg',
    },
    {'id': 'biking', 'label': 'Biking', 'icon': 'assets/icons/biking_icon.svg'},
    {
      'id': 'weightlift',
      'label': 'Weightlift',
      'icon': 'assets/icons/weightlift_icon.svg',
    },
    {'id': 'cardio', 'label': 'Cardio', 'icon': 'assets/icons/cardio_icon.svg'},
    {'id': 'yoga', 'label': 'Yoga', 'icon': 'assets/icons/yoga_icon.svg'},
    {'id': 'other', 'label': 'Other', 'icon': 'assets/icons/other_icon.svg'},
  ];

  void _toggleInterest(String interestId) {
    setState(() {
      if (selectedInterests.contains(interestId)) {
        selectedInterests.remove(interestId);
      } else {
        selectedInterests.add(interestId);
      }
    });

    // Update the profile setup controller with proper interest labels
    final interestLabels =
        selectedInterests.map((id) {
          // Map interest IDs to proper labels for API
          switch (id) {
            case 'jogging':
              return 'Jogging';
            case 'walking':
              return 'Walking';
            case 'hiking':
              return 'Hiking';
            case 'skating':
              return 'Skating';
            case 'biking':
              return 'Biking';
            case 'weightlift':
              return 'WeightLift';
            case 'cardio':
              return 'Cardio';
            case 'yoga':
              return 'Yoga';
            case 'other':
              return 'Other';
            default:
              return id;
          }
        }).toList();

    context.read<ProfileSetupController>().setInterests(interestLabels);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          AnimationHelper.fadeIn(
            child: Padding(
              padding: EdgeInsets.only(
                left: Dimensions.paddingSmall,
                top: Dimensions.paddingSmall,
              ),
              child: Text(
                'My Interests',
                style: AppTextStyles.interestsSubtitleStyle,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Interest Cards Grid
          Column(
            children: [
              // First Row
              Row(
                children: [
                  Expanded(
                    child: AnimationHelper.leftCardAnimation(
                      index: 1,
                      child: _buildInterestCard(interests[0]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AnimationHelper.cardAnimation(
                      index: 2,
                      child: _buildInterestCard(interests[1]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AnimationHelper.rightCardAnimation(
                      index: 3,
                      child: _buildInterestCard(interests[2]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Second Row
              Row(
                children: [
                  Expanded(
                    child: AnimationHelper.leftCardAnimation(
                      index: 4,
                      child: _buildInterestCard(interests[3]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AnimationHelper.cardAnimation(
                      index: 5,
                      child: _buildInterestCard(interests[4]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AnimationHelper.rightCardAnimation(
                      index: 6,
                      child: _buildInterestCard(interests[5]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Third Row
              Row(
                children: [
                  Expanded(
                    child: AnimationHelper.leftCardAnimation(
                      index: 7,
                      child: _buildInterestCard(interests[6]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AnimationHelper.cardAnimation(
                      index: 8,
                      child: _buildInterestCard(interests[7]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AnimationHelper.rightCardAnimation(
                      index: 9,
                      child: _buildInterestCard(interests[8]),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 100.h),

          // Continue Button
          AnimationHelper.slideUp(
            child: PrimaryButtonWidget(
              text: 'Continue',
              onPressed:
                  selectedInterests.isNotEmpty
                      ? () {
                        Navigator.of(
                          context,
                        ).pushNamed(Routes.selectGenderScreen);
                      }
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestCard(Map<String, dynamic> interest) {
    final isSelected = selectedInterests.contains(interest['id']);

    return GestureDetector(
      onTap: () => _toggleInterest(interest['id']),
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 115.h,
          decoration: BoxDecoration(
            color:
                isSelected
                    ? ColorPalette.interestCardSelected
                    : ColorPalette.interestCardBg,
            borderRadius: BorderRadius.circular(14),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: ColorPalette.interestCardSelected.withValues(
                          alpha: 0.35,
                        ),
                        blurRadius: 0,
                        offset: Offset.zero,
                        spreadRadius: 4,
                      ),
                    ]
                    : null,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              SizedBox(
                width: 48.w,
                height: 48,
                child: SvgPicture.asset(
                  interest['icon'],
                  width: 48.w,
                  height: 48,
                  color: Color(isSelected ? 0xFFFFFFFF : 0xFF9BA8AF),
                ),
              ),

              const SizedBox(height: 8),

              // Label
              Text(
                overflow: TextOverflow.ellipsis,
                interest['label'],
                style:
                    isSelected
                        ? AppTextStyles.interestCardSelectedTextStyle
                        : AppTextStyles.interestCardTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
