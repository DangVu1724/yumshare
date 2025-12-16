import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/models/country.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class RecipeByAreaPage extends StatelessWidget {
  final Country area;
  const RecipeByAreaPage({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    final discoverController = Get.find<DiscoverController>();
    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(area.name, style: AppTextStyles.heading2),
        actions: [IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.magnifyingGlass))],
      ),
      body: Obx(() {
        final areaRecipes = discoverController.areaRecipes[area.adjective] ?? [];

        return CustomScrollView(
          slivers: [
            /// HEADER IMAGE
            SliverToBoxAdapter(
              child: Container(
                height: 170,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(image: NetworkImage(area.flag), fit: BoxFit.cover),
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
                            area.name,
                            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${areaRecipes.length} recipes',
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
                      onTap: () {
                        discoverController.toggleSortRecipesByArea(area.adjective);
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 6),
                          Obx(() {
                            final asc = discoverController.areaSortAscending[area.adjective] ?? true;
                            return Icon(asc ? Icons.arrow_downward : Icons.arrow_upward, color: AppColors.primary,);
                          }),
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
                  final recipe = areaRecipes[index];
                  final author = homeController.authors[recipe.authorId];

                  return RecipeCard(recipe: recipe, author: author!);
                }, childCount: areaRecipes.length),
              ),
            ),
          ],
        );
      }),
    );
  }
}
