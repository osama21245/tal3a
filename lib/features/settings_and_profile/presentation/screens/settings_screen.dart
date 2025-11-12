import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';

import '../../../../core/const/color_pallete.dart';
import '../../../../core/utils/animation_helper.dart';
import '../widgets/settings_screen/settings_tab_selector_widget.dart';
import '../widgets/settings_screen/settings_profile_card_widget.dart';
import '../widgets/settings_screen/settings_menu_list_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isProfileSelected = true;

  void _onTabChanged(bool selected) {
    setState(() {
      isProfileSelected = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.settingsMainBg,
      body: Column(
        children: [
          // Header with Training App Bar
          CustomAppBar(
            title: 'Settings',
            onBackPressed: () => Navigator.of(context).pop(),
          ),

          // Main Content
          Expanded(
            child: Container(
              color: ColorPalette.settingsMainBg,
              child: Column(
                children: [
                  // Tab Selector with subtle animation
                  AnimationHelper.fadeIn(
                    duration: const Duration(milliseconds: 300),
                    child: SettingsTabSelectorWidget(
                      isProfileSelected: isProfileSelected,
                      onTabChanged: _onTabChanged,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Content based on selected tab
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Profile Card with smooth fade in
                          if (isProfileSelected) ...[
                            AnimationHelper.fadeIn(
                              duration: const Duration(milliseconds: 400),
                              child: SettingsProfileCardWidget(),
                            ),
                            SizedBox(height: 8.h),
                          ],

                          // Settings Menu List with consistent animation
                          AnimationHelper.fadeIn(
                            duration: const Duration(milliseconds: 500),
                            delay: const Duration(milliseconds: 100),
                            child: SettingsMenuListWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
