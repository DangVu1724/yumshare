import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/dialogs/recipe_info_dialog.dart';
import 'package:yumshare/features/recipe/recipe_detail/dialogs/share_bottom_sheet.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/comment_section.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/rating_like_section.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/published_status.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/floating_like_button.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/recipe_detail_tutorial.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/recipe_info_chips.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/recipe_ingredients.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/recipe_instructions.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/recipe_similar_list.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  final Users user;

  const RecipeDetailPage({required this.recipe, required this.user, super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final DiscoverController discoverController = Get.find<DiscoverController>();
  final HomeController homeController = Get.find<HomeController>();
  final CreateRecipeController createRecipeController = Get.find<CreateRecipeController>();
  final RecipeDetailController recipeDetailController = Get.find<RecipeDetailController>();

  bool isCollapsed = false;
  List<Recipe> similar = [];
  GlobalKey publishKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  final RecipeDetailTutorial tutorialHelper = RecipeDetailTutorial();
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    similar = discoverController.getSimilarRecipes(widget.recipe);
    recipeDetailController.initWithRecipe(widget.recipe.id);

    tutorialHelper.createTutorial(publishKey, () => logger.d("Tutorial finished"));

    tutorialCoachMark = tutorialHelper.tutorialCoachMark;

    // Chỉ show tutorial nếu là owner VÀ recipe chưa published
    final isOwner = widget.recipe.authorId == discoverController.userId;
    final isPublished = homeController.isPublished(widget.recipe.id);

    if (isOwner && !isPublished) {
      Future.delayed(Duration.zero, () {
        tutorialCoachMark.show(context: context);
      });
      // Tự động finish sau 3 giây như cũ (tùy chọn)
      Future.delayed(const Duration(seconds: 3), () {
        tutorialCoachMark.finish();
      });
    }
    // Nếu đã published hoặc không phải owner → không show gì cả
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.recipe.authorId == discoverController.userId;

    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll.metrics.pixels > 200 && !isCollapsed) {
          setState(() => isCollapsed = true);
        } else if (scroll.metrics.pixels <= 200 && isCollapsed) {
          setState(() => isCollapsed = false);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 320,
              elevation: 0,
              backgroundColor: isCollapsed ? Colors.white : Colors.transparent,
              title: isCollapsed
                  ? Text(
                      widget.recipe.name,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  : null,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: isCollapsed ? Colors.black : Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                // Bookmark
                Obx(() {
                  final isFav = homeController.isFavorite(widget.recipe.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.bookmark : Icons.bookmark_border,
                      color: isFav ? AppColors.primary : (isCollapsed ? Colors.black : Colors.white),
                    ),
                    onPressed: () => homeController.toggleFavorite(widget.recipe.id),
                  );
                }),

                // Publish (owner only)
                if (isOwner)
                  Obx(() {
                    final isPublished = homeController.isPublished(widget.recipe.id);
                    return IconButton(
                      key: publishKey,
                      icon: FaIcon(
                        FontAwesomeIcons.solidPaperPlane,
                        size: 15,
                        color: isPublished ? AppColors.primary : (isCollapsed ? Colors.black : Colors.white),
                      ),
                      onPressed: () async {
                        await createRecipeController.togglePublishedRecipe(widget.recipe.id);
                        homeController.togglePublished(widget.recipe.id);
                      },
                    );
                  }),

                // Share (non-owner)
                if (!isOwner)
                  IconButton(
                    icon: Icon(Icons.share, color: isCollapsed ? Colors.black : Colors.white),
                    onPressed: () => showShareBottomSheet(context),
                  ),

                // Info
                IconButton(
                  icon: Icon(Icons.info, color: isCollapsed ? Colors.black : Colors.white),
                  onPressed: () => showRecipeInfoDialog(context, widget.recipe),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: homeController.buildImageProvider(widget.recipe.imageUrl), fit: BoxFit.cover),
                    Positioned.fill(child: Container(color: Colors.black.withOpacity(0.35))),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3),
                    ),
                    const SizedBox(height: 20),

                    // Author section
                    Row(
                      children: [
                        const CircleAvatar(radius: 34, backgroundImage: AssetImage("assets/images/avatar1.png")),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(widget.user.email, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                        const Spacer(),
                        if (isOwner)
                          ElevatedButton(
                            onPressed: () => Get.toNamed(Routes.editRecipe, arguments: widget.recipe),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                            ),
                            child: const Text("Edit", style: TextStyle(color: Colors.white)),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                            ),
                            child: const Text("Follow", style: TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      widget.recipe.description.trim().isEmpty
                          ? "A delicious dish prepared with care. Perfect for gatherings, daily meals, and anyone who enjoys great taste."
                          : widget.recipe.description,
                      style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.45),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoChip(
                          icon: Icons.timer_outlined,
                          text: "${widget.recipe.cookingTime} minutes",
                          title: 'cook time',
                        ),
                        InfoChip(
                          icon: Icons.restaurant,
                          text: "${widget.recipe.servingPeople} serving",
                          title: 'serves',
                        ),
                        InfoChip(icon: Icons.flag_outlined, text: widget.recipe.regions, title: 'origin'),
                      ],
                    ),

                    if (isOwner) ...[
                      const SizedBox(height: 16),
                      PublishedStatus(
                        recipeId: widget.recipe.id,
                        homeController: homeController,
                        createRecipeController: createRecipeController,
                      ),
                    ],

                    const SizedBox(height: 22),

                    const Text("Ingredients:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.recipe.ingredients.length,
                      itemBuilder: (context, index) {
                        return IngredientItem(index: index, text: widget.recipe.ingredients[index].description);
                      },
                    ),

                    const SizedBox(height: 24),

                    const Text("Instructions:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemCount: widget.recipe.steps.length,
                      itemBuilder: (context, index) {
                        return InstructionItem(index: index, text: widget.recipe.steps[index].description);
                      },
                    ),

                    const SizedBox(height: 16),

                    RatingLikeSection(
                      recipe: widget.recipe,
                      discoverController: discoverController,
                      controller: recipeDetailController,
                    ),

                    const SizedBox(height: 16),

                    BuildComment(recipeDetailController: recipeDetailController, widget: widget),

                    const SizedBox(height: 16),

                    SimilarRecipes(recipes: similar, authors: homeController.authors),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingLikeButton(
          recipeDetailController: recipeDetailController,
          recipeId: widget.recipe.id,
          userId: discoverController.userId!,
        ),
      ),
    );
  }
}
