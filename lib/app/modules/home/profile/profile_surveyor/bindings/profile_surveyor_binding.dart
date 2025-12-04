import 'package:get/get.dart';

import '../controllers/profile_surveyor_controller.dart';

class ProfileSurveyorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSurveyorController>(
      () => ProfileSurveyorController(),
    );
  }
}
