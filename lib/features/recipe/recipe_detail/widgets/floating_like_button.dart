import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';

class FloatingLikeButton extends StatelessWidget {
  final RecipeDetailController recipeDetailController;
  final String recipeId;
  final String userId;

  const FloatingLikeButton({
    super.key,
    required this.recipeDetailController,
    required this.recipeId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLiked = recipeDetailController.isLiked(recipeId);
      return FloatingActionButton(
        onPressed: () => recipeDetailController.toggleLike(recipeId: recipeId, currentUserId: userId),
        backgroundColor: isLiked ? Colors.red.shade500 : Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(
          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isLiked ? Colors.white : Colors.red.shade400,
          size: 28,
        ),
      );
    });
  }
}