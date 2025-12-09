import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final DiscoverController controller = Get.find<DiscoverController>();

  bool isPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isPrecached) {
      precacheCategories();
      isPrecached = true; // tránh preload lại khi rebuild
    }
  }

  void precacheCategories() {
    for (var category in controller.categories) {
      precacheImage(AssetImage(category['image']!), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover', style: AppTextStyles.heading2)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.search);
                },
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Text("Search for the recipe or Chef", style: AppTextStyles.body.copyWith(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ),
              _buildTitleSection('Recipe Categories', Routes.categoryRecipe),
              const SizedBox(height: 8),
              _buildSectionCategory(controller),
              // _buildTitleSection('Our Recommendations'),
              // _buildTitleSection('Most Searches'),
              _buildTitleSection('New Recipes', ''),
              _buildSectionNewRecipes(controller),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTitleSection(String title, String route) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: AppTextStyles.bodyBold.copyWith(fontSize: 20)),
      IconButton(
        onPressed: () {
          Get.toNamed(route);
        },
        icon: Icon(Icons.arrow_forward, color: AppColors.primary),
      ),
    ],
  );
}

Widget _buildSectionCategory(DiscoverController controller) {
  return SizedBox(
    height: 150,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: controller.categories.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final category = controller.categories[index];
        final name = category['name']!;
        final image = category['image']!;
        final count = controller.getCategoryCount(name);
        return _categoryCard(title: name, image: image, count: count);
      },
    ),
  );
}

Widget _buildSectionNewRecipes(DiscoverController controller) {
  final HomeController homeController = Get.find<HomeController>();
  return SizedBox(
    height: 250,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: controller.categories.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final recipes = controller.newRecipes;
        final authors = homeController.authors;
        final recipe = recipes[index];
        final author = authors[recipe.authorId]!;
        return RecipeCard(recipe: recipe, author: author);
      },
    ),
  );
}

Widget _categoryCard({required String title, required String image, required int count}) {
  return SizedBox(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
              ),
            ),
          ),

          // overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black.withOpacity(0.35)),
            ),
          ),

          Positioned(
            bottom: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$count recipes',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
