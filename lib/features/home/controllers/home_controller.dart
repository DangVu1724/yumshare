import 'package:get/get.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/repository/recipe_repository.dart';

class HomeController extends GetxController {
  final RecipeRepository recipeRepository = RecipeRepository();

  RxList<Recipe> myRecipes = <Recipe>[].obs;
  RxList<Recipe> favoriteRecipes = <Recipe>[].obs;
  RxSet<String> favoriteIds = <String>{}.obs;

  RxMap<String, Users> authors = <String, Users>{}.obs;

  var isLoading = false.obs;
  var isAuthorLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipesAuthors();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await loadMyRecipes();
      await loadFavorite();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMyRecipes() async {
    myRecipes.value = await recipeRepository.getMyRecipes();
  }

  Future<void> loadFavorite() async {
    favoriteRecipes.value = await recipeRepository.getMyFavoriteRecipes();
    favoriteIds.value = favoriteRecipes.map((e) => e.id).toSet();
  }

  Future<void> loadRecipesAuthors() async {
    isAuthorLoading.value = true;
    try {
      authors.value = await recipeRepository.fetchRecipesAuthors();
    } finally {
      isAuthorLoading.value = false;
    }
  }

  Future<void> toggleFavorite(String recipeId) async {
    final isFav = await recipeRepository.toggleFavouriteRecipe(recipeId);

    if (isFav) {
      favoriteIds.add(recipeId);

      final recipe = await recipeRepository.findRecipeById(recipeId);
      
      if (recipe != null && !favoriteRecipes.contains(recipe)) {
        favoriteRecipes.add(recipe);
      }

    } else {
      favoriteIds.remove(recipeId);

      favoriteRecipes.removeWhere((r) => r.id == recipeId);
    }
  }



  bool isFavorite(String recipeId) => favoriteIds.contains(recipeId);
}
