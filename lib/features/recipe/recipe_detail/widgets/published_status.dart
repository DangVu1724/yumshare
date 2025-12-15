import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class PublishedStatus extends StatelessWidget {
  final String recipeId;
  final HomeController homeController;
  final CreateRecipeController createRecipeController;

  const PublishedStatus({
    super.key,
    required this.recipeId,
    required this.homeController,
    required this.createRecipeController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPublished = homeController.isPublished(recipeId);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isPublished ? Colors.green.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isPublished ? Colors.green.shade200 : Colors.orange.shade200, width: 1),
        ),
        child: Row(
          children: [
            Icon(isPublished ? Icons.public : Icons.lock_outline, color: isPublished ? Colors.green : Colors.orange, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isPublished ? 'Published' : 'Private',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isPublished ? Colors.green.shade800 : Colors.orange.shade800)),
                  Text(isPublished ? 'This recipe is visible to everyone' : 'Only you can see this recipe',
                      style: TextStyle(fontSize: 12, color: isPublished ? Colors.green.shade600 : Colors.orange.shade600)),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                await createRecipeController.togglePublishedRecipe(recipeId);
                homeController.togglePublished(recipeId);
              },
              child: Text(isPublished ? 'Make Private' : 'Publish',
                  style: TextStyle(color: isPublished ? Colors.green.shade700 : AppColors.primary, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
    });
  }
}