import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_toponim_controller.dart';

class DetailToponimView extends GetView<DetailToponimController> {
  const DetailToponimView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DetailToponimView'), centerTitle: true),
      body: const Center(
        child: Text(
          'DetailToponimView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
