import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:tal3a/core/routing/routes.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../data/models/biking_time_model.dart';
import '../../../controllers/biking_cubit.dart';
import '../../../controllers/biking_state.dart';

class BikingChooseTimeFormWidget extends StatefulWidget {
  const BikingChooseTimeFormWidget({super.key});

  @override
  State<BikingChooseTimeFormWidget> createState() =>
      _BikingChooseTimeFormWidgetState();
}

class _BikingChooseTimeFormWidgetState
    extends State<BikingChooseTimeFormWidget> {
  BikingTimeModel? _selectedBikingTime;
  bool _isButtonEnabled = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  List<DateTime> _getNextDays(int count) {
    final now = DateTime.now();
    final days = <DateTime>[];
    for (int i = 0; i < count; i++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: i));
      days.add(date);
    }
    return days;
  }

  String _getDayName(DateTime date) {
    // DateTime.weekday: Monday = 1, Tuesday = 2, ..., Sunday = 7
    // We want: Sunday = 0, Monday = 1, ..., Saturday = 6
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final weekday = date.weekday; // 1 (Monday) to 7 (Sunday)
    // Convert: Monday (1) -> 1, Sunday (7) -> 0
    final index = weekday == 7 ? 0 : weekday;
    return dayNames[index];
  }

  String _getDayNumber(DateTime date) {
    return date.day.toString();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      // Update the scheduled time with the new date if time is already selected
      if (_selectedBikingTime != null &&
          _selectedBikingTime!.scheduledAt != null) {
        final oldDateTime = _selectedBikingTime!.scheduledAt!;
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          oldDateTime.hour,
          oldDateTime.minute,
        );
        _selectedBikingTime = _selectedBikingTime!.copyWith(
          scheduledAt: newDateTime,
        );
      }
    });
  }

  Future<void> _pickCustomTime() async {
    // Set initial time to currently selected time, or current time if none selected
    TimeOfDay initialTime = TimeOfDay.now();
    if (_selectedBikingTime != null &&
        _selectedBikingTime!.scheduledAt != null) {
      final scheduledDateTime = _selectedBikingTime!.scheduledAt!;
      initialTime = TimeOfDay(
        hour: scheduledDateTime.hour,
        minute: scheduledDateTime.minute,
      );
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorPalette.primaryBlue,
              onPrimary: Colors.white,
              onSurface: ColorPalette.textDark,
              surface: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: ColorPalette.primaryBlue, width: 2),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: ColorPalette.primaryBlue, width: 2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              dialHandColor: ColorPalette.primaryBlue,
              dialBackgroundColor: ColorPalette.cardGrey,
              hourMinuteTextColor: ColorPalette.textDark,
              dayPeriodTextColor: ColorPalette.textDark,
              entryModeIconColor: ColorPalette.primaryBlue,
              helpTextStyle: TextStyle(
                color: ColorPalette.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              hourMinuteTextStyle: TextStyle(
                color: ColorPalette.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              dayPeriodTextStyle: TextStyle(
                color: ColorPalette.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format time to match existing timeSlot format (e.g., "3:30 PM")
      final hour = picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final timeSlot = '$hour:$minute $period';

      // Create a custom BikingTimeModel
      final customTime = BikingTimeModel(
        id: 'custom_${picked.hour}_${picked.minute}',
        timeSlot: timeSlot,
        description: 'Custom Time',
        scheduledAt: _getScheduledDateTime(picked),
      );

      setState(() {
        _selectedBikingTime = customTime;
        _isButtonEnabled = true;
      });
    }
  }

  DateTime _getScheduledDateTime(TimeOfDay timeOfDay) {
    var hour = timeOfDay.hour;
    final minute = timeOfDay.minute;

    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      minute,
    );
  }

  Future<void> _save() async {
    if (_isButtonEnabled && _selectedBikingTime != null) {
      // Update BikingCubit with selected biking time
      context.read<BikingCubit>().selectBikingTime(_selectedBikingTime!);

      setState(() {
        _isButtonEnabled = false;
      });

      final bikingCubit = context.read<BikingCubit>();
      bikingCubit.addNavigationNode(
        'BikingChooseTimeScreen',
        data: {'selectedBikingTime': _selectedBikingTime!.toJson()},
      );

      await bikingCubit.sendBikingRequest();

      if (!mounted) return;

      final state = bikingCubit.state;
      if (state.error != null) {
        setState(() {
          _isButtonEnabled = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error ?? 'Failed to send request.')),
        );
      } else if (!state.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request sent successfully!')),
        );
        // Navigate back to home
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Calendar Section
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  // Today's Pick Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'activities.today_pick'.tr(),
                      style: AppTextStyles.activityTypeTitleStyle,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Calendar Days - Scrollable
                  SizedBox(
                    height: 76,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 30, // Show 30 days
                      itemBuilder: (context, index) {
                        final date = _getNextDays(30)[index];
                        return Padding(
                          padding: EdgeInsets.only(right: index < 29 ? 12 : 0),
                          child: _buildCalendarDay(
                            _getDayNumber(date),
                            _getDayName(date),
                            _isSameDay(date, _selectedDate),
                            date,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Choose the time title
            Text(
              'activities.choose_the_time'.tr(),
              style: AppTextStyles.activityTypeTitleStyle,
            ),

            const SizedBox(height: 20),

            // Custom Time Picker - Prominent Design
            _buildCustomTimePicker(),

            const SizedBox(height: 40),

            // Save Button
            PrimaryButtonWidget(
              text: state.isLoading ? 'Sending...' : 'common.save'.tr(),
              onPressed: state.isLoading ? null : _save,
              isEnabled: _isButtonEnabled && !state.isLoading,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarDay(
    String day,
    String dayName,
    bool isSelected,
    DateTime date,
  ) {
    return GestureDetector(
      onTap: () => _selectDate(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 54,
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color:
                isSelected
                    ? ColorPalette.primaryBlue
                    : ColorPalette.primaryBlue.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: ColorPalette.primaryBlue.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color:
                    isSelected
                        ? ColorPalette.primaryBlue
                        : ColorPalette.textDark,
                fontSize: isSelected ? 25 : 20,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontFamily: 'Rubik',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dayName,
              style: TextStyle(
                color:
                    isSelected
                        ? ColorPalette.primaryBlue
                        : ColorPalette.progressInactive,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
                fontFamily: 'Rubik',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTimePicker() {
    final isSelected = _selectedBikingTime != null;

    return GestureDetector(
      onTap: _pickCustomTime,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? ColorPalette.primaryBlue
                    : ColorPalette.primaryBlue.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? ColorPalette.primaryBlue.withOpacity(0.15)
                      : ColorPalette.primaryBlue.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon with background circle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ColorPalette.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorPalette.primaryBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.access_time_rounded,
                color: ColorPalette.primaryBlue,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              isSelected && _selectedBikingTime != null
                  ? _selectedBikingTime!.timeSlot
                  : 'activities.select_time'.tr(),
              style: TextStyle(
                color:
                    isSelected
                        ? ColorPalette.primaryBlue
                        : ColorPalette.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Rubik',
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              isSelected
                  ? 'Tap to change time'
                  : 'Tap to select your preferred time',
              style: TextStyle(
                color: ColorPalette.textGrey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Rubik',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
