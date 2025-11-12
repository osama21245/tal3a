import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/story_cubit.dart';
import '../../widgets/view_others_story_screen/view_others_story_form_widget.dart';

class ViewOthersStoryScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String? userProfilePic;

  const ViewOthersStoryScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.userProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoryCubit()..loadUserStories(userId),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: ViewOthersStoryFormWidget(
            userId: userId,
            userName: userName,
            userProfilePic: userProfilePic,
          ),
        ),
      ),
    );
  }
}
