import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/profile/controllers/profile_controller.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final ProfileController _profileController = Get.put(ProfileController());
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.heading2),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: Obx(() {
        if (_profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = _profileController.userData.value;
        final recipes = _homeController.myRecipes;
        final authors = _homeController.authors;
        if (user == null) {
          return const Center(child: Text("No User Data"));
        }

        return DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(children: [_buildHeader(user), const SizedBox(height: 20), _buildProfileStats(user)]),
                ),
              ),
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                toolbarHeight: 0,
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(55),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: const TabBar(
                      labelColor: AppColors.primary,
                      indicatorColor: AppColors.primary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 2.5,
                      tabs: [
                        Tab(text: "Recipes"),
                        Tab(text: "About"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(children: [_buildRecipeTab(recipes, authors), _buildAboutTab(user)]),
          ),
        );
      }),
    );
  }

  Widget _buildAboutTab(user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(user.email ?? "No info yet...", style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildRecipeTab(List<Recipe> recipes, Map<String, Users> authors) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final author = authors[recipe.authorId];
        return RecipeCard(recipe: recipe, author: author!);
      },

      itemCount: recipes.length,
    );
  }

  Widget _buildHeader(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/avatar1.png")),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.heading3),
                Text(user.email),
              ],
            ),
          ],
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.edit, color: AppColors.primary),
          label: Text('Edit', style: TextStyle(color: AppColors.primary)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primary, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats(user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1),
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(user.myRecipes.length, "Recipes"),
          _divider(),
          _statItem(12, "Followers"),
          _divider(),
          _statItem(12, "Following"),
        ],
      ),
    );
  }

  Widget _statItem(int number, String label) {
    return Expanded(
      child: Column(
        children: [
          Text("$number", style: AppTextStyles.heading3),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 30, width: 1, color: Colors.grey[200]);
}
