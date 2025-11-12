import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../data/models/walk_time_model.dart';
import '../../../controllers/walk_cubit.dart';
import '../../../controllers/walk_state.dart';

class WalkChooseTimeFormWidget extends StatefulWidget {
  const WalkChooseTimeFormWidget({super.key});

  @override
  State<WalkChooseTimeFormWidget> createState() =>
      _WalkChooseTimeFormWidgetState();
}

class _WalkChooseTimeFormWidgetState extends State<WalkChooseTimeFormWidget> {
  WalkTimeModel? _selectedWalkTime;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Load data using cubit
    context.read<WalkCubit>().loadWalkTimes();
  }

  void _selectWalkTime(WalkTimeModel walkTime) {
    setState(() {
      _selectedWalkTime = walkTime;
      _isButtonEnabled = true;
    });
  }

  void _save() {
    if (_isButtonEnabled && _selectedWalkTime != null) {
      // Update WalkCubit with selected walk time
      context.read<WalkCubit>().selectWalkTime(_selectedWalkTime!);

      // Start walk session
      context.read<WalkCubit>().startWalk();

      // TODO: Navigate to walk session screen
      print('Selected walk time: ${_selectedWalkTime!.timeSlot}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorPalette.primaryBlue),
          );
        }

        if (state.isError) {
          return Center(child: Text('Error: ${state.error}'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Calendar Section
            Container(
              width: double.infinity,
              height: 134,
              child: Column(
                children: [
                  // Today's Pick Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'activities.today_pick'.tr(),
                      style: AppTextStyles.activityTypeTitleStyle,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Calendar Days
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCalendarDay('19', 'Sun', false),
                      _buildCalendarDay('20', 'Mon', false),
                      _buildCalendarDay('21', 'Tue', true), // Selected day
                      _buildCalendarDay('22', 'Wed', false),
                      _buildCalendarDay('23', 'Thu', false),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Choose the time title
            Text(
              'activities.choose_the_time'.tr(),
              style: AppTextStyles.activityTypeTitleStyle,
            ),

            const SizedBox(height: 20),

            // Time Picker (Simplified version based on Figma)
            Container(
              width: double.infinity,
              height: 254,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Time Display (Large)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '05',
                          style: TextStyle(
                            color: ColorPalette.primaryBlue,
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Oxygen',
                          ),
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                            color: ColorPalette.primaryBlue,
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Oxygen',
                          ),
                        ),
                        Text(
                          '30',
                          style: TextStyle(
                            color: ColorPalette.primaryBlue,
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Oxygen',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'AM',
                          style: TextStyle(
                            color: ColorPalette.primaryBlue,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Oxygen',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Save Button
            PrimaryButtonWidget(
              text: 'common.save'.tr(),
              onPressed: _save,
              isEnabled: _isButtonEnabled,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarDay(String day, String dayName, bool isSelected) {
    return Container(
      width: 54,
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: ColorPalette.textDark,
              fontSize: isSelected ? 25 : 20,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontFamily: 'Rubik',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dayName,
            style: TextStyle(
              color: ColorPalette.progressInactive,
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Rubik',
            ),
          ),
        ],
      ),
    );
  }
}
