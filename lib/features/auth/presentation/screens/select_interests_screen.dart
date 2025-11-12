import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';
import '../../../../core/widgets/auth_screen_header_widget.dart';
import '../../../../core/controller/profile_setup_controller.dart';
import '../widgets/select_interests_screen/select_interests_form_widget.dart';

class SelectInterestsScreen extends StatelessWidget {
  const SelectInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ScreenHeaderWidget(
            title: 'Create an account',
            activeSteps: 3, // All 3 steps active for interests screen
          ),
          // Form component as separate overlay
          ScreenContentWidget(
            screenHeight: screenHeight,
            child: const SelectInterestsFormWidget(),
          ),
        ],
      ),
    );
  }
}
