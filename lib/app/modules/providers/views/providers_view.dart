import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/providers_controller.dart';

class ProvidersView extends GetView<ProvidersController> {
  const ProvidersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProvidersView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProvidersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
