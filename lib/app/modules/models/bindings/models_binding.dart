import 'package:get/get.dart';

import '../controllers/models_controller.dart';

class ModelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModelsController>(
      () => ModelsController(),
    );
  }
}
