import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/routing/navigation_helper.dart';
import 'package:tal3a/core/widgets/primary_button_widget.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import 'package:tal3a/features/activites/presentation/screens/traning/training_choose_mode_screen.dart';
import '../../coach_selection_widget.dart';
import '../../../controllers/training_cubit.dart';
import '../../../controllers/tal3a_type_state.dart';

class TrainingChooseCoachFormWidget extends StatefulWidget {
  const TrainingChooseCoachFormWidget({super.key});

  @override
  State<TrainingChooseCoachFormWidget> createState() =>
      _TrainingChooseCoachFormWidgetState();
}

class _TrainingChooseCoachFormWidgetState
    extends State<TrainingChooseCoachFormWidget> {
  String? _selectedCoachId;
  bool _isButtonEnabled = false;

  final List<CoachData> _coaches = [
    CoachData(
      id: 'coach1',
      name: 'capt.george n.',
      title: 'Running Coach',
      rating: 4.5,
      imageUrl: 'assets/images/fitness_partner.png',
    ),
    CoachData(
      id: 'coach2',
      name: 'capt.george n.',
      title: 'Cycling Coach',
      rating: 4.8,
      imageUrl: 'assets/images/certified_coaches.png',
    ),
    CoachData(
      id: 'coach3',
      name: 'capt.george n.',
      title: 'Personal Trainer',
      rating: 4.2,
      imageUrl: 'assets/images/certified_coaches.png',
    ),
    CoachData(
      id: 'coach4',
      name: 'capt.george n.',
      title: 'CrossFit Coach',
      rating: 4.9,
      imageUrl: 'assets/images/fitness_partner.png',
    ),
    CoachData(
      id: 'coach5',
      name: 'capt.george n.',
      title: 'Yoga Instructor',
      rating: 4.7,
      imageUrl: 'assets/images/fitness_partner.png',
    ),
    CoachData(
      id: 'coach6',
      name: 'capt.george n.',
      title: 'Swimming Coach',
      rating: 4.6,
      imageUrl: 'assets/images/certified_coaches.png',
    ),
  ];

  void _selectCoach(String coachId) {
    setState(() {
      _selectedCoachId = coachId;
      _isButtonEnabled = true;
    });
  }

  void _continue() {
    if (_isButtonEnabled && _selectedCoachId != null) {
      final selectedCoach = _coaches.firstWhere(
        (coach) => coach.id == _selectedCoachId,
      );

      // Update Cubit with selected coach
      context.read<TrainingCubit>().selectCoach(selectedCoach);

      // Add navigation node for current screen
      context.read<TrainingCubit>().addNavigationNode(
        'training_choose_coach',
        data: {'selectedCoach': selectedCoach.id},
      );

      NavigationHelper.goToTrainingChooseMode(
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
            coaches: _coaches,
            selectedCoachId: _selectedCoachId,
            onCoachSelected: _selectCoach,
          ),
        ),

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
}
