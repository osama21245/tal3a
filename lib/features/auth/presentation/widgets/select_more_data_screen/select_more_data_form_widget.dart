import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/widgets/widgets.dart';

class SelectMoreDataFormWidget extends StatefulWidget {
  const SelectMoreDataFormWidget({super.key});

  @override
  State<SelectMoreDataFormWidget> createState() =>
      _SelectMoreDataFormWidgetState();
}

class _SelectMoreDataFormWidgetState extends State<SelectMoreDataFormWidget> {
  // Controllers for text fields
  final TextEditingController _dayController = TextEditingController(
    text: '24',
  );
  final TextEditingController _monthController = TextEditingController(
    text: '04',
  );
  final TextEditingController _yearController = TextEditingController(
    text: '1989',
  );
  final TextEditingController _cityController = TextEditingController(
    text: 'Choose your City',
  );
  final TextEditingController _phoneController = TextEditingController();

  // Google Maps
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753), // Riyadh, Saudi Arabia
    zoom: 11.0,
  );

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date of Birth Label
        Text('date of birth', style: AppTextStyles.fieldLabelStyle),

        const SizedBox(height: 11),

        // Date Selection Row
        Row(
          children: [
            Expanded(
              child: CustomTextFieldWidget(
                controller: _dayController,
                hintText: 'Day',
                readOnly: true,
                onTap: () {
                  // TODO: Show day picker
                },
                suffixIcon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_down.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: CustomTextFieldWidget(
                controller: _monthController,
                hintText: 'Month',
                readOnly: true,
                onTap: () {
                  // TODO: Show month picker
                },
                suffixIcon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_down.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: CustomTextFieldWidget(
                controller: _yearController,
                hintText: 'Year',
                readOnly: true,
                onTap: () {
                  // TODO: Show year picker
                },
                suffixIcon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_down.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 11),

        // City Selection
        CustomTextFieldWidget(
          controller: _cityController,
          hintText: 'Choose your City',
          readOnly: true,
          onTap: () {
            // TODO: Show city picker
          },
          suffixIcon: SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              'assets/icons/arrow_down.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),

        const SizedBox(height: 11),

        // Phone Number Row
        Row(
          children: [
            Container(
              width: 120,
              height: 57,
              decoration: BoxDecoration(
                color: ColorPalette.cardGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 16,
                  top: 23,
                  bottom: 23,
                ),
                child: Row(
                  children: [
                    // Saudi Flag
                    Container(
                      width: 39,
                      height: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/saudi_flag.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('966+', style: AppTextStyles.inputTextStyle),
                    const Spacer(),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        'assets/icons/arrow_down.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: CustomTextFieldWidget(
                controller: _phoneController,
                hintText: 'phone',
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),

        const SizedBox(height: 11),

        // Google Maps Container
        Container(
          width: double.infinity,
          height: 186,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ColorPalette.secondaryBlue, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              markers: {
                const Marker(
                  markerId: MarkerId('current_location'),
                  position: LatLng(24.7136, 46.6753), // Riyadh coordinates
                  infoWindow: InfoWindow(
                    title: 'Current Location',
                    snippet: 'Riyadh, Saudi Arabia',
                  ),
                ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
