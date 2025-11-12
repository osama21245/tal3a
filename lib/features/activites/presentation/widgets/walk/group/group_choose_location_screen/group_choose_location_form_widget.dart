import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/features/activites/data/models/group_location_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/walk_state.dart';
import 'package:tal3a/features/activites/presentation/screens/walk/group/group_choose_time_screen.dart';
import 'package:tal3a/core/utils/animation_helper.dart';

class GroupChooseLocationFormWidget extends StatefulWidget {
  const GroupChooseLocationFormWidget({super.key});

  @override
  State<GroupChooseLocationFormWidget> createState() =>
      _GroupChooseLocationFormWidgetState();
}

class _GroupChooseLocationFormWidgetState
    extends State<GroupChooseLocationFormWidget> {
  @override
  void initState() {
    super.initState();
    // Load group locations when the widget initializes
    context.read<WalkCubit>().loadGroupLocations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        if (state.status == WalkStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == WalkStatus.error) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            AnimationHelper.titleAnimation(
              child: Text(
                'Choosing the location',
                style: AppTextStyles.trainingTitleStyle.copyWith(
                  color: ColorPalette.activityTextGrey,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Google Map Container
            AnimationHelper.slideUp(child: _buildMapContainer(state)),

            SizedBox(height: 20.h),

            // Warning Text
            AnimationHelper.fadeIn(
              child: Text(
                'All sessions are monitored under Saudi regulations',
                style: AppTextStyles.trainingTitleStyle.copyWith(
                  color: ColorPalette.warningColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 40), // Fixed spacing instead of Spacer
            // Continue Button
            AnimationHelper.slideUp(
              child: _buildContinueButton(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMapContainer(WalkState state) {
    return Container(
      width: double.infinity,
      height: 315.h,
      decoration: BoxDecoration(
        color: ColorPalette.cardGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              state.selectedGroupLocation != null
                  ? ColorPalette.progressActive
                  : ColorPalette.activityTextGrey.withOpacity(0.3),
          width: 2,
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/map_placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Location markers based on available locations
          ...state.groupLocations.map((location) {
            return Positioned(
              left: _getLocationPosition(location.id).dx,
              top: _getLocationPosition(location.id).dy,
              child: GestureDetector(
                onTap: () => _selectLocation(location),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        location.isSelected
                            ? ColorPalette.progressActive
                            : ColorPalette.locationMarkerBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.location_on, color: Colors.white, size: 24),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, WalkState state) {
    final canContinue = state.selectedGroupLocation != null;

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

  Offset _getLocationPosition(String locationId) {
    // Mock positions for different locations on the map
    switch (locationId) {
      case 'location_1':
        return const Offset(80, 100); // King Fahd Park
      case 'location_2':
        return const Offset(200, 50); // Al Bujairi Heritage Park
      case 'location_3':
        return const Offset(150, 200); // Wadi Hanifa
      case 'location_4':
        return const Offset(250, 150); // King Abdullah Park
      default:
        return const Offset(150, 100); // Default position
    }
  }

  void _selectLocation(GroupLocationModel location) {
    context.read<WalkCubit>().selectGroupLocation(location);
  }

  void _continue(BuildContext context) {
    final walkCubit = context.read<WalkCubit>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: walkCubit,
              child: const GroupChooseTimeScreen(),
            ),
      ),
    );
  }
}
