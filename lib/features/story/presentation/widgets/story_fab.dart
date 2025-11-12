import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../utils/story_navigation.dart';

class StoryFAB extends StatelessWidget {
  const StoryFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => StoryNavigation.toMainStory(context),
      backgroundColor: const Color(0xFF2BB8FF),
      child: const Icon(Icons.add_a_photo, color: Colors.white, size: 28),
      tooltip: 'story.add_story'.tr(),
    );
  }
}
