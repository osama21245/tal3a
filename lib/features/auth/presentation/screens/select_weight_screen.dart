import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/auth_screen_header_widget.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';
import '../../../../core/controller/profile_setup_controller.dart';
import '../widgets/select_weight_screen/select_weight_form_widget.dart';

class SelectWeightScreen extends StatelessWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ScreenHeaderWidget(
            title: 'Complete Our Account Info',
            activeSteps: 3,
            showProgressBar: false, // Hide progress bar for this screen
          ),
          ScreenContentWidget(
            screenHeight: screenHeight,
            child: const SelectWeightFormWidget(),
          ),
        ],
      ),
    );
  }
}
