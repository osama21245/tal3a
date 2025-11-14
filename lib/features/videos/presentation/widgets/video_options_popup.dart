import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/widgets/app_spaces.dart';
import 'package:tal3a/core/widgets/custom_text_field_widget.dart';
import 'package:tal3a/core/widgets/primary_button_widget.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoOptionsPopup extends StatelessWidget {
  final VideoModel video;

  const VideoOptionsPopup({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _popupItem(
                  icon: Icons.delete_outline,
                  label: "delete".tr(),
                  onTap: () {},
                ),
                _popupItem(
                  icon: Icons.block,
                  label: "report".tr(),
                  onTap: () {
                    showReportBottomSheet(context, video.id);
                  },
                ),
                _popupItem(
                  icon: Icons.person_add_alt,
                  label: "subscribe".tr(),
                  onTap: () {},
                ),
                _popupItem(icon: Icons.share, label: "share".tr(), onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _popupItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.blueGrey.shade700),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showReportBottomSheet(BuildContext context, String videoId) {
    final TextEditingController otherController = TextEditingController();
    String selectedReason = 'Spam';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<VideoCubit>(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  
                      Text(
                        'report'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ...[
                        'Spam',
                        'inappropriate_content'.tr(),
                        'harassment'.tr(),
                        'false_information'.tr(),
                        'auth.other'.tr(),
                      ].map((reason) {
                        bool isSelected = selectedReason == reason;
                        return Column(
                          children: [
                            AppSpaces.horizontalSpace(10),
                  
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedReason = reason.toString();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    isSelected
                                        ? SvgPicture.asset(
                                          'assets/icons/report_type_select_icon.svg',
                                          width: 24,
                                          height: 24,
                                        )
                                        : Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  ColorPalette
                                                      .trainingDescription,
                                            ),
                                            borderRadius: BorderRadius.circular(30)
                                          ),
                                          width: 24,
                                          height: 24,
                                        ),
                                    SizedBox(width: 12),
                                    Text(reason.toString()),
                                  ],
                                ),
                              ),
                            ),
                            AppSpaces.horizontalSpace(10),
                            Divider(height: 0.1,thickness: 0.5,),
                          ],
                        );
                      }),
                      if (selectedReason == 'other'.tr().toString())
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomTextFieldWidget(
                            controller: otherController,
                        hintText: 'report_reasons.write_report_reason'.tr(),
                          ),
                        ),
                      SizedBox(height: 10),
                      PrimaryButtonWidget(text: "submit".tr(),  onPressed: () {
                          final description =
                              selectedReason == 'other'.tr().toString()
                                  ? otherController.text
                                  : '';
                          context.read<VideoCubit>().reportVideo(
                            videoId: videoId,
                            reason: selectedReason,
                            description: description,
                          );
                          Navigator.pop(context);
                        } ,)
                    ,
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
