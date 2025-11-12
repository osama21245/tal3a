import 'package:flutter/material.dart';
import '../../widgets/view_own_story_screen/view_own_story_form_widget.dart';

class ViewOwnStoryScreen extends StatelessWidget {
  const ViewOwnStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Story Preview Background
          Container(
            height: screenHeight,
            width: double.infinity,
            color: Colors.black,
            child: const ViewOwnStoryFormWidget(),
          ),

          // Status Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
