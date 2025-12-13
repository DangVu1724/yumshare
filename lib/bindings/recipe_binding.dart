import 'package:get/get.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';

class RecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateRecipeController());
    Get.lazyPut(() => RecipeDetailController());
  }
}
