import 'package:get/get.dart';
import 'package:yumshare/bindings/discorver_binding.dart';
import 'package:yumshare/features/discover/pages/discover_page.dart';
import 'package:yumshare/features/discover/pages/recipe_category_page.dart';
import 'package:yumshare/features/discover/pages/recipe_bycategory_page.dart';
import 'package:yumshare/features/discover/pages/search_page.dart';
import 'package:yumshare/routers/app_routes.dart';

class DiscoverRoutes {
  static final routes = [
    GetPage(name: Routes.discover, page: () => DiscoverPage(), bindings: [DiscorverBinding()]),

    GetPage(name: Routes.categoryRecipe, page: () => const RecipeCategoryPage(), binding: DiscorverBinding()),

    GetPage(
      name: Routes.recipesByCategoryPage,
      page: () {
        final category = Get.parameters[Routes.category]!;
        return RecipeByCategoryPage(category: category);
      },
      bindings: [DiscorverBinding()],
    ),
    

    GetPage(name: Routes.search, page: () => SearchPage(), binding: DiscorverBinding()),
  ];
}
