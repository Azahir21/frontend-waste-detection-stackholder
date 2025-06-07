import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const AppDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 100,
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          VerticalGap.formBig(),
          CustomIconButtonWithText.primary(
            label: AppLocalizations.of(context)!.home,
            isActive: selectedIndex == 0,
            iconName: AppIconName.home,
            onTap: () {
              onItemTapped(0);
              Navigator.of(context).pop(); // close the drawer
            },
            context: context,
          ),
          VerticalGap.formBig(),
          CustomIconButtonWithText.primary(
            label: AppLocalizations.of(context)!.statistics,
            isActive: selectedIndex == 1,
            iconName: AppIconName.article,
            onTap: () {
              onItemTapped(1);
              Navigator.of(context).pop();
            },
            context: context,
          ),
          VerticalGap.formBig(),
          Visibility(
            visible: GetStorage().read('role') == 'admin',
            child: CustomIconButtonWithText.primary(
              label: AppLocalizations.of(context)!.user,
              isActive: selectedIndex == 2,
              iconName: AppIconName.userManagement,
              onTap: () {
                onItemTapped(2);
                Navigator.of(context).pop();
              },
              context: context,
            ),
          ),
          const Spacer(),
          CustomIconButtonWithText.custom(
            label: AppLocalizations.of(context)!.logout,
            isActive: false,
            iconName: AppIconName.logout,
            backgroundColor: Theme.of(context).appColors.iconButtonSecondary,
            iconColor: Theme.of(context).appColors.textRed,
            textColor: Theme.of(context).appColors.textRed,
            onTap: () {
              GetStorage().remove('token');
              GetStorage().remove('username');
              GetStorage().remove('role');
              GetStorage().remove('target_location');
              GetStorage().remove('view_target_location_only');
              Get.offAllNamed('/login');
            },
            context: context,
          ),
          VerticalGap.formHuge(),
        ],
      ),
    );
  }
}
