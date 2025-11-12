import 'package:flutter/material.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/dimentions.dart';

class ActivityContentWidget extends StatelessWidget {
  final double screenHeight;
  final Widget child;
  final bool showHomeIndicator;
  final bool useFlexibleLayout;

  const ActivityContentWidget({
    super.key,
    required this.child,
    required this.screenHeight,
    this.showHomeIndicator = true,
    this.useFlexibleLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: screenHeight * 0.37 - 24, // Overlap by 24px
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child:
            useFlexibleLayout
                ? Padding(
                  padding: EdgeInsets.all(Dimensions.paddingLarge),
                  child: child,
                )
                : SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form content
                      child,

                      const SizedBox(height: Dimensions.spacingMedium),
                    ],
                  ),
                ),
      ),
    );
  }
}
