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
        child: SingleChildScrollView(
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      AppText.labelDefaultEmphasis(
                        controller.isEditMode.value
                            ? AppLocalizations.of(context)!.edit_user
                            : AppLocalizations.of(context)!.add_user,
                        context: context,
                        color: color.textSecondary,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            controller.resetForm();
                            Get.back();
                          },
                          icon: const Icon(Icons.cancel_outlined),
                        ),
                      ),
                    ],
                  ),
                  VerticalGap.formBig(),
                  CustomForm.text(
                    labelText: AppLocalizations.of(context)!.full_name,
                    initialValue: controller.fullName,
                    onChanged: (value) => controller.fullName = value,
                  ),
                  VerticalGap.formMedium(),
                  CustomDropdown(
                    width: 350,
                    initialValue:
                        controller.gender.isNotEmpty ? controller.gender : null,
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
                    initialValue: controller.username,
                    onChanged: (value) => controller.username = value,
                  ),
                  VerticalGap.formMedium(),
                  CustomForm.email(
                    labelText: AppLocalizations.of(context)!.email,
                    initialValue: controller.email,
                    onChanged: (value) => controller.email = value,
                  ),
                  VerticalGap.formMedium(),
                  CustomForm.password(
                    labelText: controller.isEditMode.value
                        ? "${AppLocalizations.of(context)!.password} (${AppLocalizations.of(context)!.leave_empty_to_keep_current})"
                        : AppLocalizations.of(context)!.password,
                    onChanged: (value) => controller.password = value,
                  ),
                  VerticalGap.formMedium(),
                  CustomForm.text(
                    labelText:
                        AppLocalizations.of(context)!.target_location_edit,
                    initialValue: controller.targetLocation,
                    onChanged: (value) => controller.targetLocation = value,
                  ),
                  CheckboxListTile(
                    title: AppText.labelSmallDefault(
                      AppLocalizations.of(context)!.view_target_location_only,
                      context: context,
                      color: color.textSecondary,
                    ),
                    value: controller.viewTargetLocationOnly.value,
                    onChanged: (bool? value) {
                      controller.viewTargetLocationOnly.value = value ?? false;
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
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
                    label: controller.isEditMode.value
                        ? AppLocalizations.of(context)!.edit_user
                        : AppLocalizations.of(context)!.add_user,
                    context: context,
                    onTap: () {
                      if (!controller.validateEmail(controller.email)) return;

                      // For edit mode, password is optional
                      if (!controller.isEditMode.value ||
                          controller.password.isNotEmpty) {
                        controller.validatePassword(controller.password);
                        if (!controller.validPassword.value) return;
                      }

                      if (controller.fullName.isEmpty ||
                          controller.gender.isEmpty ||
                          controller.username.isEmpty ||
                          controller.email.isEmpty ||
                          (!controller.isEditMode.value &&
                              controller.password.isEmpty)) {
                        showFailedSnackbar(
                          AppLocalizations.of(context)!.attention,
                          AppLocalizations.of(Get.context!)!
                              .all_fields_must_be_filled,
                        );
                        return;
                      }

                      if (controller.isEditMode.value) {
                        controller.updateUser();
                        Get.back();
                      } else {
                        controller.register();
                        Get.back();
                      }
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
