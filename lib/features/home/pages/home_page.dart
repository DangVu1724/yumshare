import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YumShare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to settings page
            },
          ),

          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              // Navigate to settings page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              // Add your home page content here
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(image: AssetImage('assets/images/banner.png'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              _buildSection('Popular Recipes'),
              _buildSection('My Recipes'),
              _buildSection('Bookmark Recipes'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSection(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_buildTitle(title), const SizedBox(height: 10), _buildRecipeList(), const SizedBox(height: 20)],
  );
}

Widget _buildTitle(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.arrow_forward, size: 20, color: AppColors.primary),
      ),
    ],
  );
}

Widget _buildRecipeList() {
  final HomeController _homeController = Get.put(HomeController());

  return Obx(() {
    if (_homeController.isLoading.value) return Center(child: CircularProgressIndicator());
    final recipes = _homeController.myRecipes;
    return SizedBox(
      height: 240,
      child: ListView.separated(
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _buildRecipeCard(recipe);
        },
        separatorBuilder: (context, index) => const SizedBox(width: 5),
        itemCount: recipes.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  });
}

Widget _buildRecipeCard(Recipe recipe) {
  return SizedBox(
    height: 240,
    width: 180,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
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
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                // Handle bookmark action
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.bookmark_border, color: Colors.white, size: 22),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Text(
              recipe.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
