import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/ingredient_provider.dart';

class IngredientItem extends StatelessWidget {
  const IngredientItem({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<IngredientController>();

    return Obx(() {
      if (ctrl.ingredients.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("No ingredients"),
          ),
        );
      }

      return SliverReorderableList(
        itemCount: ctrl.ingredients.length,
        onReorder: (oldIndex, newIndex) {
          ctrl.reorder(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final ing = ctrl.ingredients[index];
          final controller = ctrl.controllers[ing.ingredientId]!;

          return ReorderableDragStartListener(
            key: ValueKey(ing.ingredientId),
            index: index,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.menu),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color.fromARGB(255, 249, 237, 241),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.pink, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (val) => ctrl.updateIngredient(ing.ingredientId, val),
                      decoration: InputDecoration(
                        hintText: "Ingredient ${index + 1}",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => ctrl.removeIngredient(ing.ingredientId),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
