import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/widgets/primary_button_widget.dart';
import 'package:tal3a/features/activites/data/models/group_tal3a_location_model.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/biking_state.dart';
import 'package:tal3a/features/activites/presentation/screens/biking/group/biking_group_choose_time_screen.dart';
import 'package:tal3a/core/utils/animation_helper.dart';

class BikingGroupChooseLocationFormWidget extends StatefulWidget {
  const BikingGroupChooseLocationFormWidget({super.key});

  @override
  State<BikingGroupChooseLocationFormWidget> createState() =>
      _BikingGroupChooseLocationFormWidgetState();
}

class _BikingGroupChooseLocationFormWidgetState
    extends State<BikingGroupChooseLocationFormWidget> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(24.7136, 46.6753); // Default to Riyadh

  @override
  void initState() {
    super.initState();
    // Load group tal3a locations from API when the widget initializes
    context.read<BikingCubit>().loadGroupTal3aLocations('biking');
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _selectBikingGroupLocation(
    BuildContext context,
    GroupTal3aLocationModel location,
  ) async {
    final cubit = context.read<BikingCubit>();

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
    final bikingCubit = context.read<BikingCubit>();

    // Ensure we have the group tal3a detail loaded
    if (bikingCubit.state.selectedGroupTal3aDetail == null) {
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
              value: bikingCubit,
              child: const BikingGroupChooseTimeScreen(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        if (state.isLoading && state.groupTal3aLocations.isEmpty) {
          return _buildShimmerLocation();
        }

        if (state.error != null && state.groupTal3aLocations.isEmpty) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final hasSelectedLocation = state.groupTal3aLocations.any(
          (loc) => loc.isSelected,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Title with fade-in animation
            AnimationHelper.titleAnimation(
              child: Text(
                'Choose Biking Location',
                style: AppTextStyles.activityTypeTitleStyle,
              ),
            ),
            const SizedBox(height: 20),

            // Google Map Container
            AnimationHelper.slideUp(child: _buildMapContainer(state)),

            SizedBox(height: 20.h),

            const SizedBox(height: 40),

            // Continue Button with fade-in animation
            AnimationHelper.slideUp(
              child: PrimaryButtonWidget(
                text: 'Continue',
                onPressed:
                    hasSelectedLocation ? () => _continue(context) : null,
                isEnabled: hasSelectedLocation,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMapContainer(BikingState state) {
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
            onTap: () => _selectBikingGroupLocation(context, location),
          );
        }).toSet();

    // If we have locations, use the first one as initial center
    if (state.groupTal3aLocations.isNotEmpty) {
      final first = state.groupTal3aLocations.first.location;
      _initialPosition = LatLng(first.latitude, first.longitude);
    }

    return Container(
      width: double.infinity,
      height: 315.h,
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
            height: 315.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        SizedBox(height: 20.h),

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
}
