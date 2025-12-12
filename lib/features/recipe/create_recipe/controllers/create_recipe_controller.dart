import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/models/ingredients.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/recipte_step.dart';
import 'package:yumshare/repository/recipe_repository.dart';

class CreateRecipeController extends GetxController {
  final RecipeRepository repo = RecipeRepository();
  final HomeController homeController = Get.find<HomeController>();
  final DiscoverController discoverController = Get.find<DiscoverController>();
  final auth = AuthService();

  // Chỉ một region
  String? selectedRegion;
  String? selectedCategory;
  final TextEditingController textEditingController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final Rxn<File> image = Rxn<File>();

  // Regions – chỉ chọn 1
  final List<String> regions = [
    "Algerian",
    "American",
    "Argentinian",
    "Australian",
    "British",
    "Canadian",
    "Chinese",
    "Croatian",
    "Dutch",
    "Egyptian",
    "Filipino",
    "French",
    "Greek",
    "Indian",
    "Irish",
    "Italian",
    "Jamaican",
    "Japanese",
    "Kenyan",
    "Malaysian",
    "Mexican",
    "Moroccan",
    "Norwegian",
    "Polish",
    "Portuguese",
    "Russian",
    "Saudi Arabian",
    "Slovakian",
    "Spanish",
    "Syrian",
    "Thai",
    "Tunisian",
    "Turkish",
    "Ukrainian",
    "Uruguayan",
    "Venezulan",
    "Vietnamese",
  ];

  // Categories – chọn nhiều
  final List<String> categories = [
    "Beef",
    "Chicken",
    "Dessert",
    "Lamb",
    "Miscellaneous",
    "Pasta",
    "Pork",
    "Seafood",
    "Side",
    "Starter",
    "Vegan",
    "Vegetarian",
    "Breakfast",
    "Goat",
  ];

  Future<void> pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      image.value = File(file.path);
    }
  }

  void clearImage() {
    image.value = null;
  }

  Future<String?> convertImageToBase64() async {
    if (image.value == null) return null;

    final bytes = await image.value!.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> createRecipe({
    required String name,
    required String description,
    required double cookingTime,
    required String region,
    required String category,
    required List<Ingredients> ingredients,
    required List<RecipeStep> steps,
    required String imageUrl,
    required int people,
  }) async {
    final recipe = Recipe(
      id: Uuid().v4(),
      name: name,
      description: description,
      cookingTime: cookingTime,
      regions: region,
      category: category,
      ingredients: ingredients,
      steps: steps,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      authorId: auth.currentUser!.uid,
      isShared: false,
      servingPeople: people,
    );

    await repo.creatRecipe(recipe);
    await homeController.loadMyRecipes();
    await discoverController.fetchAllRecipes();
  }
}
