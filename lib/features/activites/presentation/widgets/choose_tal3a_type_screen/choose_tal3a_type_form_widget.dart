import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/features/activites/presentation/controllers/tal3a_type_state.dart';
import 'package:tal3a/features/activites/presentation/screens/walk/walk_choose_type_screen.dart';
import 'package:tal3a/features/activites/presentation/screens/biking/biking_choose_type_screen.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../controllers/choose_tal3a_type_cubit.dart';
import '../../controllers/walk_cubit.dart';
import '../../controllers/biking_cubit.dart';
import '../../../../../core/routing/navigation_helper.dart';

class ChooseTal3aTypeFormWidget extends StatefulWidget {
  const ChooseTal3aTypeFormWidget({super.key});

  @override
  State<ChooseTal3aTypeFormWidget> createState() =>
      _ChooseTal3aTypeFormWidgetState();
}

class _ChooseTal3aTypeFormWidgetState extends State<ChooseTal3aTypeFormWidget> {
  String? _selectedActivity;
  bool _isButtonEnabled = false;

  List<Tal3aTypeData> get _activities => [
    Tal3aTypeData(
      id: 'walking',
      name: 'activities.walking'.tr(),
      iconPath: 'assets/icons/walking_icon.svg',
    ),
    Tal3aTypeData(
      id: 'biking',
      name: 'activities.biking'.tr(),
      iconPath: 'assets/icons/biking_icon.svg',
    ),
    Tal3aTypeData(
      id: 'training',
      name: 'activities.training'.tr(),
      iconPath: 'assets/icons/weightlift_icon.svg',
    ),
  ];

  void _selectActivity(String activityId) {
    setState(() {
      _selectedActivity = activityId;
      _isButtonEnabled = true;
    });
  }

  void _continue() {
    if (_isButtonEnabled && _selectedActivity != null) {
      // Update ChooseTal3aTypeCubit with selected feature
      context.read<ChooseTal3aTypeCubit>().selectFeature(_selectedActivity!);

      // Navigate to appropriate screen based on selection
      if (_selectedActivity == 'training') {
        // Create TrainingCubit and pass it through navigation
        NavigationHelper.goToTrainingChooseCoach(context);
      } else if (_selectedActivity == 'walking') {
        // Navigate to walk feature
        NavigationHelper.goToWalkChooseType(context);
      } else if (_selectedActivity == 'biking') {
        // Navigate to biking feature
        NavigationHelper.goToBikingChooseType(context);
      } else {
        // TODO: Navigate to other activity screens
        print('Selected activity: $_selectedActivity');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),

        // Title
        Text(
          'activities.tal3a_type'.tr(),
          style: AppTextStyles.activityTypeTitleStyle,
        ),

        const SizedBox(height: 20),

        // Activity Cards
        Row(
          children:
              _activities.map((activity) {
                final isSelected = _selectedActivity == activity.id;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _selectActivity(activity.id),
                    child: Container(
                      height: 115,
                      margin: const EdgeInsets.only(right: 13),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? ColorPalette.activityCardSelected
                                : ColorPalette.activityCardBg,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: ColorPalette.activityCardSelected
                                        .withOpacity(0.35),
                                    offset: const Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius: 4,
                                  ),
                                ]
                                : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon with SVG
                          Container(
                            width: 48,
                            height: 48,
                            child: SvgPicture.asset(
                              _getActivityIconPath(activity.id),
                              width: 40,
                              height: 40,
                              color: Color(
                                isSelected ? 0xFFFFFFFF : 0xFF9BA8AF,
                              ),
                            ),
                          ),

                          // Activity name
                          Text(
                            activity.name,
                            style:
                                isSelected
                                    ? AppTextStyles
                                        .activityCardSelectedTextStyle
                                    : AppTextStyles.activityCardTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),

        SizedBox(height: 310.h),

        // Continue Button
        PrimaryButtonWidget(
          text: 'common.continue'.tr(),
          onPressed: _continue,
          isEnabled: _isButtonEnabled,
        ),
      ],
    );
  }

  String _getActivityIconPath(String activityId) {
    switch (activityId) {
      case 'walking':
        return 'assets/icons/1on1.svg';
      case 'biking':
        return 'assets/icons/1on1biking.svg';
      case 'training':
        return 'assets/icons/weightlift_icon.svg';
      default:
        return 'assets/icons/1on1.svg';
    }
  }
}
