import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
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
  final Rxn<dynamic> image = Rxn<dynamic>();
  var isUpdating = false.obs;
  var isShared = false.obs;

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
    final img = image.value;
    if (img == null) return null;

    if (img is File) {
      final bytes = await img.readAsBytes();
      return base64Encode(bytes);
    }
    return null;
  }

  Future<void> togglePublishedRecipe(String recipeId) async {
    try {
      final docRef = FirebaseFirestore.instance.collection("recipes").doc(recipeId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final current = snapshot['isShared'] as bool;
        await docRef.update({'isShared': !current});
        isShared.value = !current;
      }
    } catch (e) {
      Logger().d('$e');
    }
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

  Future<void> updateRecipe(
    String id, {
    String? name,
    String? description,
    double? cookingTime,
    String? region,
    String? category,
    List<Ingredients>? ingredients,
    List<RecipeStep>? steps,
    String? imageUrl,
    int? people,
  }) async {
    final Map<String, dynamic> data = {
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (cookingTime != null) "cookingTime": cookingTime,
      if (region != null) "regions": region,
      if (category != null) "category": category,
      if (ingredients != null) "ingredients": ingredients.map((e) => e.toMap()).toList(),
      if (steps != null) "steps": steps.map((e) => e.toMap()).toList(),
      if (imageUrl != null) "imageUrl": imageUrl,
      if (people != null) "servingPeople": people,
      "updatedAt": DateTime.now(),
    };

    isUpdating.value = true;
    try {
      await repo.updateRecipe(id, data);
      await homeController.loadMyRecipes();
      await discoverController.fetchAllRecipes();
    } catch (e) {
      Logger().d("$e");
    } finally {
      isUpdating.value = false;
    }
  }
}
