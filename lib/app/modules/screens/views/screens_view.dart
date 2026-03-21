import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/screens_controller.dart';

class ScreensView extends GetView<ScreensController> {
  const ScreensView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScreensView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ScreensView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
