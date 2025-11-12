import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/activity_header_widget.dart';
import 'package:tal3a/core/widgets/activity_content_widget.dart';
import 'package:tal3a/features/activites/presentation/controllers/tal3a_type_state.dart';
import '../../controllers/training_cubit.dart';
import '../../widgets/traning/training_choose_mode_screen/training_choose_mode_form_widget.dart';

class TrainingChooseModeScreen extends StatelessWidget {
  const TrainingChooseModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<TrainingCubit, Tal3aTypeState>(
            builder: (context, state) {
              return ActivityHeaderWidget(
                title: 'Choose Tal3a Type',
                tal3aType: state.selectedTal3aType?.name ?? 'Training',
                showTal3aType: true,
                showProgressBar: true,
                activeSteps: 3,
              );
            },
          ),
          ActivityContentWidget(
            screenHeight: screenHeight,
            child: const TrainingChooseModeFormWidget(),
          ),
        ],
      ),
    );
  }
}
