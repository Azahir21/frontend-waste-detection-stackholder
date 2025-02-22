import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/controllers/user_management_controller.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/add_user_dialog.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/centered_text_button_with_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddUserButton extends StatelessWidget {
  final bool isMobile;
  final UserManagementController controller;
  const AddUserButton(
      {Key? key, required this.isMobile, required this.controller})
      : super(key: key);

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddUserDialog(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? CustomIconButton.primary(
            iconName: AppIconName.add,
            onTap: () => _showAddUserDialog(context),
            context: context,
          )
        : CenteredTextButtonWithIcon.primary(
            label: AppLocalizations.of(context)!.add_user,
            rightIcon: AppIconName.add,
            height: 50,
            width: 186,
            onTap: () => _showAddUserDialog(context),
            context: context,
          );
  }
}
