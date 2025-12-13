import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/features/profile/controllers/profile_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';
import 'package:yumshare/features/recipe/recipe_detail/widgets/comment_item.dart';
import 'package:yumshare/models/comment_sort_type.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class CommentsPage extends StatefulWidget {
  final String recipeId;

  const CommentsPage({super.key, required this.recipeId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final RecipeDetailController recipeDetailController = Get.find<RecipeDetailController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final AuthService auth = AuthService();
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          // Sort tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _sortTab(label: 'Top', type: CommentSortType.top),
                const SizedBox(width: 8),
                _sortTab(label: 'Oldest', type: CommentSortType.oldest),
                const SizedBox(width: 8),
                _sortTab(label: 'Newest', type: CommentSortType.newest),
              ],
            ),
          ),

          // Comments list
          Expanded(
            child: Obx(() {
              if (recipeDetailController.comments.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.comment_outlined, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No comments yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Be the first to comment!', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recipeDetailController.comments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final comment = recipeDetailController.comments[index];
                  return CommentItem(comment: comment,controler: recipeDetailController,);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildInputBar(),
    );
  }

  Widget _sortTab({required String label, required CommentSortType type}) {
    return Obx(() {
      final isActive = recipeDetailController.sortType.value == type;

      return GestureDetector(
        onTap: () => recipeDetailController.changeSort(type),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white,
            border: Border.all(color: isActive ? Colors.white : AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(36),
          ),
          child: Text(
            label,
            style: TextStyle(color: isActive ? Colors.white : AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
      );
    });
  }

  Widget _buildInputBar() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 8),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage('assets/images/avatar1.png'), radius: 24),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: IconButton(
                      icon: FaIcon(FontAwesomeIcons.solidPaperPlane, color: AppColors.primary, size: 16),
                      onPressed: () {
                        final text = _commentController.text.trim();
                        if (text.isEmpty) return;

                        recipeDetailController.addComment(
                          recipeId: widget.recipeId,
                          userId: auth.currentUser!.uid,
                          userName: profileController.userData.value!.name,
                          content: text,
                        );

                        _commentController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
