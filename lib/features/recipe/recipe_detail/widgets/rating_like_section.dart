import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class RatingLikeSection extends StatelessWidget {
  final Recipe recipe;
  final RecipeDetailController controller;
  final DiscoverController discoverController;

  const RatingLikeSection({
    super.key,
    required this.recipe,
    required this.controller,
    required this.discoverController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header với rating hiện tại
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recipe Rating',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Hiển thị rating trung bình
                      Obx(() {
                        final hasRated = controller.hasRated.value;
                        final currentRating = hasRated
                            ? ((recipe.rating * recipe.ratingCount + controller.userRating.value) /
                                (recipe.ratingCount + 1))
                            : recipe.rating;
                        
                        return Row(
                          children: [
                            Text(
                              currentRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber.shade500,
                              size: 24,
                            ),
                          ],
                        );
                      }),
                      const SizedBox(width: 8),
                      // Hiển thị số lượt đánh giá
                      Obx(() {
                        final hasRated = controller.hasRated.value;
                        final ratingCount = hasRated
                            ? recipe.ratingCount + 1
                            : recipe.ratingCount;
                        
                        return Text(
                          '($ratingCount ${ratingCount == 1 ? 'review' : 'reviews'})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
              
              // Like section ở góc phải
              Obx(() {
                final userId = discoverController.userId!;
                final isLiked = controller.likedBy.contains(userId);
                final likeCount = controller.recipeLikes.value;

                return GestureDetector(
                  onTap: () => controller.toggleLike(recipeId: recipe.id, currentUserId: userId),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isLiked ? Colors.red.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isLiked ? Colors.red.shade200 : Colors.grey.shade200,
                      ),
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
                        Text(
                          '$likeCount',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isLiked ? Colors.red.shade400 : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 20),

          // Rating section cho người dùng
          Column(
            children: [
              Text(
                'Did you enjoy this recipe?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              Obx(() {
                final hasRated = controller.hasRated.value;
                final currentRating = hasRated
                    ? controller.userRating.value
                    : recipe.rating;

                return Column(
                  children: [
                    // Star rating với size lớn hơn
                    StarRating(
                      rating: controller.userRating.value,
                      size: 42,
                      color: Colors.amber,
                      borderColor: Colors.amber.withOpacity(0.5),
                      starCount: 5,
                      allowHalfRating: false,
                      onRatingChanged: hasRated
                          ? null
                          : (value) {
                              controller.userRating.value = value;
                            },
                    ),

                    const SizedBox(height: 12),

                    // Thông báo trạng thái rating
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: hasRated ? Colors.green.shade50 : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasRated
                              ? Colors.green.shade200
                              : Colors.blue.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasRated ? Icons.check_circle : Icons.star_outline,
                            size: 16,
                            color: hasRated ? Colors.green.shade600 : Colors.blue.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hasRated
                                ? 'You rated ${currentRating.toStringAsFixed(1)} ⭐'
                                : 'Tap stars to rate this recipe',
                            style: TextStyle(
                              fontSize: 13,
                              color: hasRated
                                  ? Colors.green.shade800
                                  : Colors.blue.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Nút submit rating
                    if (!hasRated)
                      Obx(() {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isSubmittingRating.value
                                ? null
                                : () {
                                    controller.submitRating(
                                      recipeId: recipe.id,
                                      rating: controller.userRating.value,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: controller.isSubmittingRating.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_rounded, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Submit Rating',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}