import 'package:get/get.dart';
import 'package:yumshare/features/auth/pages/login_page.dart';
import 'package:yumshare/features/home/pages/favourite_page.dart';
import 'package:yumshare/features/home/pages/home_page.dart';
import 'package:yumshare/features/myrecipe/pages/my_recipe_page.dart';
import 'package:yumshare/features/recipe/create_recipe/create_recipe_page.dart';
import 'app_routes.dart';


class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.favourite,
      page: () => const FavouritePage(),
    ),
    GetPage(
      name: Routes.myRecipe,
      page: () => const MyRecipePage(),
    ),
    GetPage(
      name: Routes.createRecipe,
      page: () => const CreateRecipePage(),
    ),
  ];
}
