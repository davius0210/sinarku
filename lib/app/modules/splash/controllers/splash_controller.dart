import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinarku/app/routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  
  @override
  void onInit() {
    super.onInit();
    getSession();
  }

  @override
  void onReady() {
    super.onReady();
    
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getSession() async {
    Timer(Duration(seconds: 2), () async {
      SharedPreferences _shared = await SharedPreferences.getInstance();
      if(_shared.getString('session')!=null)
      {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

}
