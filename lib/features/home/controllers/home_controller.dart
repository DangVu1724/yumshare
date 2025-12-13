import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/repository/recipe_repository.dart';

class HomeController extends GetxController {
  final RecipeRepository recipeRepository = RecipeRepository();

  RxList<Recipe> myRecipes = <Recipe>[].obs;
  RxList<Recipe> favoriteRecipes = <Recipe>[].obs;
  RxList<Recipe> publishRecipes = <Recipe>[].obs;
  RxSet<String> favoriteIds = <String>{}.obs;
  RxSet<String> publishedIds = <String>{}.obs;

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
    publishRecipes.value = myRecipes.where((r) => r.isShared == true).toList();
    publishedIds.value = myRecipes.where((r) => r.isShared == true).map((r) => r.id).toSet();
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

  void togglePublished(String recipeId) {
    if (publishedIds.contains(recipeId)) {
      publishedIds.remove(recipeId);
    } else {
      publishedIds.add(recipeId);
    }
  }

  bool isPublished(String recipeId) => publishedIds.contains(recipeId);

  bool isFavorite(String recipeId) => favoriteIds.contains(recipeId);

  ImageProvider buildImageProvider(String? value) {
    if (value == null || value.isEmpty) {
      return const AssetImage('assets/images/images.jpg');
    }

    // Nếu là base64
    final isBase64 = value.startsWith('data:image') || RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(value);

    if (isBase64) {
      // Tách prefix data:image/...;base64,
      final cleaned = value.contains(',') ? value.split(',').last : value;

      return MemoryImage(base64Decode(cleaned));
    }

    // Còn lại là URL mạng
    return NetworkImage(value);
  }
}
