import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/ingredients.dart';
import 'package:yumshare/models/recipte_step.dart';
import 'package:yumshare/models/recipes.dart';

class DiscoverController extends GetxController {
  final firestore = FirebaseFirestore.instance;

  var logger = Logger();

  // -----------------------------------------
  // 🔥 Convert từ API về Recipe
  // -----------------------------------------
  static Recipe fromMealDb(Map<String, dynamic> map) {
    var uuid = const Uuid();

    // Convert ingredients
    List<Ingredients> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      String? ing = map["strIngredient$i"];
      String? measure = map["strMeasure$i"];

      if (ing != null && ing.trim().isNotEmpty) {
        String combined = "${measure?.trim() ?? ''} ${ing.trim()}".trim();

        ingredients.add(Ingredients(ingredientId: uuid.v4(), description: combined));
      }
    }

    // Convert steps
    List<RecipeStep> steps = [];
    if (map["strInstructions"] != null) {
      List<String> lines = map["strInstructions"].toString().split(RegExp(r'\r\n|\n'));
      int count = 1;
      for (var line in lines) {
        if (line.trim().isNotEmpty) {
          steps.add(RecipeStep(stepNumber: count++, description: line.trim()));
        }
      }
    }

    return Recipe(
      id: uuid.v4(),
      name: map["strMeal"] ?? "",
      authorId: "WXkMrFvVeHVxP5ISp5skcexOD2H2",
      isShared: false,
      ingredients: ingredients,
      steps: steps,
      imageUrl: map["strMealThumb"],
      likes: 0,
      description: map["strTags"] ?? "",
      regions: map["strArea"] ?? "Unknown",
      category: map["strCategory"] ?? "",
    );
  }

  // -----------------------------------------
  // 🔥 Lưu Firestore
  // -----------------------------------------
  Future<void> saveRecipeToFirebase(Recipe recipe) async {
    try {
      await firestore.collection("recipes").doc(recipe.id).set(recipe.toMap());
      logger.d("Uploaded: ${recipe.name}");
    } catch (e) {
      logger.d("Firebase error: $e");
    }
  }

  // -----------------------------------------
  // 🔥 Fetch theo letter
  // -----------------------------------------
  Future<void> fetchMealsByLetter(String letter) async {
    try {
      final url = Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=$letter");
      final response = await GetConnect().get(url.toString());

      if (response.statusCode == 200 && response.body['meals'] != null) {
        final List meals = response.body['meals'];

        for (var meal in meals) {
          final recipe = fromMealDb(meal);

          // SAVE FIREBASE
          await saveRecipeToFirebase(recipe);
        }
      }
    } catch (e) {
      logger.d("Error: $e");
    }
  }

  // -----------------------------------------
  // 🔥 Import toàn bộ A → Z
  // -----------------------------------------
  Future<void> importMeals() async {
    const alphabet = "abcdefghijklmnopqrstuvwxyz";

    for (var letter in alphabet.split('')) {
      logger.d("Fetching: $letter");
      await fetchMealsByLetter(letter);
    }

    logger.d(" DONE IMPORT A-Z");
  }

  final AuthService _authService = AuthService();

  Future<void> copyRecipesToUserMyRecipes() async {
    final userId = _authService.currentUser?.uid;

    if (userId == null) return;

    // 1. Lấy tất cả recipe của user
    final recipeSnapshot = await firestore.collection("recipes").where("authorId", isEqualTo: userId).get();

    // Lấy danh sách ID
    final recipeIds = recipeSnapshot.docs.map((doc) => doc.id).toList();

    // 2. Lấy user hiện tại
    final userDoc = firestore.collection("users").doc(userId);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) return;

    List<dynamic> currentMyRecipes = userSnapshot.data()?["myRecipes"] ?? [];

    // 3. Gộp ID (không duplicate)
    final updatedList = {...currentMyRecipes.map((e) => e.toString()), ...recipeIds}.toList();

    // 4. Update user
    await userDoc.update({"myRecipes": updatedList});

    logger.d("Copied ${recipeIds.length} recipes to user's myRecipes!");
  }
}
