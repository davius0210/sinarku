import 'package:get/get.dart';

import '../controllers/profile_kontributor_controller.dart';

class ProfileKontributorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileKontributorController>(
      () => ProfileKontributorController(),
    );
  }
}
