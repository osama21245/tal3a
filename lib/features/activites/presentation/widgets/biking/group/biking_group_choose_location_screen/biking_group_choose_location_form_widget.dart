import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/widgets/primary_button_widget.dart';
import 'package:tal3a/features/activites/data/models/biking_group_location_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_state.dart';
import 'package:tal3a/features/activites/presentation/screens/biking/group/biking_group_choose_time_screen.dart';
import 'package:tal3a/core/utils/animation_helper.dart';

class BikingGroupChooseLocationFormWidget extends StatelessWidget {
  const BikingGroupChooseLocationFormWidget({super.key});

  // Static biking group locations data
  static const List<BikingGroupLocationModel> _bikingGroupLocations = [
    BikingGroupLocationModel(
      id: 'location1',
      name: 'King Fahd Park',
      address: 'Riyadh, Saudi Arabia',
      latitude: 24.7136,
      longitude: 46.6753,
    ),
    BikingGroupLocationModel(
      id: 'location2',
      name: 'Al Hokair Land',
      address: 'Riyadh, Saudi Arabia',
      latitude: 24.7743,
      longitude: 46.7381,
    ),
    BikingGroupLocationModel(
      id: 'location3',
      name: 'Wadi Hanifa',
      address: 'Riyadh, Saudi Arabia',
      latitude: 24.6333,
      longitude: 46.7167,
    ),
  ];

  void _selectBikingGroupLocation(
    BuildContext context,
    BikingGroupLocationModel bikingGroupLocation,
  ) {
    context.read<BikingCubit>().selectBikingGroupLocation(bikingGroupLocation);
  }

  void _continue(BuildContext context) {
    final bikingCubit = context.read<BikingCubit>();
    final selectedBikingGroupLocation =
        bikingCubit.state.selectedBikingGroupLocation;
    if (selectedBikingGroupLocation != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: bikingCubit,
                child: const BikingGroupChooseTimeScreen(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        final selectedBikingGroupLocation = state.selectedBikingGroupLocation;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'Choose Biking Location',
                style: AppTextStyles.activityTypeTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Biking Group Location Cards with staggered animations
            ...(_bikingGroupLocations.asMap().entries.map((entry) {
              final index = entry.key;
              final bikingGroupLocation = entry.value;
              final isSelected =
                  selectedBikingGroupLocation?.id == bikingGroupLocation.id;

              return AnimationHelper.cardAnimation(
                index: index,
                child: GestureDetector(
                  onTap:
                      () => _selectBikingGroupLocation(
                        context,
                        bikingGroupLocation,
                      ),
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
                        // Location Icon
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
                            Icons.location_on,
                            color:
                                isSelected
                                    ? Colors.white
                                    : ColorPalette.activityTextGrey,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Location Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bikingGroupLocation.name,
                                style: AppTextStyles
                                    .activityCardSelectedTextStyle
                                    .copyWith(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : ColorPalette.activityTextGrey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bikingGroupLocation.address,
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
                text: 'Continue',
                onPressed:
                    selectedBikingGroupLocation != null
                        ? () => _continue(context)
                        : null,
                isEnabled: selectedBikingGroupLocation != null,
              ),
            ),
          ],
        );
      },
    );
  }
}
