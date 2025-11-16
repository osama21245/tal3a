import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/const/text_style.dart';
import 'package:tal3a/core/utils/animation_helper.dart';
import 'package:tal3a/core/widgets/widgets.dart';
import 'package:tal3a/features/activites/data/models/walk_location_model.dart';

import '../../../controllers/walk_cubit.dart';
import '../../../controllers/walk_state.dart';
import '../../../screens/walk/walk_choose_time_screen.dart';

class WalkChooseLocationFormWidget extends StatefulWidget {
  const WalkChooseLocationFormWidget({super.key});

  @override
  State<WalkChooseLocationFormWidget> createState() =>
      _WalkChooseLocationFormWidgetState();
}

class _WalkChooseLocationFormWidgetState
    extends State<WalkChooseLocationFormWidget> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(24.7136, 46.6753);
  LatLng? _selectedLatLng;
  String? _selectedAddress;
  bool _isReverseGeocoding = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    final selectedLocation =
        context.read<WalkCubit>().state.selectedWalkLocation;
    if (selectedLocation != null) {
      final latLng = LatLng(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );
      _selectedLatLng = latLng;
      _selectedAddress = selectedLocation.locationName;
      _initialPosition = latLng;
      _isButtonEnabled = true;
    }
  }

  Future<void> _handleTap(LatLng position) async {
    setState(() {
      _selectedLatLng = position;
      _isButtonEnabled = true;
      _isReverseGeocoding = true;
    });

    final address = await _reverseGeocode(position);

    if (!mounted) return;

    setState(() {
      _selectedAddress = address;
      _isReverseGeocoding = false;
    });

    if (_mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.newLatLng(position));
    }
  }

  void _continue() {
    if (!_isButtonEnabled || _selectedLatLng == null) {
      return;
    }

    final walkCubit = context.read<WalkCubit>();
    final locationName =
        _selectedAddress ??
        '${_selectedLatLng!.latitude.toStringAsFixed(5)}, '
            '${_selectedLatLng!.longitude.toStringAsFixed(5)}';

    final walkLocation = WalkLocationModel(
      id: 'walk_location_${DateTime.now().millisecondsSinceEpoch}',
      name: locationName,
      locationName: locationName,
      latitude: _selectedLatLng!.latitude,
      longitude: _selectedLatLng!.longitude,
      isSelected: true,
    );

    walkCubit.selectWalkLocation(walkLocation);
    walkCubit.addNavigationNode(
      'WalkChooseLocationScreen',
      data: {'selectedWalkLocation': walkLocation.toJson()},
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: walkCubit,
              child: const WalkChooseTimeScreen(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choosing the location',
                  style: AppTextStyles.activityTypeTitleStyle,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 13,
                      ),
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: false,
                      markers:
                          _selectedLatLng != null
                              ? {
                                Marker(
                                  markerId: const MarkerId('selected_location'),
                                  position: _selectedLatLng!,
                                  infoWindow: InfoWindow(
                                    title:
                                        _selectedAddress ?? 'Selected location',
                                  ),
                                ),
                              }
                              : <Marker>{},
                      onTap: _handleTap,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimationHelper.fadeIn(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorPalette.friendCardUnselected,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.place,
                              color: ColorPalette.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedAddress ??
                                    'Tap on the map to select a location',
                                style: AppTextStyles.friendCardDetailsStyle,
                              ),
                            ),
                          ],
                        ),
                        if (_isReverseGeocoding) ...[
                          const SizedBox(height: 12),
                          const LinearProgressIndicator(),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: AnimationHelper.buttonAnimation(
                isVisible: _selectedLatLng != null,
                child: SafeArea(
                  child: PrimaryButtonWidget(
                    text: 'common.continue'.tr(),
                    onPressed: _isButtonEnabled ? _continue : null,
                    isEnabled: _isButtonEnabled,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> _reverseGeocode(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final buffer = StringBuffer();

        if (place.name != null && place.name!.isNotEmpty) {
          buffer.write(place.name);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          if (buffer.isNotEmpty) buffer.write(', ');
          buffer.write(place.locality);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          if (buffer.isNotEmpty) buffer.write(', ');
          buffer.write(place.country);
        }

        if (buffer.isNotEmpty) {
          return buffer.toString();
        }
      }
    } catch (_) {
      // Ignore geocoding errors and fall back to coordinates.
    }

    return 'Lat: ${position.latitude.toStringAsFixed(5)}, '
        'Lng: ${position.longitude.toStringAsFixed(5)}';
  }
}
