import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/repository/recipe_repository.dart';
import 'package:yumshare/repository/user_repository.dart';

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

  final List<Map<String, String>> areas = [
    {"name": "Algerian", "image": "assets/images/areas/algerian.png"},
    {"name": "American", "image": "assets/images/areas/american.png"},
    {"name": "Argentinian", "image": "assets/images/areas/argentinian.png"},
    {"name": "Australian", "image": "assets/images/areas/australian.png"},
    {"name": "British", "image": "assets/images/areas/british.png"},
    {"name": "Canadian", "image": "assets/images/areas/canadian.png"},
    {"name": "Chinese", "image": "assets/images/areas/chinese.png"},
    {"name": "Croatian", "image": "assets/images/areas/croatian.png"},
    {"name": "Dutch", "image": "assets/images/areas/dutch.png"},
    {"name": "Egyptian", "image": "assets/images/areas/egyptian.png"},
    {"name": "Filipino", "image": "assets/images/areas/filipino.png"},
    {"name": "French", "image": "assets/images/areas/french.png"},
    {"name": "Greek", "image": "assets/images/areas/greek.png"},
    {"name": "Indian", "image": "assets/images/areas/indian.png"},
    {"name": "Irish", "image": "assets/images/areas/irish.png"},
    {"name": "Italian", "image": "assets/images/areas/italian.png"},
    {"name": "Jamaican", "image": "assets/images/areas/jamaican.png"},
    {"name": "Japanese", "image": "assets/images/areas/japanese.png"},
    {"name": "Kenyan", "image": "assets/images/areas/kenyan.png"},
    {"name": "Malaysian", "image": "assets/images/areas/malaysian.png"},
    {"name": "Mexican", "image": "assets/images/areas/mexican.png"},
    {"name": "Moroccan", "image": "assets/images/areas/moroccan.png"},
    {"name": "Norwegian", "image": "assets/images/areas/norwegian.png"},
    {"name": "Polish", "image": "assets/images/areas/polish.png"},
    {"name": "Portuguese", "image": "assets/images/areas/portuguese.png"},
    {"name": "Russian", "image": "assets/images/areas/russian.png"},
    {"name": "Saudi Arabian", "image": "assets/images/areas/saudi_arabian.png"},
    {"name": "Slovakian", "image": "assets/images/areas/slovakian.png"},
    {"name": "Spanish", "image": "assets/images/areas/spanish.png"},
    {"name": "Syrian", "image": "assets/images/areas/syrian.png"},
    {"name": "Thai", "image": "assets/images/areas/thai.png"},
    {"name": "Tunisian", "image": "assets/images/areas/tunisian.png"},
    {"name": "Turkish", "image": "assets/images/areas/turkish.png"},
    {"name": "Ukrainian", "image": "assets/images/areas/ukrainian.png"},
    {"name": "Uruguayan", "image": "assets/images/areas/uruguayan.png"},
    {"name": "Venezulan", "image": "assets/images/areas/venezulan.png"},
    {"name": "Vietnamese", "image": "assets/images/areas/Vietnamese.png"},
  ];

  final RecipeRepository repo = RecipeRepository();
  final AuthService _authService = AuthService();
  final UserRepository userRepository = UserRepository();

  var allRecipes = <Recipe>[].obs;
  var categoryRecipes = <String, List<Recipe>>{}.obs;
  var areaRecipes = <String, List<Recipe>>{}.obs;
  var newRecipes = <Recipe>[].obs;
  var topChefs = <Users>[].obs;
  var isLoading = false.obs;
  late final String? userId;
  var logger = Logger();

  @override
  void onInit() {
    super.onInit();
    userId = _authService.currentUser?.uid;
    fetchAllRecipes();
    fetchTopUsers();
  }

  Future<void> fetchAllRecipes() async {
    try {
      isLoading.value = true;

      final recipes = await repo.fetchAllRecipes();
      allRecipes.value = recipes;

      _groupByCategory(recipes);
      _groupByArea(recipes);
      _getNewRecipes(recipes);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTopUsers({int minRecipes = 10}) async {
    topChefs.value = await userRepository.fetchTopUsers();
  }

  void _groupByCategory(List<Recipe> recipes) {
    Map<String, List<Recipe>> map = {};

    for (var recipe in recipes) {
      map.putIfAbsent(recipe.category, () => []);
      map[recipe.category]!.add(recipe);
    }

    categoryRecipes.value = map;
  }

  void _groupByArea(List<Recipe> recipes) {
    Map<String, List<Recipe>> map = {};

    for (var recipe in recipes) {
      map.putIfAbsent(recipe.regions, () => []);
      map[recipe.regions]!.add(recipe);
    }

    areaRecipes.value = map;
    print("region of ${map['name']}: ${map['region']}");
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

  int getAreaCount(String regions) {
    return areaRecipes[regions]?.length ?? 0;
  }

  List<Recipe> getSimilarRecipes(Recipe targetRecipe, {int limit = 10}) {
    final sameCategoryList = categoryRecipes[targetRecipe.category] ?? [];

    if (sameCategoryList.isEmpty) return [];

    final similarities = <Recipe, int>{};

    for (var recipe in sameCategoryList) {
      if (recipe.id == targetRecipe.id) continue;

      int score = 0;

      // 1. Category giống -> ưu tiên cao nhất (đã lọc trước, nhưng vẫn giữ weight)
      score += 70;

      // 2. Region giống (nếu có dữ liệu)
      if (targetRecipe.regions.isNotEmpty && recipe.regions == targetRecipe.regions) {
        score += 25;
      }

      // score += ((recipe.rating) * 1).toInt();

      similarities[recipe] = score;
    }

    final sorted = similarities.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sorted.map((e) => e.key).take(limit).toList();
  }
}
