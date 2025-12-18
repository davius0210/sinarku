import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/components/card_list_menu_component.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan'), centerTitle: false),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          CardListMenuComponent(
            items: [
              CardTileMenu(
                prefix: const Icon(Icons.sync),
                suffix: Switch(value: true, onChanged: (val) {}),
                title: const Text('Sinkron Data'),
              ),
              CardTileMenu(
                prefix: const Icon(Icons.backup),

                title: const Text('Backup Data'),
                onPressed: () {},
              ),
              // CardTileMenu(
              //   prefix: const Icon(Icons.fingerprint),

              //   title: const Text('Aktifasi Biometrik'),
              //   suffix: Switch(value: true, onChanged: (val) {}),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
