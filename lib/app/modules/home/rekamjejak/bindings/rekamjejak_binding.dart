import 'package:get/get.dart';

import '../controllers/rekamjejak_controller.dart';

class RekamjejakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekamjejakController>(
      () => RekamjejakController(),
    );
  }
}
