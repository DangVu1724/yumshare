import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/pages/recipe_detail.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/comment_item.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class BuildComment extends StatelessWidget {
  const BuildComment({super.key, required this.recipeDetailController, required this.widget});

  final RecipeDetailController recipeDetailController;
  final RecipeDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasComments = recipeDetailController.comments.isNotEmpty;

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments (${recipeDetailController.comments.length})',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              if (hasComments)
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.comments, arguments: widget.recipe.id);
                  },
                  icon: Icon(Icons.arrow_forward),
                  color: AppColors.primary,
                ),
            ],
          ),

          if (hasComments)
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recipeDetailController.comments.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final c = recipeDetailController.comments[index];
                return CommentItem(comment: c, controler: recipeDetailController);
              },
            ),

          if (!hasComments)
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.mode_comment_outlined, size: 60, color: Colors.grey[400]),
                  SizedBox(height: 10),
                  Text('Chưa có bình luận nào', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  SizedBox(height: 5),
                  Text('Hãy là người đầu tiên bình luận!', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                ],
              ),
            ),

          SizedBox(height: 16),

          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage('assets/images/avatar1.png'), radius: 28),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.comments, arguments: widget.recipe.id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: Colors.grey[200]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Viết bình luận...', style: TextStyle(color: Colors.grey[600])),
                        FaIcon(FontAwesomeIcons.solidPaperPlane, size: 14, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
