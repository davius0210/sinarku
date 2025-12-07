import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  late PersistentTabController tabController;
  var selectedBasemap = ''.obs;
  @override
  void onInit() {
    super.onInit();
    tabController = PersistentTabController(initialIndex: 0);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
