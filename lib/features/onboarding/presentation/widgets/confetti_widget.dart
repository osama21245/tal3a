import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/const/color_pallete.dart';

class ConfettiOverlayWidget extends StatelessWidget {
  final ConfettiController confettiController;

  const ConfettiOverlayWidget({super.key, required this.confettiController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: confettiController,
        blastDirection: 1.57, // Downward
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.3,
        shouldLoop: false,
        colors: const [
          ColorPalette.primaryBlue,
          ColorPalette.secondaryBlue,
          ColorPalette.darkBlue,
          ColorPalette.white,
        ],
      ),
    );
  }
}
