import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class PreviewPage extends StatelessWidget {
  final String image;

  const PreviewPage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _getImageProvider(),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomIconButton.secondary(
                  iconName: AppIconName.backButton,
                  onTap: () {
                    Get.back();
                  },
                  context: context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (Uri.tryParse(image)?.hasScheme ?? false) {
      return NetworkImage(image);
    } else {
      try {
        return MemoryImage(base64Decode(image));
      } catch (e) {
        print('Error decoding image: $e');
        return AssetImage('assets/images/error_image.png');
      }
    }
  }
}
