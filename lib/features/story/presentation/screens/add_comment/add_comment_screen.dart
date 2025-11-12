import 'package:flutter/material.dart';
import '../../widgets/add_comment_screen/add_comment_form_widget.dart';

class AddCommentScreen extends StatelessWidget {
  const AddCommentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Photo Preview Background
          Container(
            height: screenHeight,
            width: double.infinity,
            color: Colors.black,
            child: const AddCommentFormWidget(),
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
