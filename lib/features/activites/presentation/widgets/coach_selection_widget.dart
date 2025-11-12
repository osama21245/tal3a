import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/text_style.dart';
import '../controllers/tal3a_type_state.dart';

class CoachSelectionWidget extends StatelessWidget {
  final List<CoachData> coaches;
  final String? selectedCoachId;
  final Function(String) onCoachSelected;

  const CoachSelectionWidget({
    super.key,
    required this.coaches,
    this.selectedCoachId,
    required this.onCoachSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row of coaches with staggered animations
        Row(
          children:
              coaches.take(3).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final coach = entry.value;
                return Expanded(
                  child: FadeInUp(
                    duration: Duration(milliseconds: 600 + (index * 200)),
                    delay: Duration(milliseconds: index * 100),
                    child: SlideInUp(
                      duration: Duration(milliseconds: 600 + (index * 200)),
                      delay: Duration(milliseconds: index * 100),
                      child: BounceInUp(
                        duration: Duration(milliseconds: 800 + (index * 200)),
                        delay: Duration(milliseconds: index * 100),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 13),
                          child: _buildCoachCard(coach),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),

        if (coaches.length > 3) ...[
          const SizedBox(height: 20),
          // Second row of coaches with staggered animations
          Row(
            children:
                coaches.skip(3).take(3).toList().asMap().entries.map((entry) {
                  final index = entry.key + 3; // Offset for second row
                  final coach = entry.value;
                  return Expanded(
                    child: FadeInUp(
                      duration: Duration(milliseconds: 600 + (index * 200)),
                      delay: Duration(milliseconds: index * 100),
                      child: SlideInUp(
                        duration: Duration(milliseconds: 600 + (index * 200)),
                        delay: Duration(milliseconds: index * 100),
                        child: BounceInUp(
                          duration: Duration(milliseconds: 800 + (index * 200)),
                          delay: Duration(milliseconds: index * 100),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 13),
                            child: _buildCoachCard(coach),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildCoachCard(CoachData coach) {
    final isSelected = selectedCoachId == coach.id;

    return GestureDetector(
      onTap: () => onCoachSelected(coach.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 137.h,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? ColorPalette.coachCardSelected
                  : ColorPalette.coachCardBg,
          borderRadius: BorderRadius.circular(8),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF00AAFF).withOpacity(0.35),
                      spreadRadius: 4,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          children: [
            // Coach Image
            Container(
              height: 59.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child:
                    coach.imageUrl != null
                        ? Image.asset(coach.imageUrl!, fit: BoxFit.cover)
                        : Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: 30,
                          ),
                        ),
              ),
            ),

            // Coach Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Coach Name
                    _buildCoachNameWithDifferentWeights(coach.name, isSelected),

                    const SizedBox(height: 1),

                    // Coach Title
                    Text(
                      coach.title,
                      style:
                          isSelected
                              ? AppTextStyles.coachTitleSelectedStyle
                              : AppTextStyles.coachTitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? ColorPalette.ratingBg
                                : ColorPalette.ratingBg,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: ColorPalette.starColor,
                            size: 10,
                          ),
                          const SizedBox(width: 1),
                          Text(
                            coach.rating.toString(),
                            style: AppTextStyles.ratingTextStyle.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachNameWithDifferentWeights(String name, bool isSelected) {
    // Parse the name to identify different parts
    // Example: "Capt.george n." -> "Capt." (light), "george" (bold), " n." (light)
    final parts = _parseCoachName(name);

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children:
            parts.map((part) {
              return TextSpan(
                text: part.text,
                style:
                    part.isBold
                        ? (isSelected
                            ? AppTextStyles.coachNameBoldStyle
                            : _getBoldUnselectedStyle())
                        : (isSelected
                            ? AppTextStyles.coachNameLightStyle
                            : _getLightUnselectedStyle()),
              );
            }).toList(),
      ),
    );
  }

  TextStyle _getBoldUnselectedStyle() {
    return AppTextStyles.coachNameBoldStyle.copyWith(
      color: ColorPalette.textDark,
    );
  }

  TextStyle _getLightUnselectedStyle() {
    return AppTextStyles.coachNameLightStyle.copyWith(
      color: ColorPalette.textDark,
    );
  }

  List<_NamePart> _parseCoachName(String name) {
    // Super simple: Just two parts - "Capt." (light) and everything else (bold)

    if (name.toLowerCase().startsWith('capt.')) {
      final withoutCapt = name.substring(5).trim(); // Remove "Capt." and trim
      return [
        _NamePart('Capt.', false), // "Capt." (light)
        _NamePart(withoutCapt, true), // Everything else (bold)
      ];
    }

    // Fallback: if no "Capt.", make the whole name bold
    return [_NamePart(name, true)];
  }
}

class _NamePart {
  final String text;
  final bool isBold;

  _NamePart(this.text, this.isBold);
}
