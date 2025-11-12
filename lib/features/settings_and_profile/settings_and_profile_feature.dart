import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/change_password_screen.dart';
import 'presentation/controllers/settings_cubit.dart';
import 'presentation/controllers/change_password_cubit.dart';
import 'presentation/widgets/settings_screen/settings_tab_selector_widget.dart';
import 'presentation/widgets/settings_screen/settings_profile_card_widget.dart';
import 'presentation/widgets/settings_screen/settings_menu_list_widget.dart';
import '../../core/const/color_pallete.dart';
import '../../core/utils/animation_helper.dart';
import '../../core/network/api_client.dart';
import 'data/data_sources/change_password_data_source.dart';
import 'data/repositories/change_password_repository_impl.dart';

class SettingsAndProfileFeature {
  static Widget getSettingsScreen() {
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(),
      child: const SettingsScreen(),
    );
  }

  static Widget getChangePasswordScreen() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final apiClient = ApiClient();
            final dataSource = ChangePasswordDataSourceImpl(
              apiClient: apiClient,
            );
            final repository = ChangePasswordRepositoryImpl(
              dataSource: dataSource,
            );
            return ChangePasswordCubit(repository: repository);
          },
        ),
      ],
      child: const ChangePasswordScreen(),
    );
  }

  static Widget getSettingsContent() {
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(),
      child: const SettingsContentWidget(),
    );
  }
}

class SettingsContentWidget extends StatefulWidget {
  const SettingsContentWidget({super.key});

  @override
  State<SettingsContentWidget> createState() => _SettingsContentWidgetState();
}

class _SettingsContentWidgetState extends State<SettingsContentWidget> {
  bool isProfileSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.settingsMainBg,
      child: Column(
        children: [
          // Header with Training App Bar
          CustomAppBar(
            title: 'Settings',
            onBackPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(height: 10),

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
                      onTabChanged: (selected) {
                        setState(() {
                          isProfileSelected = selected;
                        });
                      },
                    ),
                  ),

                  // Content based on selected tab with smooth transition
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
                          ],

                          // Settings Menu List with consistent animation
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: AnimationHelper.fadeIn(
                              duration: const Duration(milliseconds: 500),
                              delay: const Duration(milliseconds: 100),
                              child: SettingsMenuListWidget(),
                            ),
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
