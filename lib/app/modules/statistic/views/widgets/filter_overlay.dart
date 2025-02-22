import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/statistic/views/widgets/filter_content.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterOverlay extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onOk;
  const FilterOverlay({Key? key, required this.onCancel, required this.onOk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 100,
      child: Card(
        elevation: 4,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.labelDefaultEmphasis(
                    AppLocalizations.of(context)!.filter,
                    context: context,
                  ),
                ],
              ),
              FilterContent(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  TextButton(
                    onPressed: onOk,
                    child: Text(AppLocalizations.of(context)!.ok),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
