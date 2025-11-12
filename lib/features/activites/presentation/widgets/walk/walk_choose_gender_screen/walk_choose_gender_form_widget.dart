import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../controllers/walk_cubit.dart';
import '../../../controllers/walk_state.dart';
import '../../../../data/models/walk_gender_model.dart';
import '../../../screens/walk/walk_choose_friend_screen.dart';

class WalkChooseGenderFormWidget extends StatelessWidget {
  const WalkChooseGenderFormWidget({super.key});

  // Static walk genders data
  List<WalkGenderModel> get _walkGenders => [
    WalkGenderModel(
      id: 'man',
      name: 'activities.man'.tr(),
      iconPath: 'assets/icons/male.svg',
    ),
    WalkGenderModel(
      id: 'woman',
      name: 'activities.woman'.tr(),
      iconPath: 'assets/icons/female.svg',
    ),
  ];

  void _selectWalkGender(BuildContext context, WalkGenderModel walkGender) {
    // Update WalkCubit with selected walk gender
    context.read<WalkCubit>().selectWalkGender(walkGender);
  }

  void _continue(BuildContext context) {
    final walkCubit = context.read<WalkCubit>();
    final selectedWalkGender = walkCubit.state.selectedWalkGender;
    if (selectedWalkGender != null) {
      // Add navigation history
      walkCubit.addNavigationNode(
        'WalkChooseGenderScreen',
        data: {'selectedWalkGender': selectedWalkGender.toJson()},
      );

      // Navigate to next screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: walkCubit,
                child: const WalkChooseFriendScreen(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        final selectedWalkGender = state.selectedWalkGender;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'activities.with_who'.tr(),
                style: AppTextStyles.activityTypeTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Walk Gender Cards with staggered animations
            Row(
              children:
                  _walkGenders.asMap().entries.map((entry) {
                    final index = entry.key;
                    final walkGender = entry.value;
                    final isSelected = selectedWalkGender?.id == walkGender.id;

                    return Expanded(
                      child: AnimationHelper.rightCardAnimation(
                        index: index,
                        child: GestureDetector(
                          onTap: () => _selectWalkGender(context, walkGender),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 115,
                            margin: const EdgeInsets.only(right: 13),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? ColorPalette.activityCardSelected
                                      : ColorPalette.activityCardBg,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: ColorPalette
                                              .activityCardSelected
                                              .withOpacity(0.35),
                                          offset: const Offset(0, 0),
                                          blurRadius: 0,
                                          spreadRadius: 4,
                                        ),
                                      ]
                                      : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Gender icon with rotation animation when selected
                                AnimatedRotation(
                                  turns: isSelected ? 0.1 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: AnimatedScale(
                                    scale: isSelected ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                        _getWalkGenderIconPath(walkGender.id),
                                        width: 48,
                                        height: 48,
                                        color: Color(
                                          isSelected ? 0xFFFFFFFF : 0xFF9BA8AF,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Walk gender name with color transition
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style:
                                      isSelected
                                          ? AppTextStyles
                                              .activityCardSelectedTextStyle
                                          : AppTextStyles.activityCardTextStyle,
                                  child: Text(
                                    walkGender.name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            SizedBox(height: 220.h),

            // Continue Button with fade-in animation
            AnimationHelper.slideUp(
              child: PrimaryButtonWidget(
                text: 'common.continue'.tr(),
                onPressed:
                    selectedWalkGender != null
                        ? () => _continue(context)
                        : null,
                isEnabled: selectedWalkGender != null,
              ),
              delay: Duration(milliseconds: 400),
            ),
          ],
        );
      },
    );
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
}
