import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/models_controller.dart';

class ModelsView extends GetView<ModelsController> {
  const ModelsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ModelsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ModelsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
