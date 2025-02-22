import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticHeader extends StatelessWidget {
  final bool isMobile;
  const StatisticHeader({Key? key, required this.isMobile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = AppText.customSize(
      AppLocalizations.of(context)!.statistics,
      size: isMobile ? 28 : 40,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).appColors.textSecondary,
      context: context,
    );
    return Padding(
      padding: isMobile
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 80.0),
      child: isMobile ? Center(child: headerText) : headerText,
    );
  }
}
