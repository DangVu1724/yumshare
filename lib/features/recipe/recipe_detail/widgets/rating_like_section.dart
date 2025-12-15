import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class RatingLikeSection extends StatelessWidget {
  final Recipe recipe;
  final RecipeDetailController recipeDetailController;
  final DiscoverController discoverController;
  final VoidCallback onRatePressed;

  const RatingLikeSection({
    super.key,
    required this.recipe,
    required this.recipeDetailController,
    required this.discoverController,
    required this.onRatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            'Helpful? Give a rating or like ❤️',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onRatePressed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < recipe.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          recipe.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '(${recipe.ratingCount})',
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to rate',
                      style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              Obx(() {
                final userId = discoverController.userId!;
                final isLiked = recipeDetailController.likedBy.contains(userId);
                final likeCount = recipeDetailController.recipeLikes.value;

                return GestureDetector(
                  onTap: () => recipeDetailController.toggleLike(recipeId: recipe.id, currentUserId: userId),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isLiked ? Colors.red.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        AnimatedScale(
                          scale: isLiked ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          child: Icon(
                            isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isLiked ? Colors.red.shade400 : Colors.grey.shade600,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('$likeCount', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
