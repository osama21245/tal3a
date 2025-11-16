import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/routing/navigation_helper.dart';
import 'package:tal3a/core/widgets/primary_button_widget.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import '../../coach_selection_widget.dart';
import '../../../controllers/training_cubit.dart';
import '../../../controllers/tal3a_type_state.dart';

class TrainingChooseCoachFormWidget extends StatelessWidget {
  const TrainingChooseCoachFormWidget({super.key});

  void _selectCoach(String coachId, BuildContext context) {
    final cubit = context.read<TrainingCubit>();
    final coaches = cubit.state.coaches;
    final selectedCoach = coaches.firstWhere(
      (coach) => coach.id == coachId,
      orElse: () => coaches.first,
    );
    cubit.selectCoach(selectedCoach);
  }

  void _continue(BuildContext context) {
    final cubit = context.read<TrainingCubit>();
    final selectedCoach = cubit.state.selectedCoach;

    if (selectedCoach != null) {
      // Add navigation node for current screen
      cubit.addNavigationNode(
        'training_choose_coach',
        data: {'selectedCoach': selectedCoach.id},
      );

      NavigationHelper.goToTrainingChooseMode(context, cubit: cubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingCubit, Tal3aTypeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildShimmerCoaches();
        }

        if (state.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<TrainingCubit>().loadCoaches(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.coaches.isEmpty) {
          return const Center(child: Text('No coaches found.'));
        }

        final selectedCoachId = state.selectedCoach?.id;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'Choose the coach',
                style: AppTextStyles.coachSelectionTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Coach Selection with animations
            AnimationHelper.slideUp(
              child: CoachSelectionWidget(
                coaches: state.coaches,
                selectedCoachId: selectedCoachId,
                onCoachSelected: (coachId) => _selectCoach(coachId, context),
              ),
            ),

            SizedBox(height: 40.h),

            // Continue Button with fade-in animation
            AnimationHelper.slideUp(
              child: PrimaryButtonWidget(
                text: 'Continue',
                onPressed:
                    selectedCoachId != null ? () => _continue(context) : null,
                isEnabled: selectedCoachId != null,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerCoaches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 200.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Coach cards shimmer
        Column(
          children: [
            // First row shimmer
            Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 2 ? 13.w : 0),
                    child: _buildShimmerCoachCard(index),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Second row shimmer (if needed)
            Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 2 ? 13.w : 0),
                    child: _buildShimmerCoachCard(index + 3),
                  ),
                );
              }),
            ),
          ],
        ),
        SizedBox(height: 40.h),
        // Button shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCoachCard(int index) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: Duration(milliseconds: 1200 + (index * 200)),
      child: Container(
        height: 137.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Image shimmer
            Container(
              height: 59.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
            // Info section shimmer
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name shimmer
                    Container(
                      width: double.infinity,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Title shimmer
                    Container(
                      width: 80.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rating shimmer
                    Container(
                      width: 50.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
