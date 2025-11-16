import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const/color_pallete.dart';
import '../const/text_style.dart';
import '../utils/animation_helper.dart';
import '../../features/activites/presentation/controllers/training_cubit.dart';
import '../../features/activites/presentation/controllers/tal3a_type_state.dart';

class ActivityHeaderWidget extends StatelessWidget {
  final String title;
  final String? tal3aType;
  final String? tal3aTypeImage;
  final bool showTal3aType;
  final bool showProgressBar;
  final int activeSteps; // Number of active progress steps (1, 2, or 3)
  final VoidCallback? onBackPressed;

  const ActivityHeaderWidget({
    super.key,
    required this.title,
    this.tal3aType,
    this.tal3aTypeImage,
    this.showTal3aType = true,
    this.showProgressBar = true,
    this.activeSteps = 1,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Container(
      height: screenHeight,
      width: double.infinity,
      color: ColorPalette.forgotPasswordBg,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: statusBarHeight - 30), // Top padding
            // Back Button
            GestureDetector(
              onTap: () {
                print('Back button tapped');
                _handleBackButton(context);
              },
              child: Container(
                width: 48,
                height: 48.h,
                child: Center(
                  child: Image.asset(
                    'assets/icons/back_button.png',
                    width: 48,
                    height: 48.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // Title
            Text(title, style: AppTextStyles.trainingTitleStyle),

            SizedBox(height: 10.h),

            // Progress Indicators (conditionally rendered)
            Opacity(
              opacity: showProgressBar ? 1.0 : 0.0,
              child: Row(
                children: [
                  // Active step indicator (blue) - Vector 1
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 1
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Active step indicator - Vector 2
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 2
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Active step indicator - Vector 3
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color:
                            activeSteps >= 3
                                ? ColorPalette.progressActive
                                : ColorPalette.progressInactive,
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 29.h),

            // Tal3a Type Section (conditionally rendered)
            if (showTal3aType) ...[
              _buildTal3aTypeSection(),
              SizedBox(height: 20.h),
            ],

            const Spacer(), // Push content to top
          ],
        ),
      ),
    );
  }

  Widget _buildTal3aTypeSection() {
    return BlocBuilder<TrainingCubit, Tal3aTypeState>(
      builder: (context, state) {
        final tal3aTypeData = state.selectedTal3aType;
        final coachData = state.selectedCoach;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tal3a Type', style: AppTextStyles.tal3aTypeLabelStyle),

            SizedBox(height: 9.h),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildDynamicNodes(tal3aTypeData, coachData),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildDynamicNodes(
    Tal3aTypeData? tal3aTypeData,
    CoachData? coachData,
  ) {
    List<Widget> nodes = [];

    // Add Tal3a Type Card
    nodes.add(_buildTal3aTypeCard(tal3aTypeData));

    // TODO: Add more activity nodes here in the future
    // Example: nodes.add(_buildActivityCard("Yoga"));
    // Example: nodes.add(_buildActivityCard("Swimming"));

    // Add Coach Card if available
    if (coachData != null) {
      nodes.add(_buildCoachCard(coachData));
    }

    // Add separator lines between all nodes with animations
    List<Widget> result = [];
    for (int i = 0; i < nodes.length; i++) {
      // Add animated node using AnimationHelper
      result.add(AnimationHelper.nodeAnimation(child: nodes[i], index: i));

      // Add separator line after each node (except the last one)
      if (i < nodes.length - 1) {
        result.add(SizedBox(width: 10.w));
        result.add(
          AnimationHelper.separatorAnimation(
            child: _buildSeparatorLine(),
            index: i,
          ),
        );
        result.add(SizedBox(width: 10.w));
      }
    }

    return result;
  }

  Widget _buildTal3aTypeCard(Tal3aTypeData? tal3aTypeData) {
    return Container(
      width: 52.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: ColorPalette.tal3aTypeBg,
        borderRadius: BorderRadius.circular(6.7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Image
          Container(
            width: 23.w,
            height: 23.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              _getTal3aTypeIcon(tal3aTypeData?.name ?? tal3aType ?? ''),
              color: Colors.white,
              size: 16,
            ),
          ),

          SizedBox(height: 4.h),

          // Tal3a Type Text
          Text(
            tal3aTypeData?.name ?? tal3aType ?? 'Training',
            style: AppTextStyles.tal3aTypeTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSeparatorLine() {
    return Container(
      height: 55.h,
      child: Center(
        child: Container(width: 17, height: 1.3, color: Colors.white),
      ),
    );
  }

  Widget _buildCoachCard(CoachData coach) {
    return Container(
      width: 153.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: ColorPalette.coachCardSelected,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          // Left shadow
          BoxShadow(
            color: ColorPalette.coachCardSelected.withOpacity(0.35),
            offset: const Offset(-4, 0),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          // Right shadow
          BoxShadow(
            color: ColorPalette.coachCardSelected.withOpacity(0.35),
            offset: const Offset(4, 0),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          // Top shadow
          BoxShadow(
            color: ColorPalette.coachCardSelected.withOpacity(0.35),
            offset: const Offset(0, -4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          // Bottom shadow
          BoxShadow(
            color: ColorPalette.coachCardSelected.withOpacity(0.35),
            offset: const Offset(0, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Coach Image
          Container(
            width: 50.w,
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child:
                  coach.imageUrl != null
                      ? Image.network(coach.imageUrl!, fit: BoxFit.cover)
                      : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
            ),
          ),

          // Coach Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCoachNameWithDifferentWeights(coach.name),
                  const SizedBox(height: 1),
                  Text(
                    coach.title,
                    style: AppTextStyles.coachTitleSelectedStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachNameWithDifferentWeights(String name) {
    // Parse the name to identify different parts
    // Example: "Capt.george n." -> "Capt." (light), "george" (bold), " n." (light)
    final parts = _parseCoachName(name);

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children:
            parts.map((part) {
              return TextSpan(
                text: part.text,
                style:
                    part.isBold
                        ? AppTextStyles.coachNameBoldStyle
                        : AppTextStyles.coachNameLightStyle,
              );
            }).toList(),
      ),
    );
  }

  List<_NamePart> _parseCoachName(String name) {
    // Super simple: Just two parts - "Capt." (light) and everything else (bold)

    if (name.toLowerCase().startsWith('capt.')) {
      final withoutCapt = name.substring(5).trim(); // Remove "Capt." and trim
      return [
        _NamePart('Capt.', false), // "Capt." (light)
        _NamePart(withoutCapt, true), // Everything else (bold)
      ];
    }

    // Fallback: if no "Capt.", make the whole name bold
    return [_NamePart(name, true)];
  }

  IconData _getTal3aTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'training':
        return Icons.fitness_center;
      case 'walking':
        return Icons.directions_walk;
      case 'biking':
        return Icons.directions_bike;
      default:
        return Icons.sports;
    }
  }

  void _handleBackButton(BuildContext context) {
    final trainingCubit = context.read<TrainingCubit>();
    final state = trainingCubit.state;

    print('Back button pressed - Current state:');
    print('Tal3a Type: ${state.selectedTal3aType?.name}');
    print('Coach: ${state.selectedCoach?.name}');
    print('Mode: ${state.selectedMode}');
    print('Current Step: ${state.currentStep}');

    try {
      // Determine what to clear based on current step
      if (state.currentStep >= 3 && state.selectedMode != null) {
        // Clear mode and go back to coach selection
        trainingCubit.clearMode();
        trainingCubit.removeLastNavigationNode();
        print('Cleared mode, going back to coach selection');
      } else if (state.currentStep >= 2 && state.selectedCoach != null) {
        // Clear coach and go back to tal3a type selection
        // Use reset and then re-select tal3a type if it exists
        final currentTal3aType = state.selectedTal3aType;
        trainingCubit.reset();
        if (currentTal3aType != null) {
          trainingCubit.selectTal3aType(currentTal3aType);
        }
        trainingCubit.removeLastNavigationNode();
        print('Cleared coach, going back to tal3a type selection');
      } else if (state.currentStep >= 1 && state.selectedTal3aType != null) {
        // Clear tal3a type and go back to main screen
        trainingCubit.reset();
        trainingCubit.removeLastNavigationNode();
        print('Cleared tal3a type, going back to main screen');
      } else {
        // No more data to clear, just pop
        print('Nothing selected, popping screen');
      }

      // Always pop the current screen
      Navigator.of(context).pop();
    } catch (e) {
      print('Error handling back button: $e');
      // Fallback: just pop the screen
      Navigator.of(context).pop();
    }
  }
}

class _NamePart {
  final String text;
  final bool isBold;

  _NamePart(this.text, this.isBold);
}
