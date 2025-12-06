import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/home/widgets/recipe_section.dart';
import 'package:yumshare/routers/app_routes.dart';

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
              Get.toNamed(Routes.favourite);
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
              Obx(() {
                if (_homeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    RecipeSection(
                      title: "Popular Recipes",
                      recipes: _homeController.myRecipes,
                      authors: _homeController.authors,
                    ),
                    RecipeSection(
                      title: "My Recipes",
                      recipes: _homeController.myRecipes,
                      authors: _homeController.authors,
                    ),
                    RecipeSection(
                      title: "Bookmark Recipes",
                      recipes: _homeController.favoriteRecipes,
                      authors: _homeController.authors,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
