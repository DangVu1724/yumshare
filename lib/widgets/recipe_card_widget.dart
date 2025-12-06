import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Users author;

  RecipeCard({
    super.key,
    required this.recipe,
    required this.author,
  });

  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 180,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            // Ảnh nền
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                        ? NetworkImage(recipe.imageUrl!)
                        : const AssetImage('assets/images/images.jpg') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Lớp mờ đen
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.35),
                ),
              ),
            ),

            // Nút favorite
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  _homeController.toggleFavorite(recipe.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Obx(() {
                    final isFav = _homeController.isFavorite(recipe.id);
                    return Icon(
                      isFav ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                      size: 22,
                    );
                  }),
                ),
              ),
            ),

            // Tên + tác giả
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),

                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage("assets/images/avatar1.png"),
                        ),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        author.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
