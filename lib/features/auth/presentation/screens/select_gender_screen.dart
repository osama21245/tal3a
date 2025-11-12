import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/auth_screen_header_widget.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/const/text_style.dart';
import '../../../../core/controller/profile_setup_controller.dart';
import '../widgets/select_gender_screen/select_gender_form_widget.dart';

class SelectGenderScreen extends StatelessWidget {
  const SelectGenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ScreenHeaderWidget(title: 'Select Gender', activeSteps: 3),
          // Form component as separate overlay
          ScreenContentWidget(
            screenHeight: screenHeight,
            child: const SelectGenderFormWidget(),
          ),
        ],
      ),
    );
  }
}
