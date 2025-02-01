import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemTiles extends StatelessWidget {
  const ItemTiles({super.key, required this.countObject});
  final CountedObject countObject;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomIconButton.primary(
              width: 60,
              height: 60,
              iconName: AppIconName.trash,
              onTap: () {},
              context: context,
            ),
            HorizontalGap.formMedium(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText.labelSmallEmphasis(
                    countObject.name!,
                    color: color.textSecondary,
                    context: context,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  VerticalGap.formSmall(),
                  AppText.labelSmallDefault(
                      AppLocalizations.of(context)!.amount(countObject.count!),
                      color: color.textSecondary,
                      context: context)
                ],
              ),
            ),
            Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                color: color.buttonSecondary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                  child: AppText.labelSmallEmphasis("${countObject.point} koin",
                      color: color.textSecondary, context: context)),
            )
          ],
        ),
        VerticalGap.formMedium(),
      ],
    );
  }
}
