import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../controllers/biking_cubit.dart';
import '../../../controllers/biking_state.dart';
import '../../../../data/models/biking_gender_model.dart';
import '../../../screens/biking/biking_choose_friend_screen.dart';

class BikingChooseGenderFormWidget extends StatelessWidget {
  const BikingChooseGenderFormWidget({super.key});

  // Static biking genders data
  static const List<BikingGenderModel> _bikingGenders = [
    BikingGenderModel(id: 'man', name: 'Man'),
    BikingGenderModel(id: 'woman', name: 'Woman'),
  ];

  void _selectBikingGender(
    BuildContext context,
    BikingGenderModel bikingGender,
  ) {
    context.read<BikingCubit>().selectBikingGender(bikingGender);
  }

  void _continue(BuildContext context) {
    final bikingCubit = context.read<BikingCubit>();
    final selectedBikingGender = bikingCubit.state.selectedBikingGender;
    if (selectedBikingGender != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: bikingCubit,
                child: const BikingChooseFriendScreen(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        final selectedBikingGender = state.selectedBikingGender;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'With Who?',
                style: AppTextStyles.activityTypeTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Biking Gender Cards with staggered animations
            Row(
              children:
                  _bikingGenders.asMap().entries.map((entry) {
                    final index = entry.key;
                    final bikingGender = entry.value;
                    final isSelected =
                        selectedBikingGender?.id == bikingGender.id;

                    return Expanded(
                      child: AnimationHelper.rightCardAnimation(
                        index: index,
                        child: GestureDetector(
                          onTap:
                              () => _selectBikingGender(context, bikingGender),
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
                                      _getBikingGenderIconPath(bikingGender.id),
                                      width: 40,
                                      height: 40,
                                      color: Color(
                                        isSelected ? 0xFFFFFFFF : 0xFF9BA8AF,
                                      ),
                                    ),
                                  ),
                                ),

                                // Biking gender name with color transition
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style:
                                      isSelected
                                          ? AppTextStyles
                                              .activityCardSelectedTextStyle
                                          : AppTextStyles.activityCardTextStyle,
                                  child: Text(
                                    bikingGender.name,
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

            SizedBox(height: 200.h),

            // Continue Button with fade-in animation
            AnimationHelper.slideUp(
              child: PrimaryButtonWidget(
                text: 'Continue',
                onPressed:
                    selectedBikingGender != null
                        ? () => _continue(context)
                        : null,
                isEnabled: selectedBikingGender != null,
              ),
            ),
          ],
        );
      },
    );
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
}
