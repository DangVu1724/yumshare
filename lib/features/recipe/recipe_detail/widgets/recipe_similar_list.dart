import 'package:flutter/material.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class SimilarRecipes extends StatelessWidget {
  final List<Recipe> recipes;
  final Map<String, Users> authors;

  const SimilarRecipes({super.key, required this.recipes, required this.authors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('More Recipes Like This', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
          ],
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final author = authors[recipe.authorId]!;
              return RecipeCard(recipe: recipe, author: author);
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }
}
