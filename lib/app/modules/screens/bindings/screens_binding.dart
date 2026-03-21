import 'package:get/get.dart';

import '../controllers/screens_controller.dart';

class ScreensBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScreensController>(
      () => ScreensController(),
    );
  }
}
