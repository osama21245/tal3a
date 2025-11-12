import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/widgets/walk_activity_header_widget.dart';
import 'package:tal3a/core/widgets/activity_content_widget.dart';
import '../../controllers/walk_cubit.dart';
import '../../controllers/walk_state.dart';
import '../../widgets/walk/walk_choose_type_screen/walk_choose_type_form_widget.dart';

class WalkChooseTypeScreen extends StatelessWidget {
  const WalkChooseTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          WalkActivityHeaderWidget(
            title: 'activities.choose_tal3a_type'.tr(),
            tal3aType: 'activities.walking'.tr(),
            showTal3aType: true,
            showProgressBar: true,
            activeSteps: 1,
          ),
          ActivityContentWidget(
            screenHeight: screenHeight,
            child: const WalkChooseTypeFormWidget(),
          ),
        ],
      ),
    );
  }
}
