import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/form.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  Widget _languageDropdown() {
    var color = Theme.of(Get.context!).appColors;
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: color.formFieldBorder,
            width: 3,
          ),
        ),
      ),
      value: controller.language,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Theme.of(Get.context!).appColors.textPrimary),
      onChanged: (String? newValue) {
        controller.language = newValue!;
        GetStorage().write('language', newValue);
        Get.updateLocale(Locale(newValue));
      },
      items: [
        {'value': 'en', 'label': 'English', 'flag': '🇺🇸'},
        {'value': 'id', 'label': 'Indonesian', 'flag': '🇮🇩'},
        {'value': 'ja', 'label': 'Japanese', 'flag': '🇯🇵'}
      ].map<DropdownMenuItem<String>>((Map<String, String> item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Row(
            children: [
              Text(item['flag']!),
              const SizedBox(width: 8),
              Text(item['label']!),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: color.backgroundGradient,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            double logoSize = isMobile ? 30 : 40;

            Widget content = Column(
              mainAxisAlignment:
                  isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isMobile) VerticalGap.formHuge(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/logo.png",
                        width: logoSize, height: logoSize),
                    HorizontalGap.formMedium(),
                    AppText.labelDefaultEmphasis(
                      AppLocalizations.of(context)!.app_title,
                      color: color.textSecondary,
                      context: context,
                    ),
                  ],
                ),
                isMobile ? VerticalGap.formHuge() : VerticalGap.formMedium(),
                CustomForm.email(
                  labelText: AppLocalizations.of(context)!.email,
                  onChanged: (value) {
                    controller.email = value;
                  },
                ),
                CustomForm.password(
                  labelText: AppLocalizations.of(context)!.password,
                  onChanged: (value) {
                    controller.password = value;
                  },
                ),
                CenteredTextButton.tertiary(
                  label: AppLocalizations.of(context)!.login,
                  onTap: () {
                    if (controller.email.isEmpty ||
                        controller.password.isEmpty) {
                      showFailedSnackbar(
                        AppLocalizations.of(context)!.input_error,
                        AppLocalizations.of(context)!.email_pass_cant_empty,
                      );
                      return;
                    }
                    controller.login();
                  },
                  context: context,
                ),
                isMobile ? Spacer() : VerticalGap.formHuge(),
                // Mobile: display dropdown at bottom.
                if (isMobile) SizedBox(width: 350, child: _languageDropdown()),
                isMobile ? VerticalGap.formHuge() : SizedBox.shrink(),
              ],
            );

            // For mobile, wrap content in padding and safe area.
            if (isMobile) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SafeArea(child: content),
              );
            } else {
              // Desktop: use a Stack to position the language dropdown at the top right.
              return Stack(
                children: [
                  Positioned(
                    top: 35,
                    right: 35,
                    child: SizedBox(
                      width: 200, // provide a finite width here
                      child: _languageDropdown(),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 500,
                      height: 378,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: content,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
