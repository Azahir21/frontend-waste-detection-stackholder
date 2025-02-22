import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapDialog extends StatelessWidget {
  final LatLng? geom;
  const MapDialog({Key? key, required this.geom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        width: 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: geom!,
                initialZoom: 17,
                maxZoom: 18,
                minZoom: 3,
                cameraConstraint: CameraConstraint.contain(
                  bounds: LatLngBounds(
                    const LatLng(-90, -180),
                    const LatLng(90, 180),
                  ),
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                  tileProvider:
                      CancellableNetworkTileProvider(silenceExceptions: true),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: geom!,
                      child: const Icon(Icons.location_on,
                          color: Colors.red, size: 50),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Get.back(closeOverlays: true),
                      color: Colors.white,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
