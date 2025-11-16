import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/features/activites/data/models/group_tal3a_location_model.dart';
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
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(24.7136, 46.6753); // Default to Riyadh

  @override
  void initState() {
    super.initState();
    // Load group tal3a locations from API when the widget initializes
    context.read<WalkCubit>().loadGroupTal3aLocations('walking');
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        if (state.status == WalkStatus.loading) {
          return _buildShimmerLocation();
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

  Widget _buildShimmerLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.h),

        // Title shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 220.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        SizedBox(height: 20.h),

        // Map shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        SizedBox(height: 20.h),

        // Warning text shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 260.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        SizedBox(height: 40.h),

        // Button shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapContainer(WalkState state) {
    final hasSelectedLocation = state.groupTal3aLocations.any(
      (loc) => loc.isSelected,
    );

    // Compute markers directly from state (no extra setState)
    final Set<Marker> markers =
        state.groupTal3aLocations.map((location) {
          final latLng = LatLng(
            location.location.latitude,
            location.location.longitude,
          );

          return Marker(
            markerId: MarkerId(location.locationName),
            position: latLng,
            infoWindow: InfoWindow(
              title: location.name,
              snippet: location.locationName,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              location.isSelected
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
            onTap: () => _selectLocation(location),
          );
        }).toSet();

    // If we have locations, use the first one as initial center
    if (state.groupTal3aLocations.isNotEmpty) {
      final first = state.groupTal3aLocations.first.location;
      _initialPosition = LatLng(first.latitude, first.longitude);
    }

    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              hasSelectedLocation
                  ? ColorPalette.progressActive
                  : ColorPalette.activityTextGrey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 12,
          ),
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: false,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, WalkState state) {
    final canContinue = state.groupTal3aLocations.any((loc) => loc.isSelected);

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

  void _selectLocation(GroupTal3aLocationModel location) async {
    final cubit = context.read<WalkCubit>();

    // Update selection in the list
    cubit.selectGroupTal3aLocation(location);

    // Animate camera to selected location
    final latLng = LatLng(
      location.location.latitude,
      location.location.longitude,
    );
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));

    // Load group tal3a details by location name
    await cubit.loadGroupTal3aByLocation(location.locationName);
  }

  void _continue(BuildContext context) {
    final walkCubit = context.read<WalkCubit>();

    // Ensure we have the group tal3a detail loaded
    if (walkCubit.state.selectedGroupTal3aDetail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading location details...'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
