import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mapscreen_controller.dart';

class MapscreenView extends GetView<MapscreenController> {
  const MapscreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MapscreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MapscreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
