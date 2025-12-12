import 'package:get/get.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';

class RecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateRecipeController());
  }
}
