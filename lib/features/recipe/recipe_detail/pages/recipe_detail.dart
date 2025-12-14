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
      tutorialCoachMark.finish();
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
                // Bookmark button - Hiển thị cho tất cả users
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

                // Publish/Share button - CHỈ hiển thị cho OWNER
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

                // Share button - Hiển thị cho tất cả users (trừ owner đã có publish button)
                if (!isOwner)
                  IconButton(
                    icon: Icon(Icons.share, color: isCollapsed ? Colors.black : Colors.white),
                    onPressed: () {
                      _shareRecipe();
                    },
                  ),

                // Info button - Hiển thị cho tất cả users
                IconButton(
                  icon: Icon(Icons.info, color: isCollapsed ? Colors.black : Colors.white),
                  onPressed: () {
                    _showRecipeInfo();
                  },
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

                    // ======== PHẦN RATING VÀ LIKE ========
                    const SizedBox(height: 12),
                    _buildRatingAndLikeSection(),

                    // =====================================
                    const SizedBox(height: 20),

                    /// Author Section
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
                        if (isOwner)
                          ElevatedButton(
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
                        else
                          ElevatedButton(
                            onPressed: () {
                              // Follow user logic
                              // homeController.toggleFollow(widget.user.id);
                            },
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

                    // ======== PUBLISHED STATUS - CHỈ HIỂN THỊ CHO OWNER ========
                    if (isOwner) Column(children: [const SizedBox(height: 16), _buildPublishedStatus()]),

                    // ===========================================================
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

        // ======== FLOATING ACTION BUTTON CHO LIKE ========
        floatingActionButton: _buildFloatingLikeButton(),
        // ======================================================
      ),
    );
  }

  // ======== WIDGET MỚI: PHẦN RATING VÀ LIKE ========
  Widget _buildRatingAndLikeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rating Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Rating',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Star Rating
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < (widget.recipe.rating).floor() ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    // Rating Text
                    Text(
                      widget.recipe.rating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    Text('(${widget.recipe.ratingCount})', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 4),
                // Rate this recipe button
                TextButton(
                  onPressed: () {
                    // TODO: Mở dialog đánh giá
                    _showRatingDialog();
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  child: Text(
                    'Rate this recipe',
                    style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // Vertical Divider
          Container(
            width: 1,
            height: 60,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          // Like Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_rounded, color: Colors.red.shade400, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Likes',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Like Count
                Obx(() {
                  final isLiked = recipeDetailController.isLiked(widget.recipe.id);
                  final likeCount = recipeDetailController.getLikeCount();

                  return Row(
                    children: [
                      Text(
                        '$likeCount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isLiked ? Colors.red.shade500 : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('likes', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  );
                }),
                const SizedBox(height: 4),
                // Like button
                Obx(() {
                  final isLiked = recipeDetailController.isLiked(widget.recipe.id);

                  return TextButton(
                    onPressed: () {
                      recipeDetailController.toggleLike(
                        recipeId: widget.recipe.id,
                        currentUserId: discoverController.userId!,
                      );
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    child: Text(
                      isLiked ? 'Unlike' : 'Like this recipe',
                      style: TextStyle(
                        fontSize: 13,
                        color: isLiked ? Colors.red.shade500 : AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======== WIDGET HIỂN THỊ PUBLISHED STATUS (CHỈ CHO OWNER) ========
  Widget _buildPublishedStatus() {
    final isOwner = widget.recipe.authorId == discoverController.userId;

    return Obx(() {
      final isPublished = homeController.isPublished(widget.recipe.id);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isPublished ? Colors.green.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isPublished ? Colors.green.shade200 : Colors.orange.shade200, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              isPublished ? Icons.public : Icons.lock_outline,
              color: isPublished ? Colors.green : Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPublished ? 'Published' : 'Private',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPublished ? Colors.green.shade800 : Colors.orange.shade800,
                    ),
                  ),
                  Text(
                    isPublished ? 'This recipe is visible to everyone' : 'Only you can see this recipe',
                    style: TextStyle(fontSize: 12, color: isPublished ? Colors.green.shade600 : Colors.orange.shade600),
                  ),
                ],
              ),
            ),
            if (isOwner)
              TextButton(
                onPressed: () async {
                  await createRecipeController.togglePublishedRecipe(widget.recipe.id);
                  homeController.togglePublished(widget.recipe.id);
                },
                child: Text(
                  isPublished ? 'Make Private' : 'Publish',
                  style: TextStyle(
                    color: isPublished ? Colors.green.shade700 : AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  // ======== FLOATING ACTION BUTTON CHO LIKE ========
  Widget _buildFloatingLikeButton() {
    return Obx(() {
      final isLiked = recipeDetailController.isLiked(widget.recipe.id);

      return FloatingActionButton(
        onPressed: () {
          recipeDetailController.toggleLike(recipeId: widget.recipe.id, currentUserId: discoverController.userId!);
        },
        backgroundColor: isLiked ? Colors.red.shade500 : Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(
          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isLiked ? Colors.white : Colors.red.shade400,
          size: 28,
        ),
      );
    });
  }

  // ======== RATING DIALOG ========
  void _showRatingDialog() {
    double selectedRating = widget.recipe.rating;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rate this Recipe'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  // Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1.0;
                          });
                        },
                        icon: Icon(
                          index < selectedRating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 40,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${selectedRating.toStringAsFixed(1)} stars',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedRating >= 4
                        ? 'Excellent! ⭐'
                        : selectedRating >= 3
                        ? 'Good! 👍'
                        : selectedRating >= 2
                        ? 'Fair 👌'
                        : 'Could be better 👎',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setState(() => isSubmitting = true);
                          // TODO: Gửi đánh giá lên server
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() => isSubmitting = false);
                          // CustomToast.show(context, 'Rating submitted!');
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Submit Rating'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ======== SHARE RECIPE FUNCTION ========
  void _shareRecipe() {
    // Logic chia sẻ recipe
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Share Recipe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _shareOption(Icons.share, 'Share Link', Colors.blue),
                  _shareOption(Icons.copy, 'Copy Link', Colors.green),
                  _shareOption(Icons.message, 'Message', Colors.purple),
                  _shareOption(Icons.more_horiz, 'More', Colors.grey),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _shareOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          radius: 30,
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  // ======== SHOW RECIPE INFO ========
  void _showRecipeInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recipe Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Created', '${widget.recipe.createdAt.toLocal()}'),
              _infoRow('Last Updated', '${widget.recipe.updatedAt.toLocal()}'),
              _infoRow('Category', widget.recipe.category),
              _infoRow('ID', widget.recipe.id),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // ======== CÁC WIDGET CŨ GIỮ NGUYÊN ========
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
