import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import '../../../../../core/routing/routes.dart';
import '../../controllers/settings_cubit.dart';
import '../../controllers/settings_state.dart';

class SettingsMenuListWidget extends StatelessWidget {
  const SettingsMenuListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        bool isNotificationEnabled = state.isNotificationEnabled;

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Change Password
            _buildMenuItem(
              icon: 'assets/icons/change_password.svg',
              title: 'Change Password',
              onTap: () {
                Navigator.of(context).pushNamed(Routes.changePasswordScreen);
              },
            ),

            SizedBox(height: 16.h),

            // Payment Method
            _buildMenuItem(
              icon: 'assets/icons/payment_method.svg',
              title: 'Payment Method',
              onTap: () {
                // Handle payment method
              },
            ),

            SizedBox(height: 16.h),

            // Notification
            _buildNotificationMenuItem(
              icon: 'assets/icons/settings_notification.svg',
              title: 'Notification',
              isEnabled: isNotificationEnabled,
              onToggle: (value) {
                context.read<SettingsCubit>().toggleNotification(value);
              },
            ),

            SizedBox(height: 16.h),

            // Language
            _buildMenuItem(
              icon: 'assets/icons/setting_language.svg',
              title: 'Language',
              onTap: () {
                // Handle language
              },
            ),

            SizedBox(height: 16.h),

            // Terms & Condition
            _buildMenuItem(
              icon: 'assets/icons/Danger Triangle.svg',
              title: 'Terms & Condition',
              onTap: () {
                // Handle terms & condition
              },
            ),

            SizedBox(height: 16.h),

            // Help and Support
            _buildMenuItem(
              icon: 'assets/icons/Danger Triangle.svg',
              title: 'Help and Support',
              onTap: () {
                // Handle help and support
              },
            ),

            SizedBox(height: 16.h),

            // Invite Friend
            _buildMenuItem(
              icon: 'assets/icons/settings_invite_friend.svg',
              title: 'Invite Friend',
              onTap: () {
                // Handle invite friend
              },
            ),

            SizedBox(height: 16.h),

            // Privacy Policy
            _buildMenuItem(
              icon: 'assets/icons/Unlock.svg',
              title: 'Privacy Policy',
              onTap: () {
                // Handle privacy policy
              },
            ),

            SizedBox(height: 32.h),

            // Log Out Button (only show when Settings tab is selected)
            _buildLogoutButton(context),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: ColorPalette.settingsMenuItemBg,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(2, 6),
              blurRadius: 25,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: ColorPalette.settingsMenuItemIconBg,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 18.w,
                  height: 18.h,
                  color: ColorPalette.secondaryBlue,
                ),
              ),
            ),

            SizedBox(width: 15.w),

            // Title
            Expanded(
              child: Text(title, style: AppTextStyles.settingsMenuItemStyle),
            ),

            // Arrow
            SvgPicture.asset(
              'assets/icons/setting_arrow_right.svg',
              width: 18,
              height: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationMenuItem({
    required String icon,
    required String title,
    required bool isEnabled,
    required Function(bool) onToggle,
  }) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: ColorPalette.settingsMenuItemBg,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(2, 6),
            blurRadius: 25,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: ColorPalette.settingsMenuItemIconBg,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 18.w,
                height: 18.h,
                color: ColorPalette.secondaryBlue,
              ),
            ),
          ),

          SizedBox(width: 15.w),

          // Title
          Expanded(
            child: Text(title, style: AppTextStyles.settingsMenuItemStyle),
          ),

          // Toggle Switch
          GestureDetector(
            onTap: () => onToggle(!isEnabled),
            child: Container(
              width: 20.w,
              height: 10.h,
              decoration: BoxDecoration(
                color:
                    isEnabled
                        ? ColorPalette.settingsToggleActive
                        : ColorPalette.textGrey,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Stack(
                children: [
                  if (isEnabled)
                    Positioned(
                      right: 1.w,
                      top: 1.h,
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: ColorPalette.settingsToggleInactive,
                          borderRadius: BorderRadius.circular(6.r),
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

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SettingsCubit>().logout();
        // Handle logout
      },
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/setting_Logout.svg',
              width: 17.w,
              height: 16.h,
            ),
            SizedBox(width: 8.w),
            Text('Log Out', style: AppTextStyles.settingsLogoutStyle),
          ],
        ),
      ),
    );
  }
}
