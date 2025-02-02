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

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    var size = MediaQuery.of(context).size;
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
                isMobile ? VerticalGap.formHuge() : SizedBox.shrink(),
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
                          AppLocalizations.of(context)!.email_pass_cant_empty);
                      return;
                    }
                    controller.login();
                  },
                  context: context,
                ),
              ],
            );

            return isMobile
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SafeArea(child: content),
                  )
                : Center(
                    child: Container(
                      width: 500,
                      height: 378,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: content,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
