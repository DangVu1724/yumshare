import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/country.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/repository/country_repo.dart';
import 'package:yumshare/repository/recipe_repository.dart';
import 'package:yumshare/repository/user_repository.dart';
import 'package:yumshare/services/cache_service.dart';

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
  final AuthService _authService = AuthService();
  final UserRepository userRepository = UserRepository();
  final CountryRepo countryRepo = CountryRepo();

  var allRecipes = <Recipe>[].obs;
  var categoryRecipes = <String, List<Recipe>>{}.obs;
  var areaRecipes = <String, List<Recipe>>{}.obs;
  var newRecipes = <Recipe>[].obs;
  var topChefs = <Users>[].obs;
  var countries = <Country>[].obs;
  var isLoading = false.obs;
  final hasCache = false.obs;
  final areaSortAscending = <String, bool>{}.obs;

  late final String? userId;
  var logger = Logger();

  @override
  void onInit() {
    super.onInit();
    userId = _authService.currentUser?.uid;
    final cached = CacheService().getDiscoverPage1();
    if (cached.isNotEmpty) {
      allRecipes.value = cached;
      _groupByCategory(cached);
      _groupByArea(cached);
      hasCache.value = true;
    }
    logger.i("Cached discover page 1: ${cached.length} recipes");

    fetchAllRecipes();
    fetchTopUsers();
    fetchCountries();
  }

  Future<void> fetchAllRecipes() async {
    isLoading.value = true;

    final recipes = await repo.fetchAllRecipes();
    allRecipes.value = recipes;

    CacheService().saveDiscoverPage1(recipes);

    _groupByCategory(recipes);
    _groupByArea(recipes);
    _getNewRecipes(recipes);

    isLoading.value = false;
  }

  Future<void> fetchTopUsers({int minRecipes = 10}) async {
    topChefs.value = await userRepository.fetchTopUsers();
  }

  Future<void> fetchCountries() async {
    try {
      final fetchedCountries = await countryRepo.fetchCountries();
      countries.assignAll(fetchedCountries);
    } catch (e) {
      logger.e("Error fetching countries in DiscoverController", error: e);
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

  void _groupByArea(List<Recipe> recipes) {
    Map<String, List<Recipe>> map = {};

    for (var recipe in recipes) {
      map.putIfAbsent(recipe.regions, () => []);
      map[recipe.regions]!.add(recipe);
    }

    areaRecipes.value = map;
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

  void toggleSortRecipesByArea(String area) {
    final recipes = areaRecipes[area];
    if (recipes == null || recipes.isEmpty) return;

    final currentAsc = areaSortAscending[area] ?? true;
    final nextAsc = !currentAsc;

    final sortedRecipes = List<Recipe>.from(recipes)
      ..sort((a, b) {
        final nameA = a.name.toLowerCase();
        final nameB = b.name.toLowerCase();
        return nextAsc ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
      });

    areaRecipes[area] = sortedRecipes;
    areaRecipes.refresh();
    areaSortAscending[area] = nextAsc;
  }
}
