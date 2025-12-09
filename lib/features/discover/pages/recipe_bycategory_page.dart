import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class RecipeByCategoryPage extends StatelessWidget {
  final String category;
  const RecipeByCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final discoverController = Get.find<DiscoverController>();
    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(category, style: AppTextStyles.heading2),
        actions: [IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.magnifyingGlass))],
      ),
      body: Obx(() {
        final categoryRecipes = discoverController.categoryRecipes[category] ?? [];

        return CustomScrollView(
          slivers: [
            /// HEADER IMAGE
            SliverToBoxAdapter(
              child: Container(
                height: 170,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(image: AssetImage("assets/images/category/$category.jpg"), fit: BoxFit.cover),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${categoryRecipes.length} recipes',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// SORT (Tạm để UI)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sort by", style: AppTextStyles.heading2),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          SizedBox(width: 6),
                          FaIcon(FontAwesomeIcons.arrowDown, size: 16, color: Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final recipe = categoryRecipes[index];
                  final author = homeController.authors[recipe.authorId];

                  return RecipeCard(recipe: recipe, author: author!);
                }, childCount: categoryRecipes.length),
              ),
            ),
          ],
        );
      }),
    );
  }
}
