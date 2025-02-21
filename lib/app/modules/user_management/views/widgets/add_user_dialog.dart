import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/controllers/user_management_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/dropdown.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/form.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class AddUserDialog extends StatelessWidget {
  final UserManagementController controller;
  const AddUserDialog({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).appColors;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AppText.labelDefaultEmphasis(
                  "Add User",
                  context: context,
                  color: color.textSecondary,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ),
              ],
            ),
            VerticalGap.formBig(),
            CustomForm.text(
              labelText: AppLocalizations.of(context)!.full_name,
              onChanged: (value) => controller.fullName = value,
            ),
            VerticalGap.formMedium(),
            CustomDropdown(
              width: 350,
              onChanged: (value) => controller.gender = value,
              dropDownItems: [
                AppLocalizations.of(context)!.male,
                AppLocalizations.of(context)!.female,
              ],
              labelText: AppLocalizations.of(context)!.gender,
              height: 70,
            ),
            VerticalGap.formMedium(),
            CustomForm.text(
              labelText: AppLocalizations.of(context)!.username,
              onChanged: (value) => controller.username = value,
            ),
            VerticalGap.formMedium(),
            CustomForm.email(
              labelText: AppLocalizations.of(context)!.email,
              onChanged: (value) => controller.email = value,
            ),
            VerticalGap.formMedium(),
            CustomForm.password(
              labelText: AppLocalizations.of(context)!.password,
              onChanged: (value) => controller.password = value,
            ),
            Obx(() {
              return Visibility(
                visible: !controller.validPassword.value,
                child: AppText.textPrimary(
                  controller.massage.value,
                  color: color.textSecondary,
                  context: context,
                ),
              );
            }),
            VerticalGap.formMedium(),
            CenteredTextButton.primary(
              label: "Add User",
              context: context,
              onTap: () {
                if (!controller.validateEmail(controller.email)) return;
                controller.validatePassword(controller.password);
                if (controller.fullName.isEmpty ||
                    controller.gender.isEmpty ||
                    controller.username.isEmpty ||
                    controller.email.isEmpty ||
                    controller.password.isEmpty) {
                  showFailedSnackbar(
                    AppLocalizations.of(context)!.attention,
                    AppLocalizations.of(context)!.all_fields_must_be_filled,
                  );
                  return;
                }
                if (controller.validPassword.value) {
                  controller.register();
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
