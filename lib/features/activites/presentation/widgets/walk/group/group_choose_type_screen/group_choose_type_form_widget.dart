import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/features/activites/data/models/group_type_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_state.dart';
import 'package:tal3a/features/activites/presentation/screens/walk/group/group_choose_location_screen.dart';
import 'package:tal3a/core/utils/animation_helper.dart';

class GroupChooseTypeFormWidget extends StatelessWidget {
  // Static group types data (as requested)
  List<GroupTypeModel> get _groupTypes => [
    GroupTypeModel(
      id: 'group_ma',
      name: 'activities.group_ma'.tr(),
      iconPath: 'assets/icons/groupman.svg',
      isSelected: false,
    ),
    GroupTypeModel(
      id: 'mix_group',
      name: 'activities.mix_group'.tr(),
      iconPath: 'assets/icons/mixgroup.svg',
      isSelected: false,
    ),
    GroupTypeModel(
      id: 'group_wo',
      name: 'activities.group_wo'.tr(),
      iconPath: 'assets/icons/groupwoman.svg',
      isSelected: false,
    ),
  ];

  const GroupChooseTypeFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'activities.tal3a_type'.tr(),
                style: AppTextStyles.trainingTitleStyle.copyWith(
                  color: ColorPalette.activityTextGrey,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Group Types Grid with animations
            _buildGroupTypesGrid(context, state),

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

  Widget _buildGroupTypesGrid(BuildContext context, WalkState state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.85,
      ),
      itemCount: _groupTypes.length,
      itemBuilder: (context, index) {
        final groupType = _groupTypes[index];
        final isSelected = state.selectedGroupType?.id == groupType.id;

        return AnimationHelper.cardAnimation(
          index: index,
          child: GestureDetector(
            onTap: () => _selectGroupType(context, groupType),
            child: _buildGroupTypeCard(groupType, isSelected),
          ),
        );
      },
    );
  }

  Widget _buildGroupTypeCard(GroupTypeModel groupType, bool isSelected) {
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
              groupType.iconPath,
              width: 40,
              height: 40,
              color: Color(isSelected ? 0xFFFFFFFF : 0xFF9BA8AF),
            ),
          ),

          SizedBox(height: 8.h),

          // Name
          Text(
            groupType.name,
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

  Widget _buildContinueButton(BuildContext context, WalkState state) {
    final canContinue = state.selectedGroupType != null;

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
          'common.continue'.tr(),
          style: AppTextStyles.trainingTitleStyle.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _selectGroupType(BuildContext context, GroupTypeModel groupType) {
    context.read<WalkCubit>().selectGroupType(groupType);
  }

  void _continue(BuildContext context) {
    final walkCubit = context.read<WalkCubit>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: walkCubit,
              child: const GroupChooseLocationScreen(),
            ),
      ),
    );
  }
}
