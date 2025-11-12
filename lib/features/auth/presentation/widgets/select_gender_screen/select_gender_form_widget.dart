import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/controller/profile_setup_controller.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/widgets.dart';

class SelectGenderFormWidget extends StatefulWidget {
  const SelectGenderFormWidget({super.key});

  @override
  State<SelectGenderFormWidget> createState() => _SelectGenderFormWidgetState();
}

class _SelectGenderFormWidgetState extends State<SelectGenderFormWidget> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGenderOption(
          'Male',
          'assets/icons/male_icon.svg',
          'assets/images/male_runner.png',
          'male',
        ),
        SizedBox(height: 14), // Exact spacing from Figma
        _buildGenderOption(
          'Female',
          'assets/icons/female_icon.svg',
          'assets/images/female_runner.png',
          'female',
        ),
        SizedBox(height: 40),
        // Continue Button
        PrimaryButtonWidget(
          text: 'Continue',
          onPressed:
              selectedGender != null
                  ? () {
                    // Update the profile setup controller
                    context.read<ProfileSetupController>().setGender(
                      selectedGender!,
                    );
                    // Navigate to weight screen
                    Navigator.of(context).pushNamed(Routes.selectWeightScreen);
                  }
                  : null,
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    String title,
    String iconPath,
    String imagePath,
    String value,
  ) {
    final isSelected = selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
      },
      child: Container(
        width: 344,
        height: 144,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F4), // Exact color from Figma
          borderRadius: BorderRadius.circular(14),
          border:
              isSelected
                  ? Border.all(
                    color: const Color(0xFF00AAFF),
                    width: 1,
                  ) // Exact blue from Figma
                  : null,
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(
                        0xFF00AAFF,
                      ).withOpacity(0.13), // Exact shadow from Figma
                      offset: const Offset(0, 0),
                      blurRadius: 0,
                      spreadRadius: 4,
                    ),
                  ]
                  : null,
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge, // Clip the overflow
          children: [
            // Main content frame - positioned exactly like Figma
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                width: 312,
                height: 112,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Icon + Text (24px height)
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            iconPath,
                            width: 24,
                            height: 24,
                            color: Color(
                              0xFF111214, // Exact color from Figma
                            ),
                          ),
                        ),
                        SizedBox(width: 4), // Exact spacing from Figma
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF111214),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Work Sans',
                            height: 1.0,
                            letterSpacing: -0.048,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 64), // Exact spacing from Figma
                    // Checkbox at bottom
                    SizedBox(
                      width: 24,
                      height: 24,
                      child:
                          isSelected
                              ? Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF111214),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                              : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF111214),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),

            // Background image contained within the card
            Positioned(
              right: 0,
              top: 0,
              left: title == 'Female' ? 20.w : 140.w,
              bottom: 0,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity(),
                child: Container(
                  width: 150, // Appropriate width to fit in card
                  height: 144, // Full height of the card
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage(imagePath),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
