import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/features/activites/data/models/biking_group_type_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_state.dart';
import 'package:tal3a/features/activites/presentation/screens/biking/group/biking_group_choose_location_screen.dart';
import 'package:tal3a/core/utils/animation_helper.dart';

class BikingGroupChooseTypeFormWidget extends StatelessWidget {
  // Static biking group types data
  static const List<BikingGroupTypeModel> _bikingGroupTypes = [
    BikingGroupTypeModel(
      id: 'group_ma',
      name: 'Group Ma',
      iconPath: 'assets/icons/groupman.svg',
      isSelected: false,
    ),
    BikingGroupTypeModel(
      id: 'mix_group',
      name: 'Mix Group',
      iconPath: 'assets/icons/mixgroup.svg',
      isSelected: false,
    ),
    BikingGroupTypeModel(
      id: 'group_wo',
      name: 'Group wo',
      iconPath: 'assets/icons/groupwoman.svg',
      isSelected: false,
    ),
  ];

  const BikingGroupChooseTypeFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'With Who?',
                style: AppTextStyles.trainingTitleStyle.copyWith(
                  color: ColorPalette.activityTextGrey,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Biking Group Types Grid with animations
            _buildBikingGroupTypesGrid(context, state),

            SizedBox(height: 40), // Fixed spacing instead of Spacer
            // Continue Button with fade-in animation
            AnimationHelper.slideUp(
              child: _buildContinueButton(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBikingGroupTypesGrid(BuildContext context, BikingState state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.85,
      ),
      itemCount: _bikingGroupTypes.length,
      itemBuilder: (context, index) {
        final bikingGroupType = _bikingGroupTypes[index];
        final isSelected =
            state.selectedBikingGroupType?.id == bikingGroupType.id;

        return AnimationHelper.cardAnimation(
          index: index,
          child: GestureDetector(
            onTap: () => _selectBikingGroupType(context, bikingGroupType),
            child: _buildBikingGroupTypeCard(bikingGroupType, isSelected),
          ),
        );
      },
    );
  }

  Widget _buildBikingGroupTypeCard(
    BikingGroupTypeModel bikingGroupType,
    bool isSelected,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? ColorPalette.progressActive : ColorPalette.cardGrey,
        borderRadius: BorderRadius.circular(14),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: ColorPalette.progressActive.withOpacity(0.35),
                    offset: const Offset(0, 0),
                    blurRadius: 0,
                    spreadRadius: 3,
                  ),
                ]
                : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: SvgPicture.asset(
              bikingGroupType.iconPath,
              width: 40,
              height: 40,
              color: Color(isSelected ? 0xFFFFFFFF : 0xFF9BA8AF),
            ),
          ),

          SizedBox(height: 8.h),

          // Name
          Text(
            bikingGroupType.name,
            style: AppTextStyles.trainingTitleStyle.copyWith(
              color: isSelected ? Colors.white : ColorPalette.activityTextGrey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, BikingState state) {
    final canContinue = state.selectedBikingGroupType != null;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: canContinue ? () => _continue(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canContinue
                  ? ColorPalette.progressActive
                  : ColorPalette.progressInactive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Continue',
          style: AppTextStyles.trainingTitleStyle.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _selectBikingGroupType(
    BuildContext context,
    BikingGroupTypeModel bikingGroupType,
  ) {
    context.read<BikingCubit>().selectBikingGroupType(bikingGroupType);
  }

  void _continue(BuildContext context) {
    final bikingCubit = context.read<BikingCubit>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: bikingCubit,
              child: const BikingGroupChooseLocationScreen(),
            ),
      ),
    );
  }
}
