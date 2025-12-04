import 'package:get/get.dart';

import '../controllers/syncdata_controller.dart';

class SyncdataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SyncdataController>(
      () => SyncdataController(),
    );
  }
}
