import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class RecipeSection extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;
  final Map<String, Users> authors;

  const RecipeSection({super.key, required this.title, required this.recipes, required this.authors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: Obx(() {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final recipe = recipes[index];
                final author = authors[recipe.authorId];
                return RecipeCard(recipe: recipe, author: author!);
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: recipes.length,
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

Widget _buildTitle(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Icon(Icons.arrow_forward, size: 20, color: AppColors.primary),
    ],
  );
}
