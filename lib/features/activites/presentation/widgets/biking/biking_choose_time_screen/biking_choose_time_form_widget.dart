import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../controllers/biking_cubit.dart';
import '../../../controllers/biking_state.dart';
import '../../../../data/models/biking_time_model.dart';

class BikingChooseTimeFormWidget extends StatelessWidget {
  const BikingChooseTimeFormWidget({super.key});

  // Static biking times data
  static const List<BikingTimeModel> _bikingTimes = [
    BikingTimeModel(
      id: 'morning',
      timeSlot: '6:00 AM',
      description: 'Morning Bike',
    ),
    BikingTimeModel(
      id: 'evening',
      timeSlot: '6:00 PM',
      description: 'Evening Bike',
    ),
  ];

  void _selectBikingTime(BuildContext context, BikingTimeModel bikingTime) {
    context.read<BikingCubit>().selectBikingTime(bikingTime);
  }

  void _continue(BuildContext context) {
    // Here you would typically navigate to a confirmation screen or complete the flow
    final bikingCubit = context.read<BikingCubit>();
    final state = bikingCubit.state;

    // Show completion dialog or navigate to next screen
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Biking Setup Complete!'),
            content: Text(
              'You have successfully set up your biking session:\n'
              'Type: ${state.selectedBikingType?.name}\n'
              'Gender: ${state.selectedBikingGender?.name}\n'
              'Partner: ${state.selectedBikingFriend?.name}\n'
              'Time: ${state.selectedBikingTime?.timeSlot}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        final selectedBikingTime = state.selectedBikingTime;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'Choose Your Biking Time',
                style: AppTextStyles.activityTypeTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Biking Time Cards with staggered animations
            ...(_bikingTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final bikingTime = entry.value;
              final isSelected = selectedBikingTime?.id == bikingTime.id;

              return AnimationHelper.cardAnimation(
                index: index,
                child: GestureDetector(
                  onTap: () => _selectBikingTime(context, bikingTime),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(20),
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
                                  color: ColorPalette.activityCardSelected
                                      .withOpacity(0.35),
                                  offset: const Offset(0, 0),
                                  blurRadius: 0,
                                  spreadRadius: 4,
                                ),
                              ]
                              : null,
                    ),
                    child: Row(
                      children: [
                        // Time Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Colors.white.withOpacity(0.2)
                                    : ColorPalette.activityTextGrey.withOpacity(
                                      0.1,
                                    ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.access_time,
                            color:
                                isSelected
                                    ? Colors.white
                                    : ColorPalette.activityTextGrey,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Time Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bikingTime.timeSlot,
                                style: AppTextStyles
                                    .activityCardSelectedTextStyle
                                    .copyWith(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : ColorPalette.activityTextGrey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bikingTime.description,
                                style: AppTextStyles.activityCardTextStyle
                                    .copyWith(
                                      color:
                                          isSelected
                                              ? Colors.white.withOpacity(0.8)
                                              : ColorPalette.activityTextGrey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })),

            const SizedBox(height: 40),

            // Continue Button with fade-in animation
            AnimationHelper.slideUp(
              child: PrimaryButtonWidget(
                text: 'Complete Setup',
                onPressed:
                    selectedBikingTime != null
                        ? () => _continue(context)
                        : null,
                isEnabled: selectedBikingTime != null,
              ),
            ),
          ],
        );
      },
    );
  }
}
