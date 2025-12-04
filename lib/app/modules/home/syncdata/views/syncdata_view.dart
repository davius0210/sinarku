import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/syncdata_controller.dart';

class SyncdataView extends GetView<SyncdataController> {
  const SyncdataView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SyncdataView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SyncdataView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
