import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/profile/controllers/profile_controller.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final ProfileController _profileController = Get.find<ProfileController>();
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.heading2),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.setting);
            },
            icon: Icon(Icons.settings),
          ),
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

  Widget _buildAboutTab(Users user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description', style: AppTextStyles.heading3),
              Text('${user.description}'),
            ],
          ),
          Divider(color: Colors.grey[500]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Social Media', style: AppTextStyles.heading3),
              _socialButton(icon: FontAwesomeIcons.facebook, label: 'Facebook', link: user.facebook),
              const SizedBox(height: 5),
              _socialButton(icon: FontAwesomeIcons.whatsapp, label: 'WhatsApp', link: user.whatsapp),
              const SizedBox(height: 5),
              _socialButton(icon: FontAwesomeIcons.twitter, label: 'Twitter', link: user.twitter),
            ],
          ),
          Divider(color: Colors.grey[500]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('More Info', style: AppTextStyles.heading3),
              const SizedBox(height: 7),
              Row(children: [Icon(Icons.location_on_outlined), const SizedBox(width: 7), Text("${user.address}")]),
              const SizedBox(height: 10,),
              Row(children: [Icon(Icons.info), const SizedBox(width: 7), Text("${user.address}")]),
            ],
          ),
        ],
      ),
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

  Widget _buildHeader(Users user) {
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
          onPressed: () {
            Get.toNamed(Routes.editProfile);
          },
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

  Widget _buildProfileStats(Users user) {
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
          _statItem(user.followers.length, "Followers"),
          _divider(),
          _statItem(user.following.length, "Following"),
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

  Widget _socialButton({required IconData icon, required String label, required String? link}) {
    return TextButton.icon(
      onPressed: () => _profileController.openLink(link),
      icon: FaIcon(icon, color: AppColors.primary),
      label: Text(label, style: TextStyle(color: AppColors.primary, fontSize: 16)),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(0, 32),
        alignment: Alignment.centerLeft,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _divider() => Container(height: 30, width: 1, color: Colors.grey[200]);
}
