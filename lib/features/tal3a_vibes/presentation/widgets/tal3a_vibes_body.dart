import 'package:flutter/material.dart';
import 'package:tal3a/features/videos/presentation/screens/video_show.dart';

class Tal3aVibesBody extends StatefulWidget {
  final PageController? pageController;
  const Tal3aVibesBody({super.key, this.pageController});

  @override
  State<Tal3aVibesBody> createState() => _Tal3aVibesBodyState();
}

class _Tal3aVibesBodyState extends State<Tal3aVibesBody> {
  @override
  Widget build(BuildContext context) {

    return VideoShow(
      pageController: widget.pageController,
    );
  }
}
