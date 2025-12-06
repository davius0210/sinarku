import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sinarku/components/custom_middle_navbar_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: PersistentTabView(
        controller: controller.tabController,
        tabs: [
          PersistentTabConfig(
            screen: Text('Pengaturan'),
            item: ItemConfig(
              icon: Icon(CupertinoIcons.gear, color: Colors.white),
              inactiveIcon: Icon(CupertinoIcons.gear, color: Colors.white),
              title: "Pengaturan",
              activeForegroundColor: Colors.white,
            ),
          ),
          PersistentTabConfig(
            screen: Text('Daftar Data'),
            item: ItemConfig(
              icon: Icon(CupertinoIcons.list_bullet, color: Colors.white),
              inactiveIcon: Icon(
                CupertinoIcons.list_bullet,
                color: Colors.white,
              ),
              title: "Daftar Data",
              activeForegroundColor: Colors.white,
            ),
          ),
          PersistentTabConfig(
            screen: Text('Maps'),
            item: ItemConfig(
              icon: Icon(FontAwesomeIcons.mapPin),
              title: "Rekam Toponim",
            ),
          ),
          PersistentTabConfig(
            screen: Text('Rekam Jejak'),
            item: ItemConfig(
              icon: Icon(Icons.directions_walk, color: Colors.white),
              title: "Rekam Jejak",
              inactiveIcon: Icon(Icons.directions_walk),
            ),
          ),
          PersistentTabConfig(
            screen: Text('Saya'),
            item: ItemConfig(
              icon: Icon(Icons.person, color: Colors.white),
              title: "Saya",
              inactiveIcon: Icon(Icons.person),
            ),
          ),
        ],
        navBarBuilder: (NavBarConfig navBarConfig) {
          return CustomBottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              color: ColorsHelper.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            onPressMiddle: () async {
              print('wwwwpw');
              controller.tabController.jumpToTab(2);
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const Center(child: Text("Home Screen")),
      const Center(child: Text("Search Screen")),
      const Center(child: Text("Profile Screen")),
      const Center(child: Text("Profile Screen")),
      const Center(child: Text("Profile Screen")),
    ];
  }
}
