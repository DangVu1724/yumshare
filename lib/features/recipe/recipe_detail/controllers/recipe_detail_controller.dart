import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumshare/models/ingredients.dart';
import 'package:yumshare/models/recipte_step.dart';
import 'package:yumshare/models/recipes.dart';

class RecipeDetailController extends GetxController {
  final firestore = FirebaseFirestore.instance;

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
      isShared: true,
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
      print("Uploaded: ${recipe.name}");
    } catch (e) {
      print("Firebase error: $e");
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
      print("Error: $e");
    }
  }

  // -----------------------------------------
  // 🔥 Import toàn bộ A → Z
  // -----------------------------------------
  Future<void> importMeals() async {
    const alphabet = "rstuvwxyz";

    for (var letter in alphabet.split('')) {
      print("Fetching: $letter");
      await fetchMealsByLetter(letter);
    }

    print("🔥 DONE IMPORT A-Z");
  }
}