import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/user_management/controllers/user_management_controller.dart';

class CustomSearchBar extends StatelessWidget {
  final UserManagementController controller;
  final bool isMobile;
  const CustomSearchBar(
      {Key? key, required this.controller, required this.isMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile ? double.infinity : 300,
      height: 50,
      child: TextFormField(
        initialValue: controller.search.value,
        decoration: InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
        onChanged: (value) => controller.search.value = value,
        onFieldSubmitted: (value) {
          controller.fetchDataUser(
            page: controller.currentPage.value,
            pageSize: controller.pageSize.value,
          );
        },
      ),
    );
  }
}
