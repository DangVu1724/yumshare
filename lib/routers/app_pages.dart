import 'package:get/get.dart';
import 'package:yumshare/bindings/auth_binding.dart';
import 'package:yumshare/bindings/discorver_binding.dart';
import 'package:yumshare/bindings/home_binding.dart';
import 'package:yumshare/bindings/profile_binding.dart';
import 'package:yumshare/home.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/routers/page/auth_routes.dart';
import 'package:yumshare/routers/page/discover_routes.dart';
import 'package:yumshare/routers/page/home_routes.dart';
import 'package:yumshare/routers/page/profile_routes.dart';
import 'package:yumshare/routers/page/recipe_routes.dart';

class AppPages {
  static final pages = [
    ...HomeRoutes.routes,
    ...DiscoverRoutes.routes,
    ...ProfileRoutes.routes,
    ...RecipeRoutes.routes,
    ...AuthRoutes.routes,

    // Trang Home shell nếu bạn muốn
    GetPage(
      name: Routes.h,
      page: () => Home(),
      bindings: [HomeBinding(), ProfileBinding(), AuthBinding(), DiscorverBinding()],
    ),
  ];
}
