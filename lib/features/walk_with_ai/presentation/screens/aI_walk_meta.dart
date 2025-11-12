import 'package:flutter/material.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';

class AIWalkMeta extends StatelessWidget {
  const AIWalkMeta({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [CustomAppBar(title: 'AI walk Mate',)],),
    );
  }
}