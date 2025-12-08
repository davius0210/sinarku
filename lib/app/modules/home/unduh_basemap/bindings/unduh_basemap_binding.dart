import 'package:get/get.dart';

import '../controllers/unduh_basemap_controller.dart';

class UnduhBasemapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnduhBasemapController>(
      () => UnduhBasemapController(),
    );
  }
}
