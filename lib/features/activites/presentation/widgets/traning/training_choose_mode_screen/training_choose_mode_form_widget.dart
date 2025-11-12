import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/widgets/primary_button_widget.dart';
import 'package:tal3a/core/routing/navigation_helper.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import '../../../controllers/training_cubit.dart';
import '../../../controllers/tal3a_type_state.dart';

class TrainingChooseModeFormWidget extends StatefulWidget {
  const TrainingChooseModeFormWidget({super.key});

  @override
  State<TrainingChooseModeFormWidget> createState() =>
      _TrainingChooseModeFormWidgetState();
}

class _TrainingChooseModeFormWidgetState
    extends State<TrainingChooseModeFormWidget> {
  String? _selectedMode;
  bool _isButtonEnabled = false;

  final List<Map<String, dynamic>> _modes = [
    {'id': 'mode1', 'name': 'Mode', 'icon': Icons.fitness_center},
    {'id': 'mode2', 'name': 'Mode', 'icon': Icons.sports},
    {'id': 'mode3', 'name': 'Mode', 'icon': Icons.directions_run},
    {'id': 'mode4', 'name': 'Mode', 'icon': Icons.sports_gymnastics},
    {'id': 'mode5', 'name': 'Mode', 'icon': Icons.pool},
    {'id': 'mode6', 'name': 'Mode', 'icon': Icons.sports_martial_arts},
  ];

  void _selectMode(String modeId) {
    setState(() {
      _selectedMode = modeId;
      _isButtonEnabled = true;
    });
  }

  void _continue() {
    if (_isButtonEnabled && _selectedMode != null) {
      // Update Cubit with selected mode
      context.read<TrainingCubit>().selectMode(_selectedMode!);

      // Add navigation node for current screen
      context.read<TrainingCubit>().addNavigationNode(
        'training_choose_mode',
        data: {'selectedMode': _selectedMode},
      );

      // Navigate to next screen
      NavigationHelper.goToTraining(
        context,
        cubit: context.read<TrainingCubit>(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        AnimationHelper.slideUp(child: _buildModeGrid()),

        SizedBox(height: 40.h),

        // Continue Button with fade-in animation
        AnimationHelper.slideUp(
          child: PrimaryButtonWidget(
            text: 'Continue',
            onPressed: _continue,
            isEnabled: _isButtonEnabled,
          ),
        ),
      ],
    );
  }

  Widget _buildModeGrid() {
    return Column(
      children: [
        // First row with staggered animations
        Row(
          children:
              _modes.take(3).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final mode = entry.value;
                return Expanded(
                  child: AnimationHelper.leftCardAnimation(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 13),
                      child: _buildModeCard(mode),
                    ),
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 20),

        // Second row with staggered animations
        Row(
          children:
              _modes.skip(3).take(3).toList().asMap().entries.map((entry) {
                final index = entry.key + 3; // Offset for second row
                final mode = entry.value;
                return Expanded(
                  child: AnimationHelper.rightCardAnimation(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 13),
                      child: _buildModeCard(mode),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildModeCard(Map<String, dynamic> mode) {
    final isSelected = _selectedMode == mode['id'];

    return GestureDetector(
      onTap: () => _selectMode(mode['id']),
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
            // Icon with scale animation when selected
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
                child: Icon(
                  mode['icon'],
                  color:
                      isSelected ? Colors.white : ColorPalette.activityTextGrey,
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
              child: Text(mode['name'], textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
