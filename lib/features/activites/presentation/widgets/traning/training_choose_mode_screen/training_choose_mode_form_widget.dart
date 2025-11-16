import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/widgets/primary_button_widget.dart';
import 'package:tal3a/core/routing/navigation_helper.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import '../../../controllers/training_cubit.dart';
import '../../../controllers/tal3a_type_state.dart';
import '../../../../data/models/training_mode_model.dart';

class TrainingChooseModeFormWidget extends StatelessWidget {
  const TrainingChooseModeFormWidget({super.key});

  void _selectMode(TrainingModeModel mode, BuildContext context) {
    context.read<TrainingCubit>().selectMode(mode);
  }

  void _continue(BuildContext context) {
    final cubit = context.read<TrainingCubit>();
    final selectedMode = cubit.state.selectedMode;

    if (selectedMode != null) {
      // Add navigation node for current screen
      cubit.addNavigationNode(
        'training_choose_mode',
        data: {'selectedMode': selectedMode.toJson()},
      );

      // Navigate to next screen
      NavigationHelper.goToTraining(context, cubit: cubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingCubit, Tal3aTypeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildShimmerModes();
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
                  onPressed: () {
                    final selectedCoach = state.selectedCoach;
                    if (selectedCoach != null) {
                      context.read<TrainingCubit>().loadCoachDetail(
                        selectedCoach.id,
                      );
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.trainingModes.isEmpty) {
          return const Center(child: Text('No training modes found.'));
        }

        final selectedModeId = state.selectedMode?.id;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'Select training mode',
                style: AppTextStyles.coachSelectionTitleStyle,
              ),
            ),

            const SizedBox(height: 20),

            // Mode Selection Grid with animations
            AnimationHelper.slideUp(
              child: _buildModeGrid(
                state.trainingModes,
                selectedModeId,
                context,
              ),
            ),

            SizedBox(height: 40.h),

            // Continue Button with fade-in animation
            AnimationHelper.slideUp(
              child: PrimaryButtonWidget(
                text: 'Continue',
                onPressed:
                    selectedModeId != null ? () => _continue(context) : null,
                isEnabled: selectedModeId != null,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModeGrid(
    List<TrainingModeModel> modes,
    String? selectedModeId,
    BuildContext context,
  ) {
    return Column(
      children: [
        // First row with staggered animations
        Row(
          children:
              modes.take(3).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final mode = entry.value;
                return Expanded(
                  child: AnimationHelper.leftCardAnimation(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 13),
                      child: _buildModeCard(mode, selectedModeId, context),
                    ),
                  ),
                );
              }).toList(),
        ),

        if (modes.length > 3) ...[
          const SizedBox(height: 20),
          // Second row with staggered animations
          Row(
            children:
                modes.skip(3).take(3).toList().asMap().entries.map((entry) {
                  final index = entry.key + 3; // Offset for second row
                  final mode = entry.value;
                  return Expanded(
                    child: AnimationHelper.rightCardAnimation(
                      index: index,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 13),
                        child: _buildModeCard(mode, selectedModeId, context),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildModeCard(
    TrainingModeModel mode,
    String? selectedModeId,
    BuildContext context,
  ) {
    final isSelected = selectedModeId == mode.id;

    return GestureDetector(
      onTap: () => _selectMode(mode, context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 115.h,
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
                      color: ColorPalette.activityCardSelected.withOpacity(
                        0.35,
                      ),
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
            // Thumbnail or Icon
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.white.withOpacity(0.2)
                          : ColorPalette.activityTextGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    mode.thumbnail != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            mode.thumbnail!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.fitness_center,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : ColorPalette.activityTextGrey,
                                size: 24,
                              );
                            },
                          ),
                        )
                        : Icon(
                          Icons.fitness_center,
                          color:
                              isSelected
                                  ? Colors.white
                                  : ColorPalette.activityTextGrey,
                          size: 24,
                        ),
              ),
            ),

            const SizedBox(height: 8),

            // Mode name with color transition
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style:
                  isSelected
                      ? AppTextStyles.activityCardSelectedTextStyle
                      : AppTextStyles.activityCardTextStyle,
              child: Text(
                mode.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),

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

        // Mode cards shimmer
        Column(
          children: [
            // First row shimmer
            Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 2 ? 13.w : 0),
                    child: _buildShimmerModeCard(index),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Second row shimmer
            Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 2 ? 13.w : 0),
                    child: _buildShimmerModeCard(index + 3),
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

  Widget _buildShimmerModeCard(int index) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: Duration(milliseconds: 1200 + (index * 200)),
      child: Container(
        height: 115.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Thumbnail/Icon shimmer
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            // Mode name shimmer
            Container(
              width: 60.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
