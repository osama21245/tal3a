import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/widgets/primary_button_widget.dart';
import 'package:tal3a/features/activites/data/models/biking_group_time_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_state.dart';
import 'package:tal3a/core/utils/animation_helper.dart';

class BikingGroupChooseTimeFormWidget extends StatelessWidget {
  const BikingGroupChooseTimeFormWidget({super.key});

  // Static biking group times data
  static const List<BikingGroupTimeModel> _bikingGroupTimes = [
    BikingGroupTimeModel(
      id: 'morning',
      timeSlot: '6:00 AM',
      description: 'Morning Group Bike',
      date: 'Today',
    ),
    BikingGroupTimeModel(
      id: 'evening',
      timeSlot: '6:00 PM',
      description: 'Evening Group Bike',
      date: 'Today',
    ),
  ];

  void _selectBikingGroupTime(
    BuildContext context,
    BikingGroupTimeModel bikingGroupTime,
  ) {
    context.read<BikingCubit>().selectBikingGroupTime(bikingGroupTime);
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
            title: const Text('Biking Group Setup Complete!'),
            content: Text(
              'You have successfully set up your group biking session:\n'
              'Type: ${state.selectedBikingType?.name}\n'
              'Group Type: ${state.selectedBikingGroupType?.name}\n'
              'Location: ${state.selectedBikingGroupLocation?.name}\n'
              'Time: ${state.selectedBikingGroupTime?.timeSlot}',
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
        final selectedBikingGroupTime = state.selectedBikingGroupTime;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'Choose Group Biking Time',
                style: AppTextStyles.activityTypeTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Biking Group Time Cards with staggered animations
            ...(_bikingGroupTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final bikingGroupTime = entry.value;
              final isSelected =
                  selectedBikingGroupTime?.id == bikingGroupTime.id;

              return AnimationHelper.cardAnimation(
                index: index,
                child: GestureDetector(
                  onTap: () => _selectBikingGroupTime(context, bikingGroupTime),
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
                                bikingGroupTime.timeSlot,
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
                                bikingGroupTime.description,
                                style: AppTextStyles.activityCardTextStyle
                                    .copyWith(
                                      color:
                                          isSelected
                                              ? Colors.white.withOpacity(0.8)
                                              : ColorPalette.activityTextGrey,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                bikingGroupTime.date,
                                style: AppTextStyles.activityCardTextStyle
                                    .copyWith(
                                      color:
                                          isSelected
                                              ? Colors.white.withOpacity(0.6)
                                              : ColorPalette.activityTextGrey
                                                  .withOpacity(0.7),
                                      fontSize: 12,
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
                    selectedBikingGroupTime != null
                        ? () => _continue(context)
                        : null,
                isEnabled: selectedBikingGroupTime != null,
              ),
            ),
          ],
        );
      },
    );
  }
}
