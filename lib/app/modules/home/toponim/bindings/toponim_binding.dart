import 'package:get/get.dart';

import '../controllers/toponim_controller.dart';

class ToponimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToponimController>(
      () => ToponimController(),
    );
  }
}
