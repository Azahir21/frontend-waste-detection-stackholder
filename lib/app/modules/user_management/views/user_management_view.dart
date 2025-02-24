import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/user_datatable.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/views/widgets/user_management_header.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/vertical_gap.dart';
import 'package:get/get.dart';

import '../controllers/user_management_controller.dart';

class UserManagementView extends GetView<UserManagementController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 700;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalGap.formHuge(),
                      UserManagementHeader(isMobile: isMobile),
                      VerticalGap.formHuge(),
                      UserDataTable(isMobile: isMobile),
                      VerticalGap.formHuge(),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
