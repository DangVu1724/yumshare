import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Users author;

  RecipeCard({super.key, required this.recipe, required this.author});

  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 180,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.recipeDetail, arguments: {"recipe": recipe, "user": author});
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          elevation: 2,
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              // Ảnh nền
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: _homeController.buildImageProvider(recipe.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),

              // Top section: Like, Rating, Favorite
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Like and Rating container
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Like section
                            if (recipe.likesCount > 0) ...[
                              Row(
                                children: [
                                  Icon(Icons.favorite_rounded, color: Colors.red.shade300, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatCount(recipe.likesCount),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                            ],

                            // Rating section
                            Row(
                              children: [
                                Icon(Icons.star_rounded, color: Colors.amber.shade400, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  recipe.rating > 0 ? recipe.rating.toStringAsFixed(1) : 'N/A',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                // Hiển thị số rating count nếu có
                                if (recipe.ratingCount > 0) ...[
                                  const SizedBox(width: 2),
                                  Text(
                                    '(${recipe.ratingCount})',
                                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Favorite button
                      GestureDetector(
                        onTap: () {
                          _homeController.toggleFavorite(recipe.id);
                        },
                        child: Obx(() {
                          final isFav = _homeController.isFavorite(recipe.id);
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                            child: Icon(
                              isFav ? Icons.bookmark : Icons.bookmark_border,
                              color: isFav ? AppColors.primary : Colors.white,
                              size: 20,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom section: Recipe name and author
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe name
                      Text(
                        recipe.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Author info
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage: _homeController.buildImageProvider(author.photoUrl),
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Author name and info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  author.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to format count
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
