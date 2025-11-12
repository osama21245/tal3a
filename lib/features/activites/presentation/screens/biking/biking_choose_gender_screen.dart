import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/biking_activity_header_widget.dart';
import 'package:tal3a/core/widgets/activity_content_widget.dart';
import '../../controllers/biking_cubit.dart';
import '../../widgets/biking/biking_choose_gender_screen/biking_choose_gender_form_widget.dart';

class BikingChooseGenderScreen extends StatelessWidget {
  const BikingChooseGenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          BikingActivityHeaderWidget(
            title: 'Choose Tal3a Type',
            showTal3aType: true,
            showProgressBar: true,
            activeSteps: 2,
            onBackPressed: () => Navigator.of(context).pop(),
          ),
          ActivityContentWidget(
            screenHeight: screenHeight,
            child: const BikingChooseGenderFormWidget(),
          ),
        ],
      ),
    );
  }
}
