import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/widgets/activity_content_widget.dart';
import 'package:tal3a/core/widgets/walk_activity_header_widget.dart';
import 'package:tal3a/features/activites/presentation/widgets/walk/group/group_choose_type_screen/group_choose_type_form_widget.dart';

class GroupChooseTypeScreen extends StatelessWidget {
  const GroupChooseTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Header
          WalkActivityHeaderWidget(
            title: 'Choose Tal3a Type',
            showTal3aType: true,
            showProgressBar: true,
            activeSteps: 1,
          ),

          // Content
          ActivityContentWidget(
            screenHeight: screenHeight,
            child: const GroupChooseTypeFormWidget(),
          ),
        ],
      ),
    );
  }
}
