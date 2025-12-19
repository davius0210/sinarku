import 'package:get/get.dart';

import '../controllers/detail_toponim_controller.dart';

class DetailToponimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailToponimController>(
      () => DetailToponimController(),
    );
  }
}
