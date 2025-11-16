import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/walk_activity_header_widget.dart';
import 'package:tal3a/core/widgets/activity_content_widget.dart';
import 'package:tal3a/core/routing/navigation_helper.dart';
import '../../widgets/walk/walk_choose_time_screen/walk_choose_time_form_widget.dart';
import '../../controllers/walk_cubit.dart';
import '../../controllers/walk_state.dart';

class WalkChooseTimeScreen extends StatelessWidget {
  const WalkChooseTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<WalkCubit, WalkState>(
      listenWhen: (previous, current) {
        // Only listen when transitioning from loading to success
        // and we have all required data (indicating request was sent)
        return previous.status == WalkStatus.loading &&
            current.status == WalkStatus.success &&
            current.selectedWalkFriend != null &&
            current.selectedWalkLocation != null &&
            current.selectedWalkTime != null;
      },
      listener: (context, state) {
        // Navigate to home when walk request is successfully sent
        // Small delay to show success message
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            NavigationHelper.goToHome(context);
          }
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            const WalkActivityHeaderWidget(
              title: 'Choose Tal3a Type',
              tal3aType: 'Walking',
              showTal3aType: true,
              showProgressBar: true,
              activeSteps: 5,
              totalSteps: 5,
            ),
            ActivityContentWidget(
              screenHeight: screenHeight,
              child: const WalkChooseTimeFormWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
