import 'package:get/get.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/repository/recipe_repository.dart';

class DiscoverController extends GetxController {
  List<Map<String, String>> categories = [
    {"name": "Beef", "image": "assets/images/category/Beef.jpg"},
    {"name": "Chicken", "image": "assets/images/category/Chicken.jpg"},
    {"name": "Dessert", "image": "assets/images/category/Dessert.jpg"},
    {"name": "Lamb", "image": "assets/images/category/Lamb.jpg"},
    {"name": "Miscellaneous", "image": "assets/images/category/Miscellaneous.jpg"},
    {"name": "Pasta", "image": "assets/images/category/Pasta.jpg"},
    {"name": "Pork", "image": "assets/images/category/Pork.jpg"},
    {"name": "Seafood", "image": "assets/images/category/Seafood.jpg"},
    {"name": "Side", "image": "assets/images/category/Side.jpg"},
    {"name": "Starter", "image": "assets/images/category/Starter.jpg"},
    {"name": "Vegan", "image": "assets/images/category/Vegan.jpg"},
    {"name": "Vegetarian", "image": "assets/images/category/Vegetarian.jpg"},
    {"name": "Breakfast", "image": "assets/images/category/Breakfast.jpg"},
    {"name": "Goat", "image": "assets/images/category/Goat.jpg"},
  ];

  final RecipeRepository repo = RecipeRepository();

  var allRecipes = <Recipe>[].obs;
  var categoryRecipes = <String, List<Recipe>>{}.obs;
  var newRecipes = <Recipe>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllRecipes();
  }

  Future<void> fetchAllRecipes() async {
    try {
      isLoading.value = true;

      final recipes = await repo.fetchAllRecipes();
      allRecipes.value = recipes;

      _groupByCategory(recipes);
      _getNewRecipes(recipes);
    } finally {
      isLoading.value = false;
    }
  }

  void _groupByCategory(List<Recipe> recipes) {
    Map<String, List<Recipe>> map = {};

    for (var recipe in recipes) {
      map.putIfAbsent(recipe.category, () => []);
      map[recipe.category]!.add(recipe);
    }

    categoryRecipes.value = map;
  }

  void _getNewRecipes(List<Recipe> recipes) {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final newRecipe = recipes.where((recipe) {
      return recipe.createdAt.isAfter(sevenDaysAgo);
    }).toList();
    newRecipes.value = newRecipe;
  }

  int getCategoryCount(String category) {
    return categoryRecipes[category]?.length ?? 0;
  }
}
