import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../../../../core/routing/navigation_helper.dart';
import '../../../controllers/biking_cubit.dart';
import '../../../controllers/biking_state.dart';
import '../../../../data/models/biking_type_model.dart';

class BikingChooseTypeFormWidget extends StatelessWidget {
  const BikingChooseTypeFormWidget({super.key});

  // Static biking types data
  static const List<BikingTypeModel> _bikingTypes = [
    BikingTypeModel(id: 'one_on_one', name: '1-on-1'),
    BikingTypeModel(id: 'group', name: 'Group'),
  ];

  void _selectBikingType(BuildContext context, BikingTypeModel bikingType) {
    // Update BikingCubit with selected biking type
    context.read<BikingCubit>().selectBikingType(bikingType);
  }

  void _continue(BuildContext context) {
    final bikingCubit = context.read<BikingCubit>();
    final selectedBikingType = bikingCubit.state.selectedBikingType;
    if (selectedBikingType != null) {
      // Add navigation history
      bikingCubit.addNavigationNode(
        'BikingChooseTypeScreen',
        data: {'selectedBikingType': selectedBikingType.toJson()},
      );

      // Navigate based on selected biking type
      if (selectedBikingType.id == 'group') {
        // Navigate to group flow
        NavigationHelper.goToBikingGroupChooseType(context, cubit: bikingCubit);
      } else {
        // Navigate to 1-on-1 flow (existing gender screen)
        NavigationHelper.goToBikingChooseGender(context, cubit: bikingCubit);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        final selectedBikingType = state.selectedBikingType;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'How Do You Want to Bike?',
                style: AppTextStyles.activityTypeTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Biking Type Cards with staggered animations
            Row(
              children:
                  _bikingTypes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final bikingType = entry.value;
                    final isSelected = selectedBikingType?.id == bikingType.id;

                    return Expanded(
                      child: AnimationHelper.leftCardAnimation(
                        index: index,
                        child: GestureDetector(
                          onTap: () => _selectBikingType(context, bikingType),
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
                                      _getBikingTypeIconPath(bikingType.id),
                                      width: 40,
                                      height: 40,
                                      color: Color(
                                        isSelected ? 0xFFFFFFFF : 0xFF9BA8AF,
                                      ),
                                    ),
                                  ),
                                ),

                                // Biking type name with color transition
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style:
                                      isSelected
                                          ? AppTextStyles
                                              .activityCardSelectedTextStyle
                                          : AppTextStyles.activityCardTextStyle,
                                  child: Text(
                                    bikingType.name,
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
                text: 'Continue',
                onPressed:
                    selectedBikingType != null
                        ? () => _continue(context)
                        : null,
                isEnabled: selectedBikingType != null,
              ),
              delay: Duration(milliseconds: 400),
            ),
          ],
        );
      },
    );
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
}
