import 'package:get/get.dart';
import 'package:yumshare/bindings/auth_binding.dart';
import 'package:yumshare/bindings/discorver_binding.dart';
import 'package:yumshare/bindings/home_binding.dart';
import 'package:yumshare/bindings/profile_binding.dart';
import 'package:yumshare/features/auth/pages/login_page.dart';
import 'package:yumshare/features/auth/pages/register_page.dart';
import 'package:yumshare/features/discover/pages/discover_page.dart';
import 'package:yumshare/features/discover/pages/recipe_category_page.dart';
import 'package:yumshare/features/home/pages/favourite_page.dart';
import 'package:yumshare/features/home/pages/home_page.dart';
import 'package:yumshare/features/myrecipe/pages/my_recipe_page.dart';
import 'package:yumshare/features/profile/pages/edit_profile_page.dart';
import 'package:yumshare/features/profile/pages/profile_page.dart';
import 'package:yumshare/features/profile/pages/setting_page.dart';
import 'package:yumshare/features/recipe/create_recipe/create_recipe_page.dart';
import 'package:yumshare/home.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: Routes.login, page: () => const LoginPage(), binding: AuthBinding()),
    GetPage(name: Routes.register, page: () => const RegisterPage(), binding: AuthBinding()),
    GetPage(name: Routes.favourite, page: () => const FavouritePage()),
    GetPage(name: Routes.profile, page: () => ProfilePage(), bindings: [HomeBinding(), ProfileBinding()]),
    GetPage(name: Routes.editProfile, page: () => EditProfilePage(), bindings: [HomeBinding(), ProfileBinding()]),
    GetPage(
      name: Routes.setting,
      page: () => SettingsPage(),
      bindings: [HomeBinding(), ProfileBinding(), AuthBinding()],
    ),
    GetPage(name: Routes.discover, page: () => DiscoverPage(), bindings: [DiscorverBinding()]),
    GetPage(name: Routes.myRecipe, page: () => const MyRecipePage()),
    GetPage(name: Routes.createRecipe, page: () => const CreateRecipePage()),
    GetPage(name: Routes.categoryRecipe, page: () => const RecipeCategoryPage()),

    GetPage(
      name: Routes.h,
      page: () => Home(),
      bindings: [HomeBinding(), ProfileBinding(), AuthBinding(), DiscorverBinding()],
    ),
  ];
}
