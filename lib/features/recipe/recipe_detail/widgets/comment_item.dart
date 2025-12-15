import 'package:flutter/material.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/recipe_detail_controller.dart';
import 'package:yumshare/models/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final RecipeDetailController controler;
  const CommentItem({super.key, required this.comment, required this.controler});

  @override
  Widget build(BuildContext context) {
    final currentUserId = AuthService().currentUser!.uid;
    final isLiked = comment.likedBy.contains(currentUserId);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row avatar + name + time
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: Text(comment.userId.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 10),
              Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Text(_formatTime(comment.createdAt), style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),

          const SizedBox(height: 15),

          // Content thẳng avatar
          Text(comment.content, style: TextStyle(fontSize: 15)),

          const SizedBox(height: 10),

          // Actions thẳng avatar, icon sát gọn
          Row(
            children: [
              InkWell(
                onTap: () {
                  controler.toggleLikeComment(
                    recipeId: comment.recipeId,
                    commentId: comment.id,
                    currentUserId: currentUserId,
                  );
                },
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isLiked ? Colors.red : Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              Text('${comment.likesCount}'),
              const SizedBox(width: 16),
              InkWell(onTap: () {}, child: const Icon(Icons.reply, size: 18)),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inHours < 1) return '${difference.inMinutes}m ago';
  if (difference.inDays < 1) return '${difference.inHours}h ago';
  if (difference.inDays < 30) return '${difference.inDays}d ago';

  return '${time.day}/${time.month}/${time.year}';
}
