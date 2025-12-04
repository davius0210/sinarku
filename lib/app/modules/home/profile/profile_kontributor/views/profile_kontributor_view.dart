import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_kontributor_controller.dart';

class ProfileKontributorView extends GetView<ProfileKontributorController> {
  const ProfileKontributorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileKontributorView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfileKontributorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
