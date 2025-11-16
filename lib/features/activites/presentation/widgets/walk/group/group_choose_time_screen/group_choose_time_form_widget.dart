import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/features/activites/data/models/group_tal3a_detail_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_state.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import 'package:intl/intl.dart';

class GroupChooseTimeFormWidget extends StatefulWidget {
  const GroupChooseTimeFormWidget({super.key});

  @override
  State<GroupChooseTimeFormWidget> createState() =>
      _GroupChooseTimeFormWidgetState();
}

class _GroupChooseTimeFormWidgetState extends State<GroupChooseTimeFormWidget> {
  GroupTal3aDetailTimeSlot? _selectedTimeSlot;
  
  @override
  void initState() {
    super.initState();
    // Time slots are already loaded from the location selection
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
    final selectedDetail = state.selectedGroupTal3aDetail;
    if (selectedDetail == null) {
      return const SizedBox.shrink();
    }

    // Format the date from the group tal3a detail
    final dateFormat = DateFormat('d');
    final dayFormat = DateFormat('EEE');
    final dateStr = dateFormat.format(selectedDetail.date);
    final dayStr = dayFormat.format(selectedDetail.date);

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

        // Calendar-like display showing the date from the group tal3a detail
        Container(
          width: double.infinity,
          height: 134.h,
          child: Row(
            children: [
              _buildDayCard(dateStr, dayStr, true), // Selected date
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
    final selectedDetail = state.selectedGroupTal3aDetail;
    if (selectedDetail == null || selectedDetail.timeSlots.isEmpty) {
      return const SizedBox.shrink();
    }

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

        // Time slots list from the group tal3a detail
        ...selectedDetail.timeSlots.map((timeSlot) => _buildTimeSlotCard(timeSlot)),
      ],
    );
  }

  Widget _buildTimeSlotCard(GroupTal3aDetailTimeSlot timeSlot) {
    final isSelected = _selectedTimeSlot?.id == timeSlot.id;

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
          onTap: () => _selectTime(timeSlot),
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Text(
              timeSlot.startTime, // Display start time
              style: AppTextStyles.trainingTitleStyle.copyWith(
                color:
                    isSelected
                        ? Colors.white
                        : ColorPalette.calendarDayText,
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
    final canContinue = _selectedTimeSlot != null;

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

  void _selectTime(GroupTal3aDetailTimeSlot timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  void _continue(BuildContext context) async {
    final cubit = context.read<WalkCubit>();
    final state = cubit.state;
    
    if (_selectedTimeSlot == null || state.selectedGroupTal3aDetail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Map group type ID to API format
    String groupTypeApi = 'group_mix'; // default
    if (state.selectedGroupType != null) {
      switch (state.selectedGroupType!.id) {
        case 'group_ma':
          groupTypeApi = 'group_man';
          break;
        case 'group_wo':
          groupTypeApi = 'group_woman';
          break;
        case 'mix_group':
          groupTypeApi = 'group_mix';
          break;
      }
    }

    // Format date as "2025-11-01"
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dateStr = dateFormat.format(state.selectedGroupTal3aDetail!.date);

    // Send group request
    await cubit.sendGroupRequest(
      groupType: groupTypeApi,
      date: dateStr,
      time: _selectedTimeSlot!.startTime, // Use startTime from timeslot
    );

    if (!mounted) return;

    final currentState = cubit.state;
    if (currentState.status == WalkStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(currentState.error ?? 'Failed to create group request'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (currentState.status == WalkStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group request created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to home after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    }
  }
}
