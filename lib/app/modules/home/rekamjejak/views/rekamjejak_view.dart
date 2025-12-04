import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rekamjejak_controller.dart';

class RekamjejakView extends GetView<RekamjejakController> {
  const RekamjejakView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RekamjejakView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RekamjejakView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
