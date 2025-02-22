import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PickupConfirmationDialog extends StatelessWidget {
  final int rowId;
  final VoidCallback onConfirm;
  const PickupConfirmationDialog(
      {Key? key, required this.rowId, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.labelDefaultEmphasis(
              AppLocalizations.of(context)!.pickup_confirmation,
              context: context,
              textAlign: TextAlign.center,
              color: Theme.of(context).appColors.textSecondary,
            ),
            VerticalGap.formMedium(),
            AppText.labelSmallDefault(
              AppLocalizations.of(context)!.pickup_confirmation_message,
              color: Theme.of(context).appColors.textSecondary,
              textAlign: TextAlign.center,
              context: context,
            ),
            VerticalGap.formBig(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CenteredTextButtonWithIcon.secondary(
                  label: AppLocalizations.of(context)!.cancel,
                  width: 120,
                  height: 35,
                  onTap: () => Get.back(),
                  context: context,
                ),
                HorizontalGap.formHuge(),
                CenteredTextButtonWithIcon.primary(
                  label: AppLocalizations.of(context)!.already,
                  width: 120,
                  height: 35,
                  onTap: () {
                    onConfirm();
                    Get.back();
                  },
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
