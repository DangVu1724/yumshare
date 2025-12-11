import 'package:get/get.dart';
import 'package:yumshare/bindings/home_binding.dart';
import 'package:yumshare/features/home/pages/home_page.dart';
import 'package:yumshare/features/home/pages/favourite_page.dart';
import 'package:yumshare/routers/app_routes.dart';

class HomeRoutes {
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.favourite,
      page: () => const FavouritePage(),
    ),
  ];
}
