import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookmark'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Obx(() {
        if (_homeController.isLoading.value || _homeController.isAuthorLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        final favRecipes = _homeController.favoriteRecipes;
        final authors = _homeController.authors;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final recipe = favRecipes[index];
            final author = authors[recipe.authorId];
            return RecipeCard(recipe: recipe, author: author!);
          },

          itemCount: favRecipes.length,
        );
      }),
    );
  }
}
