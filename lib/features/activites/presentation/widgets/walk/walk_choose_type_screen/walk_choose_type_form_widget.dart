import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../controllers/walk_cubit.dart';
import '../../../controllers/walk_state.dart';
import '../../../../data/models/walk_type_model.dart';
import '../../../screens/walk/walk_choose_gender_screen.dart';
import '../../../screens/walk/group/group_choose_type_screen.dart';

class WalkChooseTypeFormWidget extends StatelessWidget {
  const WalkChooseTypeFormWidget({super.key});

  // Static walk types data
  List<WalkTypeModel> get _walkTypes => [
    WalkTypeModel(id: 'one_on_one', name: 'activities.one_on_one'.tr()),
    WalkTypeModel(id: 'group', name: 'activities.group'.tr()),
  ];

  void _selectWalkType(BuildContext context, WalkTypeModel walkType) {
    // Update WalkCubit with selected walk type
    context.read<WalkCubit>().selectWalkType(walkType);
  }

  void _continue(BuildContext context) {
    final walkCubit = context.read<WalkCubit>();
    final selectedWalkType = walkCubit.state.selectedWalkType;
    if (selectedWalkType != null) {
      // Add navigation history
      walkCubit.addNavigationNode(
        'WalkChooseTypeScreen',
        data: {'selectedWalkType': selectedWalkType.toJson()},
      );

      // Navigate based on selected walk type
      if (selectedWalkType.id == 'group') {
        // Navigate to group flow
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: walkCubit,
                  child: const GroupChooseTypeScreen(),
                ),
          ),
        );
      } else {
        // Navigate to 1-on-1 flow (existing gender screen)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: walkCubit,
                  child: const WalkChooseGenderScreen(),
                ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        final selectedWalkType = state.selectedWalkType;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'activities.how_do_you_want_to_walk'.tr(),
                style: AppTextStyles.activityTypeTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Walk Type Cards with staggered animations
            Row(
              children:
                  _walkTypes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final walkType = entry.value;
                    final isSelected = selectedWalkType?.id == walkType.id;

                    return Expanded(
                      child: AnimationHelper.leftCardAnimation(
                        index: index,
                        child: GestureDetector(
                          onTap: () => _selectWalkType(context, walkType),
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
                                // Icon with pulse animation when selected
                                AnimatedScale(
                                  scale: isSelected ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    child: SvgPicture.asset(
                                      _getWalkTypeIconPath(walkType.id),
                                      width: 40,
                                      height: 40,
                                      color: Color(
                                        isSelected ? 0xFFFFFFFF : 0xFF9BA8AF,
                                      ),
                                    ),
                                  ),
                                ),

                                // Walk type name with color transition
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style:
                                      isSelected
                                          ? AppTextStyles
                                              .activityCardSelectedTextStyle
                                          : AppTextStyles.activityCardTextStyle,
                                  child: Text(
                                    walkType.name,
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

            const SizedBox(height: 40),

            // Continue Button with fade-in animation
            AnimationHelper.slideUp(
              child: PrimaryButtonWidget(
                text: 'common.continue'.tr(),
                onPressed:
                    selectedWalkType != null ? () => _continue(context) : null,
                isEnabled: selectedWalkType != null,
              ),
              delay: Duration(milliseconds: 400),
            ),
          ],
        );
      },
    );
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
}
