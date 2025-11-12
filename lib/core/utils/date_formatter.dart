import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateFormatter {
  static String formatEventDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('EEE, MMM d • HH:mm');
      return formatter.format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  static String formatEventDateShort(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('EEE, MMM d • HH.mm');
      return formatter.format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  static String formatEventTime(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('HH:mm');
      return formatter.format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  static String formatEventDateWithTime(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('EEE, MMM d · HH:mm');
      return formatter.format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  static String formatEventDateForDetails(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('EEE, MMM d · HH:mm');
      return formatter.format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  static String getEndTime(String dateString, int durationHours) {
    try {
      final DateTime startDate = DateTime.parse(dateString);
      final DateTime endDate = startDate.add(Duration(hours: durationHours));
      final DateFormat formatter = DateFormat('HH:mm');
      return formatter.format(endDate);
    } catch (e) {
      return ''; // Return empty string if parsing fails
    }
  }

  /// Formats the current date in the home header format
  /// English: "Friday, 20 May"
  /// Arabic: "الجمعة، 20 مايو"
  static String getCurrentDateFormatted(BuildContext context) {
    final now = DateTime.now();
    final localeCode = context.locale.languageCode;

    // Format: Full day name, day number, full month name
    // English: "EEEE, d MMMM"
    // Arabic: "EEEE، d MMMM"
    final dateFormat =
        localeCode == 'ar'
            ? DateFormat('EEEE، d MMMM', 'ar')
            : DateFormat('EEEE, d MMMM', 'en');

    return dateFormat.format(now);
  }
}
