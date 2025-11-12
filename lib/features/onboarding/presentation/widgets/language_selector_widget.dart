import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/dimentions.dart';
import '../../../../core/const/text_style.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇸🇦'),
                title: const Text('العربية'),
                onTap: () {
                  context.setLocale(const Locale('ar'));
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                leading: const Text('🇺🇸'),
                title: const Text('English'),
                onTap: () {
                  context.setLocale(const Locale('en'));
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final languageText = currentLocale.languageCode == 'ar' ? 'العربية' : 'English';

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => _showLanguageDialog(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingMedium,
              vertical: Dimensions.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: ColorPalette.lightGrey,
              borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Dimensions.iconMedium,
                  height: Dimensions.iconMedium,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/flag_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.paddingSmall),
                Text(languageText, style: AppTextStyles.languageSelectorStyle),
                SizedBox(width: Dimensions.paddingSmall),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorPalette.textDark,
                  size: Dimensions.iconSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
