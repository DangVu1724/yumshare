import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/home/widgets/recipe_section.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YumShare',style: AppTextStyles.heading2.copyWith(color: AppColors.primary),),
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

                // Kiểm tra xem tất cả danh sách có rỗng không
                final hasAnyData = _homeController.myRecipes.isNotEmpty || _homeController.favoriteRecipes.isNotEmpty;

                if (!hasAnyData) {
                  // Nếu tất cả rỗng → hiển thị empty state chung
                  return SizedBox(
                    height: 240,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/animations/loading.json", height: 150),
                          const SizedBox(height: 10),
                          Text(
                            'No recipes available yet.',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Chỉ hiển thị section nào có dữ liệu
                final List<Widget> sections = [];

                if (_homeController.myRecipes.isNotEmpty) {
                  sections.add(
                    RecipeSection(
                      title: "My Recipes",
                      recipes: _homeController.myRecipes,
                      authors: _homeController.authors,
                    ),
                  );
                }

                if (_homeController.favoriteRecipes.isNotEmpty) {
                  sections.add(
                    RecipeSection(
                      title: "Bookmark Recipes",
                      recipes: _homeController.favoriteRecipes,
                      authors: _homeController.authors,
                    ),
                  );
                }

                // Thêm khoảng cách giữa các section
                return Column(
                  children: sections
                      .map((section) => Padding(padding: const EdgeInsets.only(bottom: 20), child: section))
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
