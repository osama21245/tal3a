import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/controller/profile_setup_controller.dart';
import '../../../../../core/controller/user_controller.dart';

class SelectWeightFormWidget extends StatefulWidget {
  const SelectWeightFormWidget({super.key});

  @override
  State<SelectWeightFormWidget> createState() => _SelectWeightFormWidgetState();
}

class _SelectWeightFormWidgetState extends State<SelectWeightFormWidget> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  DateTime? _selectedBirthDate;
  bool _isKgSelected = true; // true for kg, false for lbs
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_onTextChanged);
    _heightController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isButtonEnabled =
          _weightController.text.isNotEmpty &&
          _heightController.text.isNotEmpty &&
          _selectedBirthDate != null;
    });

    // Update the profile setup controller
    context.read<ProfileSetupController>().setWeight(_weightController.text);
    context.read<ProfileSetupController>().setHeight(_heightController.text);

    // Update birth date if selected
    if (_selectedBirthDate != null) {
      final formattedDate =
          '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}';
      context.read<ProfileSetupController>().setBirthDate(formattedDate);
    }
  }

  void _toggleUnit() {
    setState(() {
      _isKgSelected = !_isKgSelected;
    });
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorPalette.primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
      _onTextChanged(); // Update the controller
    }
  }

  void _continue() {
    if (_isButtonEnabled && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      final profileController = context.read<ProfileSetupController>();

      // Debug: Check if we have all required data
      print('🔍 Profile Setup Data:');
      print('Interests: ${profileController.state.interests}');
      print('Gender: ${profileController.state.gender}');
      print('BirthDate: ${profileController.state.birthDate}');
      print('Weight: ${profileController.state.weight}');
      print('Height: ${profileController.state.height}');

      // Check if all required data is available
      if (!profileController.isComplete) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete all profile information first'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Complete profile setup and navigate to home
      profileController
          .completeProfileSetup()
          .then((_) {
            setState(() {
              _isLoading = false;
            });
            // Only mark profile setup as completed if API call succeeds
            // This will be handled by the BlocListener when state.isSuccess
          })
          .catchError((error) {
            setState(() {
              _isLoading = false;
            });
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to complete profile setup: $error'),
                backgroundColor: Colors.red,
              ),
            );
          });
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSetupController, ProfileSetupState>(
      listener: (context, state) {
        if (state.isSuccess) {
          print('🔍 Profile setup completed successfully!');
          // Only now mark profile setup as completed in UserController
          context.read<UserController>().completeProfileSetup();
          // Navigate to home screen
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state.isError) {
          print('🔍 Profile setup failed: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile setup failed: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          // Weight Question
          Text(
            'What Is Your Weight?',
            style: AppTextStyles.weightHeightQuestionStyle,
          ),

          const SizedBox(height: 20),

          // Unit Toggle
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: ColorPalette.unitToggleBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                // KG Tab
                Expanded(
                  child: GestureDetector(
                    onTap: _toggleUnit,
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            _isKgSelected
                                ? ColorPalette.unitToggleActive
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow:
                            _isKgSelected
                                ? [
                                  BoxShadow(
                                    color: ColorPalette.unitToggleActive
                                        .withOpacity(0.5),
                                    offset: const Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius: 4,
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          'kg',
                          style:
                              _isKgSelected
                                  ? AppTextStyles.unitToggleActiveStyle
                                  : AppTextStyles.unitToggleInactiveStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                // LBS Tab
                Expanded(
                  child: GestureDetector(
                    onTap: _toggleUnit,
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            !_isKgSelected
                                ? ColorPalette.unitToggleActive
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow:
                            !_isKgSelected
                                ? [
                                  BoxShadow(
                                    color: ColorPalette.unitToggleActive
                                        .withOpacity(0.5),
                                    offset: const Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius: 4,
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          'lbs',
                          style:
                              !_isKgSelected
                                  ? AppTextStyles.unitToggleActiveStyle
                                  : AppTextStyles.unitToggleInactiveStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Weight Input Field
          Container(
            width: double.infinity,
            height: 57,
            decoration: BoxDecoration(
              color: ColorPalette.weightHeightInputBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _weightController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: AppTextStyles.weightHeightInputStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '00,00 KG',
                hintStyle: AppTextStyles.weightHeightInputStyle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 19,
                  vertical: 23,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
            ),
          ),

          SizedBox(height: 50.h),

          // Birth Date Question
          Text(
            'What Is Your Birth Date?',
            style: AppTextStyles.weightHeightQuestionStyle,
          ),

          const SizedBox(height: 20),

          // Birth Date Picker Button
          GestureDetector(
            onTap: _selectBirthDate,
            child: Container(
              width: double.infinity,
              height: 57,
              decoration: BoxDecoration(
                color: ColorPalette.weightHeightInputBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color:
                          _selectedBirthDate != null
                              ? ColorPalette.primaryBlue
                              : ColorPalette.textGrey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedBirthDate != null
                          ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                          : 'Select Birth Date',
                      style:
                          _selectedBirthDate != null
                              ? AppTextStyles.weightHeightInputStyle.copyWith(
                                color: ColorPalette.black,
                              )
                              : AppTextStyles.weightHeightInputStyle.copyWith(
                                color: ColorPalette.textGrey,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 50.h),

          // Height Question
          Text(
            'What Is Your Height?',
            style: AppTextStyles.weightHeightQuestionStyle,
          ),

          const SizedBox(height: 20),

          // Height Input Field
          Container(
            width: double.infinity,
            height: 57,
            decoration: BoxDecoration(
              color: ColorPalette.weightHeightInputBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _heightController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: AppTextStyles.weightHeightInputStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0.00 CM',
                hintStyle: AppTextStyles.weightHeightInputStyle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 19,
                  vertical: 23,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Debug Button
          ElevatedButton(
            onPressed: () {
              final profileController = context.read<ProfileSetupController>();
              print('🔍 Current ProfileSetupController State:');
              print('Interests: ${profileController.state.interests}');
              print('Gender: ${profileController.state.gender}');
              print('BirthDate: ${profileController.state.birthDate}');
              print('Weight: ${profileController.state.weight}');
              print('Height: ${profileController.state.height}');
              print('Is Complete: ${profileController.isComplete}');
            },
            child: const Text('Debug State'),
          ),

          SizedBox(height: 20.h),

          // Continue Button
          PrimaryButtonWidget(
            text: _isLoading ? 'Completing Profile...' : 'Continue',
            onPressed: _isLoading ? null : _continue,
            isEnabled: _isButtonEnabled && !_isLoading,
          ),
        ],
      ),
    );
  }
}
