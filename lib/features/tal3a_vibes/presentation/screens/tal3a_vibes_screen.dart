import 'package:flutter/material.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/features/tal3a_vibes/presentation/widgets/tal3a_vibes_body.dart';
import 'package:tal3a/features/tal3a_vibes/presentation/widgets/tal3a_vibes_header.dart';

class Tal3aVibesScreen extends StatefulWidget {
  const Tal3aVibesScreen({super.key});

  @override
  State<Tal3aVibesScreen> createState() => _Tal3aVibesScreenState();
}

class _Tal3aVibesScreenState extends State<Tal3aVibesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.homeMainBg,
      extendBody: true,
      body: Column(
        children: [Tal3aVibesHeader(title: "Tal3a Vibes"), Tal3aVibesBody()],
      ),
    );
  }
}
