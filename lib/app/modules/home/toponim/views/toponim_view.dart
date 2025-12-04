import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/toponim_controller.dart';

class ToponimView extends GetView<ToponimController> {
  const ToponimView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToponimView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ToponimView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
