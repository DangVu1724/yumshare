import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';
import 'package:yumshare/models/ingredients.dart';

class IngredientController extends GetxController {
  var ingredients = <Ingredients>[].obs;

  final Map<String, TextEditingController> controllers = {};
  final uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();

    // khởi tạo 3 ingredient mặc định
    for (int i = 1; i <= 3; i++) {
      addIngredient("Ingredient $i");
    }
  }

  void addIngredient([String? description]) {
    final id = uuid.v4();
    final ing = Ingredients(ingredientId: id, description: description ?? "Ingredient ${ingredients.length + 1}");
    ingredients.add(ing);

    controllers[id] = TextEditingController(text: ing.description);
  }

  void removeIngredient(String id) {
    if (ingredients.length <= 1) return; // Đảm bảo luôn có ít nhất một ingredient
    ingredients.removeWhere((e) => e.ingredientId == id);
    controllers[id]?.dispose();
    controllers.remove(id);
  }

  void updateIngredient(String id, String value) {
    final index = ingredients.indexWhere((e) => e.ingredientId == id);
    if (index != -1) {
      ingredients[index].description = value;
      ingredients.refresh();
    }
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = ingredients.removeAt(oldIndex);
    ingredients.insert(newIndex, item);
    ingredients.refresh();
  }
}
