import 'package:flutter/material.dart';
import 'package:tal3a/core/widgets/activity_content_widget.dart';
import 'package:tal3a/core/widgets/walk_activity_header_widget.dart';

import '../../widgets/walk/walk_choose_location_screen/walk_choose_location_form_widget.dart';

class WalkChooseLocationScreen extends StatelessWidget {
  const WalkChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          const WalkActivityHeaderWidget(
            title: 'Choose Tal3a Type',
            tal3aType: 'Walking',
            showTal3aType: true,
            showProgressBar: true,
            activeSteps: 4,
            totalSteps: 5,
          ),
          ActivityContentWidget(
            screenHeight: screenHeight,
            useFlexibleLayout: true,
            child: const WalkChooseLocationFormWidget(),
          ),
        ],
      ),
    );
  }
}
