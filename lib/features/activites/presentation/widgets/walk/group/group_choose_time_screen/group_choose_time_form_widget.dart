import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/features/activites/data/models/group_time_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_state.dart';
import 'package:tal3a/core/utils/animation_helper.dart';

class GroupChooseTimeFormWidget extends StatefulWidget {
  const GroupChooseTimeFormWidget({super.key});

  @override
  State<GroupChooseTimeFormWidget> createState() =>
      _GroupChooseTimeFormWidgetState();
}

class _GroupChooseTimeFormWidgetState extends State<GroupChooseTimeFormWidget> {
  @override
  void initState() {
    super.initState();
    // Load group times when the widget initializes
    context.read<WalkCubit>().loadGroupTimes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        if (state.status == WalkStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == WalkStatus.error) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Today's Pick Section
            AnimationHelper.slideUp(child: _buildTodaysPickSection(state)),

            SizedBox(height: 20.h),

            // Choose Time Section
            AnimationHelper.slideUp(child: _buildChooseTimeSection(state)),

            SizedBox(height: 40), // Fixed spacing instead of Spacer
            // Continue Button
            AnimationHelper.slideUp(
              child: _buildContinueButton(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodaysPickSection(WalkState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimationHelper.titleAnimation(
          child: Text(
            "Today's Pick",
            style: AppTextStyles.trainingTitleStyle.copyWith(
              color: ColorPalette.activityTextGrey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(height: 15.h),

        // Calendar-like display showing days
        Container(
          width: double.infinity,
          height: 134.h,
          child: Row(
            children: [
              // Day cards (19, 20, 21, 22, 23)
              _buildDayCard('19', 'Sun', false),
              SizedBox(width: 15.w),
              _buildDayCard('20', 'Mon', false),
              SizedBox(width: 15.w),
              _buildDayCard('21', 'Tue', true), // Today's pick - highlighted
              SizedBox(width: 15.w),
              _buildDayCard('22', 'Wed', false),
              SizedBox(width: 15.w),
              _buildDayCard('23', 'Thu', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(String day, String dayName, bool isSelected) {
    return Container(
      width: 55.w,
      height: isSelected ? 107.h : 76.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border:
            isSelected
                ? Border.all(color: ColorPalette.progressActive, width: 2)
                : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: AppTextStyles.trainingTitleStyle.copyWith(
              color: ColorPalette.activityTextGrey,
              fontSize: isSelected ? 25 : 20,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            dayName,
            style: AppTextStyles.trainingTitleStyle.copyWith(
              color: ColorPalette.calendarDayText,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChooseTimeSection(WalkState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimationHelper.titleAnimation(
          child: Text(
            'Choose the time',
            style: AppTextStyles.trainingTitleStyle.copyWith(
              color: ColorPalette.activityTextGrey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(height: 15.h),

        // Time slots list
        ...state.groupTimes.map((time) => _buildTimeSlotCard(time, state)),
      ],
    );
  }

  Widget _buildTimeSlotCard(GroupTimeModel time, WalkState state) {
    final isSelected = state.selectedGroupTime?.id == time.id;
    final isAvailable = time.isAvailable;

    return Container(
      width: double.infinity,
      height: 53.h,
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: isSelected ? ColorPalette.progressActive : ColorPalette.cardGrey,
        borderRadius: BorderRadius.circular(14),
        border:
            isSelected
                ? Border.all(color: ColorPalette.progressActive, width: 2)
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAvailable ? () => _selectTime(time) : null,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Text(
              time.timeSlot,
              style: AppTextStyles.trainingTitleStyle.copyWith(
                color:
                    isSelected
                        ? Colors.white
                        : isAvailable
                        ? ColorPalette.calendarDayText
                        : ColorPalette.activityTextGrey.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, WalkState state) {
    final canContinue = state.selectedGroupTime != null;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: canContinue ? () => _continue(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canContinue
                  ? ColorPalette.progressActive
                  : ColorPalette.progressInactive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Continue',
          style: AppTextStyles.trainingTitleStyle.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _selectTime(GroupTimeModel time) {
    context.read<WalkCubit>().selectGroupTime(time);
  }

  void _continue(BuildContext context) {
    // TODO: Navigate to the next screen or start the group session
    print('Group session started with:');
    final state = context.read<WalkCubit>().state;
    print('Group Type: ${state.selectedGroupType?.name}');
    print('Group Location: ${state.selectedGroupLocation?.name}');
    print('Group Time: ${state.selectedGroupTime?.timeSlot}');

    // For now, just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Group session created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
