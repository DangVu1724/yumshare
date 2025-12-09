import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/models/recipes.dart';

class DiscoverSearchController extends GetxController {
  final DiscoverController discoverController = Get.find<DiscoverController>();
  final searchController = TextEditingController();
  final focusNode = FocusNode();

  var query = ''.obs;
  var searchResults = <Recipe>[].obs;
  var isLoading = false.obs;

  var history = <String>[].obs;
  var suggestions = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();

    ever(discoverController.allRecipes, (_) {
      if (query.value.isEmpty) {
        searchResults.clear();
      } else {
        performSearch(query.value);
      }
    });
  }

  void onTyping(String keyword) {
    query.value = keyword.trim();

    if (keyword.isEmpty) {
      suggestions.clear();
      searchResults.clear();
      return;
    }

    final results = discoverController.allRecipes.where((recipe) {
      return recipe.name.toLowerCase().contains(keyword.toLowerCase());
    }).toList();

    // Chỉ hiển thị tối đa 5 gợi ý
    suggestions.assignAll(results.take(5));
  }

  void onSubmitSearch(String keyword) {
    final trimmedKeyword = keyword.trim();
    if (trimmedKeyword.isEmpty) return;

    performSearch(trimmedKeyword);
    saveToHistory(trimmedKeyword);

    suggestions.clear();
  }

  void performSearch(String keyword) {
    query.value = keyword;

    final results = discoverController.allRecipes.where((recipe) {
      return recipe.name.toLowerCase().contains(keyword.toLowerCase());
    }).toList();

    searchResults.assignAll(results);
  }

  void selectSuggestion(Recipe recipe) {
    searchController.text = recipe.name;
    performSearch(recipe.name);
    saveToHistory(recipe.name);
    suggestions.clear();
    focusNode.unfocus();
  }

  void saveToHistory(String keyword) {
    // Xóa nếu đã tồn tại để tránh trùng lặp
    history.remove(keyword);

    history.insert(0, keyword);

    if (history.length > 10) {
      history.removeLast();
    }
  }

  void clearSearch() {
    searchController.clear();
    query.value = '';
    suggestions.clear();
    searchResults.clear();
    focusNode.requestFocus();
  }

  void removeHistory(String keyword) => history.remove(keyword);

  void clearHistory() => history.clear();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 300), () {
      focusNode.requestFocus();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
