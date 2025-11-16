import 'package:flutter/material.dart';
import 'package:tal3a/core/widgets/activity_content_widget.dart';
import 'package:tal3a/core/widgets/biking_activity_header_widget.dart';

import '../../widgets/biking/biking_choose_location_screen/biking_choose_location_form_widget.dart';

class BikingChooseLocationScreen extends StatelessWidget {
  const BikingChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          const BikingActivityHeaderWidget(
            title: 'Choose Tal3a Type',
            showTal3aType: true,
            showProgressBar: true,
            activeSteps: 4,
          ),
          ActivityContentWidget(
            screenHeight: screenHeight,
            useFlexibleLayout: true,
            child: const BikingChooseLocationFormWidget(),
          ),
        ],
      ),
    );
  }
}
