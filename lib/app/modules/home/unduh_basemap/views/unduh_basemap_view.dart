import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sinarku/app/modules/home/unduh_basemap/controllers/unduh_basemap_controller.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

// Menggunakan GetView<T> agar dapat mengakses controller secara langsung
class UnduhBasemapView extends GetView<UnduhBasemapController> {
  const UnduhBasemapView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller diakses langsung melalui properti 'controller'
    return Scaffold(
      appBar: AppBar(title: Text('Unduh Batas')),
      body: Stack(
        children: [
          Expanded(
            child: FlutterMap(
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  maxZoom: 18,
                ),
                Obx(() => PolygonLayer(polygons: controller.polygons.value)),
              ],
              options: MapOptions(
                initialCenter: LatLng(-6.2088, 106.8456),
                onMapEvent: (event) {
                  if (event is MapEventTap) {
                    if (controller.editButton.value) {
                      controller.addPolygon(event.tapPosition);
                    } else if (controller.editButtonRectangle.value) {
                      controller.addRectangle(event.tapPosition);
                    }
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsHelper.third,
                border: Border.all(color: ColorsHelper.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Obx(
                          () => CustomButtonComponent(
                            gradient: controller.editButton.value
                                ? ColorsHelper.warningGradient
                                : LinearGradient(
                                    colors: [
                                      ColorsHelper.buttonGrey,
                                      ColorsHelper.buttonGreyDark,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                            onPressed: () {
                              if (controller.editButton.value) {
                                controller.saveNewPolygonDrawing();
                              } else {
                                controller.startNewPolygonDrawing();
                              }
                            },
                            icon: Icon(
                              FontAwesomeIcons.drawPolygon,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Obx(
                          () => CustomButtonComponent(
                            gradient: controller.editButtonRectangle.value
                                ? ColorsHelper.warningGradient
                                : LinearGradient(
                                    colors: [
                                      ColorsHelper.buttonGrey,
                                      ColorsHelper.buttonGreyDark,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                            onPressed: () {
                              if (controller.editButtonRectangle.value) {
                                controller.saveNewRectangleDrawing();
                              } else {
                                controller.startNewRectangleDrawing();
                              }
                            },
                            icon: Icon(
                              Icons.rectangle_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => controller.saveButtonEnable.value
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CustomButtonComponent(
                              onPressed: controller.saveButtonEnable.value
                                  ? controller.saveButton
                                  : null,
                              icon: Icon(
                                CupertinoIcons.floppy_disk,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ),

                  Obx(() {
                    if (controller.editButton.value) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CustomButtonComponent(
                          gradient: ColorsHelper.dangerGradient,
                          onPressed: controller.cancelPolygonDrawing,
                          icon: Icon(CupertinoIcons.clear, color: Colors.white),
                        ),
                      );
                    } else if (controller.editButtonRectangle.value) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CustomButtonComponent(
                          gradient: ColorsHelper.dangerGradient,
                          onPressed: controller.cancelRectangleDrawing,
                          icon: Icon(CupertinoIcons.clear, color: Colors.white),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  Obx(
                    () => CustomButtonComponent(
                      title: 'Simpan Data',
                      onPressed: controller.polygons.value.isNotEmpty
                          ? () {}
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
