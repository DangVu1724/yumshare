import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/myrecipe/widgets/myrecipe_card_widget.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  final HomeController _homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Recipes', style: AppTextStyles.heading2),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            SizedBox(width: 5),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
          ],
          bottom: TabBar(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.5,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Draft', style: AppTextStyles.body),
                    const SizedBox(width: 3),
                    Text("(${_homeController.myRecipes.length})"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Published', style: AppTextStyles.body),
                    const SizedBox(width: 3),
                    Text("(${_homeController.favoriteRecipes.length})"),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListRecipe(_homeController.myRecipes, _homeController.authors),
            _buildListRecipe(_homeController.favoriteRecipes, _homeController.authors),
          ],
        ),
      ),
    );
  }
}

Widget _buildListRecipe(List<Recipe> myRecipes, Map<String, Users> authors) {
  return Obx(() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final recipe = myRecipes[index];
        final author = authors[recipe.authorId];
        return MyrecipeCardWidget(recipe: recipe, author: author!);
      },

      itemCount: myRecipes.length,
    );
  });
}
