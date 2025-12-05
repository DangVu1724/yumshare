import 'package:get/get.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/repository/recipe_repository.dart';

class HomeController extends GetxController {
  final RecipeRepository recipeRepository = RecipeRepository();

  var myRecipes = <Recipe>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyRecipes();
  }

  Future<void> loadMyRecipes() async {
    isLoading.value = true;

    try {
      myRecipes.value = await recipeRepository.getMyRecipes();
    } finally {
      isLoading.value = false;
    }
  }
}
