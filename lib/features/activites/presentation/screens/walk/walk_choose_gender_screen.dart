import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/walk_activity_header_widget.dart';
import 'package:tal3a/core/widgets/activity_content_widget.dart';
import '../../controllers/walk_cubit.dart';
import '../../controllers/walk_state.dart';
import '../../widgets/walk/walk_choose_gender_screen/walk_choose_gender_form_widget.dart';

class WalkChooseGenderScreen extends StatelessWidget {
  const WalkChooseGenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          WalkActivityHeaderWidget(
            title: 'Choose Tal3a Type',
            tal3aType: 'Walking',
            showTal3aType: true,
            showProgressBar: true,
            activeSteps: 2,
          ),
          ActivityContentWidget(
            screenHeight: screenHeight,
            child: const WalkChooseGenderFormWidget(),
          ),
        ],
      ),
    );
  }
}
