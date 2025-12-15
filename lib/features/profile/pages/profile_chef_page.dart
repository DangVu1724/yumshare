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
                      _buildHeader(user, _chefController, _profileController),
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
    // Xử lý description - nếu không có thì tạo mô tả mặc định
    String userDescription = user.description?.isNotEmpty == true
        ? user.description!
        : "Hi there! I'm ${user.name} from ${user.country ?? 'around the world'}. I love cooking ${user.cookingLevel?.toLowerCase() ?? 'delicious'} meals and exploring new recipes! 🍳";

    // Xử lý cooking level hiển thị
    String cookingLevelText = user.cookingLevel?.isNotEmpty == true ? user.cookingLevel! : "Not specified";

    // Format cooking level với icon
    String getCookingLevelWithIcon(String level) {
      switch (level.toLowerCase()) {
        case 'beginner':
          return '🍳 $level';
        case 'amateur':
          return '👨‍🍳 $level';
        case 'intermediate':
          return '🔥 $level';
        case 'expert':
          return '🏆 $level';
        default:
          return '👤 $level';
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ABOUT SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('About', style: AppTextStyles.heading3.copyWith(color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cooking Level
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.restaurant_menu_rounded, color: Colors.grey.shade600, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cooking Level', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              Text(
                                getCookingLevelWithIcon(cookingLevelText),
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 24, color: Colors.grey),

                  // Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_outlined, color: Colors.grey.shade600, size: 18),
                          const SizedBox(width: 12),
                          Text('Description', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          userDescription,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- SOCIAL MEDIA SECTION ---
            if (user.facebook?.isNotEmpty == true ||
                user.whatsapp?.isNotEmpty == true ||
                user.twitter?.isNotEmpty == true)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.link_rounded, color: Colors.blue, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text('Social Media', style: AppTextStyles.heading3.copyWith(color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Column(
                      children: [
                        if (user.facebook?.isNotEmpty == true)
                          _socialButton(icon: FontAwesomeIcons.facebook, label: 'Facebook', link: user.facebook),

                        if (user.whatsapp?.isNotEmpty == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _socialButton(
                              icon: FontAwesomeIcons.whatsapp,
                              label: 'WhatsApp',
                              link: user.whatsapp,
                            ),
                          ),

                        if (user.twitter?.isNotEmpty == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _socialButton(icon: FontAwesomeIcons.twitter, label: 'Twitter', link: user.twitter),
                          ),
                      ],
                    ),
                  ],
                ),
              )
            else
              Container(),

            const SizedBox(height: 16),

            // --- MORE INFO SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.info_outline_rounded, color: Colors.purple, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('More Info', style: AppTextStyles.heading3.copyWith(color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Column(
                    children: [
                      // Country
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.grey.shade600, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Country', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.country?.isNotEmpty == true ? user.country! : 'Not specified',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Join Date
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, color: Colors.grey.shade600, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Member Since', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.createdAt != null ? formatTime(user.createdAt!) : 'N/A',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
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
