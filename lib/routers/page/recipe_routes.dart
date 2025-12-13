import 'package:get/get.dart';
import 'package:yumshare/bindings/discorver_binding.dart';
import 'package:yumshare/bindings/home_binding.dart';
import 'package:yumshare/bindings/recipe_binding.dart';
import 'package:yumshare/features/recipe/recipe_detail/pages/comments_page.dart';
import 'package:yumshare/features/recipe/recipe_detail/pages/recipe_detail.dart';
import 'package:yumshare/features/recipe/create_recipe/create_recipe_page.dart';
import 'package:yumshare/features/myrecipe/pages/my_recipe_page.dart';
import 'package:yumshare/features/recipe/recipe_edit/pages/edit_recipe_page.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/routers/app_routes.dart';

class RecipeRoutes {
  static final routes = [
    GetPage(name: Routes.myRecipe, page: () => const MyRecipePage()),

    GetPage(name: Routes.createRecipe, page: () => const CreateRecipePage(), binding: RecipeBinding()),
    GetPage(
      name: Routes.comments,
      page: () {
        final recipeId = Get.arguments as String;
        return CommentsPage(recipeId: recipeId);
      },
      binding: RecipeBinding(),
    ),

    GetPage(
      name: Routes.recipeDetail,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final recipe = args["recipe"] as Recipe;
        final user = args["user"] as Users;
        return RecipeDetailPage(recipe: recipe, user: user);
      },
      bindings: [HomeBinding(), DiscorverBinding(), RecipeBinding(), RecipeBinding()],
    ),
    GetPage(
      name: Routes.editRecipe,
      page: () {
        final recipe = Get.arguments as Recipe;
        return EditRecipePage(recipe: recipe);
      },
      bindings: [HomeBinding(), DiscorverBinding(), RecipeBinding()],
    ),
  ];
}
