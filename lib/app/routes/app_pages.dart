import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/models/bindings/models_binding.dart';
import '../modules/models/views/models_view.dart';
import '../modules/providers/bindings/providers_binding.dart';
import '../modules/providers/views/providers_view.dart';
import '../modules/screens/bindings/screens_binding.dart';
import '../modules/screens/views/screens_view.dart';
import '../modules/services/bindings/services_binding.dart';
import '../modules/services/views/services_view.dart';
import '../modules/widgets/bindings/widgets_binding.dart';
import '../modules/widgets/views/widgets_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MODELS,
      page: () => const ModelsView(),
      binding: ModelsBinding(),
    ),
    GetPage(
      name: _Paths.SERVICES,
      page: () => const ServicesView(),
      binding: ServicesBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDERS,
      page: () => const ProvidersView(),
      binding: ProvidersBinding(),
    ),
    GetPage(
      name: _Paths.SCREENS,
      page: () => const ScreensView(),
      binding: ScreensBinding(),
    ),
    GetPage(
      name: _Paths.WIDGETS,
      page: () => const WidgetsView(),
      binding: WidgetsBinding(),
    ),
  ];
}
