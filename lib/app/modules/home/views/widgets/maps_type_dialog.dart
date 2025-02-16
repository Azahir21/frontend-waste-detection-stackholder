import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/modules/home/controllers/home_controller.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/icon_button.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class MapsTypeDialog extends GetView<HomeController> {
  // List of map modes with their associated icon.
  final List<Map<String, dynamic>> _mapModes = [
    {'mode': 'heatmap', 'icon': AppIconName.heatmap},
    {'mode': 'cluster', 'icon': AppIconName.cluster},
    {'mode': 'marker', 'icon': AppIconName.markermap},
  ];

  MapsTypeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).appColors;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: themeColors.iconButtonPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        // Build the list of buttons for each map mode.
        final buttons = _mapModes.map((item) {
          return _buildMapModeButton(
            context,
            mode: item['mode'] as String,
            icon: item['icon'] as AppIconName,
          );
        }).toList();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: _withSpacing(buttons, spacing: 15),
        );
      }),
    );
  }

  List<Widget> _withSpacing(List<Widget> widgets, {double spacing = 15}) {
    final List<Widget> spacedWidgets = [];
    for (int i = 0; i < widgets.length; i++) {
      spacedWidgets.add(widgets[i]);
      if (i != widgets.length - 1) {
        spacedWidgets.add(SizedBox(width: spacing));
      }
    }
    return spacedWidgets;
  }

  Widget _buildMapModeButton(BuildContext context,
      {required String mode, required AppIconName icon}) {
    return Visibility(
      visible: controller.mapsMode.value == mode,
      replacement: CustomIconButton.inactiveBordered(
        iconName: icon,
        onTap: () {
          controller.mapsMode.value = mode;
          controller.showMapsType.value = false;
        },
        context: context,
      ),
      child: CustomIconButton.activeBordered(
        iconName: icon,
        onTap: () {
          controller.mapsMode.value = mode;
          controller.showMapsType.value = false;
        },
        context: context,
      ),
    );
  }
}
