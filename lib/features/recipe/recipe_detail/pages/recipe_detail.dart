import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  final Users user;

  const RecipeDetailPage({required this.recipe, required this.user, super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
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
                IconButton(
                  icon: Icon(Icons.bookmark_border, color: isCollapsed ? Colors.black : Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.paperPlane, color: isCollapsed ? Colors.black : Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.info, color: isCollapsed ? Colors.black : Colors.white),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network("${widget.recipe.imageUrl}", fit: BoxFit.cover),
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
                        CircleAvatar(radius: 22, backgroundImage: AssetImage("assets/images/avatar1.png")),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(widget.user.email, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                          ),
                          child: Text("Follow"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      widget.recipe.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.45),
                    ),

                    const SizedBox(height: 18),

                    /// Info Chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoChip(Icons.timer_outlined, "10 mins"),
                        _infoChip(Icons.restaurant, "1 serving"),
                        _infoChip(Icons.flag_outlined, widget.recipe.regions),
                      ],
                    ),

                    const SizedBox(height: 22),

                    Text("Ingredients:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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

                    Text("Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    ListView.builder(
                      shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.recipe.steps.length,
                      itemBuilder: (context, index) {
                        final item = widget.recipe.steps[index];
                        return _instructionItem(index, item.description);
                      },
                    ),

                    const SizedBox(height: 16),

                    /// Ảnh step
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _stepImg("assets/images/step1.png"),
                          _stepImg("assets/images/step2.png"),
                          _stepImg("assets/images/step3.png"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[100]),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          SizedBox(width: 6),
          Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
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
              "$index",
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
          backgroundColor: AppColors.primary,
          child: Text(
            "$index",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(fontSize: 15, height: 1.5))),
      ],
    );
  }

  Widget _stepImg(String path) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
      ),
    );
  }
}
