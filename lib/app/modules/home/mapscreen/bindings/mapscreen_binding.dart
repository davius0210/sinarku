import 'package:get/get.dart';

import '../controllers/mapscreen_controller.dart';

class MapscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapscreenController>(
      () => MapscreenController(),
    );
  }
}
