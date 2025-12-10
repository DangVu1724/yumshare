import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';
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
        title: Text('My Bookmark', style: AppTextStyles.heading2),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Obx(() {
        final favRecipes = _homeController.favoriteRecipes;
        final authors = _homeController.authors;
        if (favRecipes.isEmpty) {
          return Center(
            child: SizedBox(
              width: 250, // hoặc MediaQuery width * 0.8
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset("assets/animations/loading2.json", height: 200),
                  Text(
                    'Nothing here yet, start by adding some items.',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
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
