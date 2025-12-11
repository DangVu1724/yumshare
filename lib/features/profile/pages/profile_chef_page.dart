import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/profile/controllers/chef_controller.dart';
import 'package:yumshare/features/profile/controllers/profile_controller.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';
import 'package:yumshare/widgets/shimmer_card_widget.dart';

class ProfileChefPage extends StatefulWidget {
  final Users chef;
  const ProfileChefPage({required this.chef, super.key});

  @override
  State<ProfileChefPage> createState() => _ProfileChefPageState();
}

class _ProfileChefPageState extends State<ProfileChefPage> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final HomeController _homeController = Get.find<HomeController>();
  final ChefProfileController _chefController = Get.put(ChefProfileController());

  @override
  void initState() {
    _chefController.loadChefRecipes(widget.chef.myRecipes);
    _chefController.checkIfFollowing(widget.chef.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.paperPlane)),
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

        final user = widget.chef;
        final recipes = _chefController.chefRecipes;
        final authors = _homeController.authors;

        return DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    children: [
                      _buildHeader(user, _chefController,_profileController),
                      const SizedBox(height: 20),
                      _buildProfileStats(user),
                    ],
                  ),
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
          const SizedBox(height: 10),

          Divider(color: Colors.grey[200]),
          const SizedBox(height: 10),

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
          const SizedBox(height: 10),

          Divider(color: Colors.grey[200]),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('More Info', style: AppTextStyles.heading3),
              const SizedBox(height: 7),
              Row(children: [Icon(Icons.location_on_outlined), const SizedBox(width: 7), Text("${user.address}")]),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.info_outline_rounded),
                  const SizedBox(width: 7),
                  Text("Joined since ${user.createdAt != null ? formatTime(user.createdAt!) : 'N/A'}"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeTab(List<Recipe> recipes, Map<String, Users> authors) {
    if (_chefController.isLoading.value) {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const ShimmerCard(),
      );
    }

    // dữ liệu xong
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final author = authors[recipe.authorId];
        return RecipeCard(recipe: recipe, author: author!);
      },
    );
  }

  Widget _buildHeader(Users user, ChefProfileController controller, ProfileController profileController) {
    final isOwner = widget.chef.userId == _chefController.userId;

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
        Obx(() {
          final isFollowing = controller.isFollowing.value;

          return isOwner
              ? const SizedBox.shrink()
              : OutlinedButton(
                  onPressed: () async {
                    await controller.toggleFollow(widget.chef.userId);
                    await profileController.fetchUserData();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isFollowing ? Colors.grey[400]! : AppColors.primary, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: TextStyle(
                      color: isFollowing ? Colors.grey[700] : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
        }),
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

  String formatTime(DateTime time) {
    return "${time.day}, ${time.month} ${time.year}";
  }
}
