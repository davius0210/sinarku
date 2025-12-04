import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_surveyor_controller.dart';

class ProfileSurveyorView extends GetView<ProfileSurveyorController> {
  const ProfileSurveyorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileSurveyorView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfileSurveyorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
