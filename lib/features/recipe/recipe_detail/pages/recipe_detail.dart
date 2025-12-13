import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/comment_section.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

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

  @override
  void initState() {
    super.initState();
    similar = discoverController.getSimilarRecipes(widget.recipe);
    recipeDetailController.initWithRecipe(widget.recipe.id);

    createTutorial();
    Future.delayed(Duration.zero, () {
      tutorialCoachMark.show(context: context);
    });
    Future.delayed(Duration(seconds: 3), () {
      tutorialCoachMark.finish(); // đóng tutorial
    });
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "publish_icon",
          keyTarget: publishKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Tap here to publish your recipe and let more people see it!",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ],
      colorShadow: Colors.black54,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () => print("Tutorial finished"),
    );
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
                Obx(() {
                  final isFav = homeController.isFavorite(widget.recipe.id);

                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.bookmark : Icons.bookmark_border,
                      color: isFav ? AppColors.primary : (isCollapsed ? Colors.black : Colors.white),
                    ),
                    onPressed: () {
                      homeController.toggleFavorite(widget.recipe.id);
                      // CustomToast.show(
                      //   context,
                      //   homeController.isFavorite(widget.recipe.id) ? "Added to Bookmark" : "Removed",
                      // );
                    },
                  );
                }),

                Obx(() {
                  final isPublished = homeController.isPublished(widget.recipe.id);

                  return IconButton(
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

                IconButton(
                  icon: Icon(Icons.info, color: isCollapsed ? Colors.black : Colors.white),
                  onPressed: () {},
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
                    Text(widget.recipe.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3)),
                    const SizedBox(height: 20),

                    /// Author
                    Row(
                      children: [
                        CircleAvatar(radius: 34, backgroundImage: AssetImage("assets/images/avatar1.png")),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(widget.user.email, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                        Spacer(),
                        isOwner
                            ? ElevatedButton(
                                onPressed: () {
                                  Get.toNamed(Routes.editRecipe, arguments: widget.recipe);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                                ),
                                child: const Text("Edit", style: TextStyle(color: Colors.white)),
                              )
                            : ElevatedButton(
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
                      (widget.recipe.description.trim().isEmpty)
                          ? "A delicious dish prepared with care. Perfect for gatherings, daily meals, and anyone who enjoys great taste."
                          : widget.recipe.description,
                      style: TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.45),
                    ),

                    const SizedBox(height: 18),

                    /// Info Chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoChip(Icons.timer_outlined, "${widget.recipe.cookingTime} minutes", 'cook time'),
                        _infoChip(Icons.restaurant, "${widget.recipe.servingPeople} serving", 'serves'),
                        _infoChip(Icons.flag_outlined, widget.recipe.regions, 'origin'),
                      ],
                    ),

                    const SizedBox(height: 22),

                    Text("Ingredients:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),

                    /// Ingredients List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.recipe.ingredients.length,
                      itemBuilder: (context, index) {
                        final item = widget.recipe.ingredients[index];
                        return _ingredientItem(index, item.description);
                      },
                    ),
                    const SizedBox(height: 24),

                    Text("Instructions:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemCount: widget.recipe.steps.length,
                      itemBuilder: (context, index) {
                        final item = widget.recipe.steps[index];
                        return _instructionItem(index, item.description);
                      },
                    ),

                    const SizedBox(height: 16),

                    BuildComment(recipeDetailController: recipeDetailController, widget: widget),
                    const SizedBox(height: 16),

                    _similarRecipes(similar),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 250, 233, 238),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ],
          ),
          Text(title, style: TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _ingredientItem(int index, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary.withOpacity(0.15),
            child: Text(
              "${index + 1}",
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _instructionItem(int index, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primary.withOpacity(0.15),
          child: Text(
            "${index + 1}",
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(fontSize: 15, height: 1.5))),
      ],
    );
  }

  Widget _similarRecipes(List<Recipe> recipes) {
    final authors = homeController.authors;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('More Recipes Like This', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward)),
          ],
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final author = authors[recipe.authorId]!;
              return RecipeCard(recipe: recipe, author: author);
            },
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemCount: recipes.length,
          ),
        ),
      ],
    );
  }
}
