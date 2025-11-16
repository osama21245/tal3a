import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/routing/routes.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../../../../core/const/text_style.dart';
import '../../controllers/home_cubit.dart';
import '../../controllers/home_state.dart';

class HomeTabSelectorWidget extends StatelessWidget {
  const HomeTabSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLiveTala3aActive = state.isLiveTala3aActive;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2),
          decoration: BoxDecoration(
            color: ColorPalette.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              // Live Tala3a Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeCubit>().toggleTab(true);
                  },
                  child: Container(
                    height: 60.h,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    margin: EdgeInsets.all(4.5.w),
                    decoration: BoxDecoration(
                      color:
                          isLiveTala3aActive
                              ? ColorPalette.homeTabActiveBg
                              : ColorPalette.homeTabInactiveBg,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Text(
                        'home.live_tala3a'.tr(),
                        style:
                            isLiveTala3aActive
                                ? AppTextStyles.homeTabActiveStyle
                                : AppTextStyles.homeTabInactiveStyle,
                      ),
                    ),
                  ),
                ),
              ),

              // Let's Tala3a Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeCubit>().toggleTab(false);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.pushNamed(
                        context,
                        Routes.chooseTal3aTypeScreen,
                      );
                    });
                  },
                  child: Container(
                    height: 60.h,
                    margin: EdgeInsets.all(4.5.w),
                    decoration: BoxDecoration(
                      color:
                          !isLiveTala3aActive
                              ? ColorPalette.homeTabActiveBg
                              : ColorPalette.homeTabInactiveBg,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Text(
                        'home.lets_tala3a'.tr(),
                        style:
                            !isLiveTala3aActive
                                ? AppTextStyles.homeTabActiveStyle
                                : AppTextStyles.homeTabInactiveStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
