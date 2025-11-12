import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/widgets/auth_screen_header_widget.dart';
import 'package:tal3a/core/widgets/screen_content_widget.dart';
import 'package:tal3a/core/di/di.dart';
import '../controllers/choose_tal3a_type_cubit.dart';
import '../widgets/choose_tal3a_type_screen/choose_tal3a_type_form_widget.dart';

class ChooseTal3aTypeScreen extends StatelessWidget {
  const ChooseTal3aTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create:
          (context) =>
              createChooseTal3aTypeCubit(), // Create cubit for feature selection
      child: Scaffold(
        body: Stack(
          children: [
            ScreenHeaderWidget(
              title: 'activities.choose_tal3a_type'.tr(),
              activeSteps: 1,
              showProgressBar: true,
            ),
            ScreenContentWidget(
              screenHeight: screenHeight,
              child: const ChooseTal3aTypeFormWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
