import 'dart:async';

import 'package:get/get.dart';
import 'package:yumshare/models/comment.dart';
import 'package:yumshare/models/comment_sort_type.dart';
import 'package:yumshare/repository/comment_repo.dart';

class RecipeDetailController extends GetxController {
  final CommentRepo commentRepo = CommentRepo();

  List<Comment> rawComments = [];
  RxList<Comment> comments = <Comment>[].obs;
  Rx<CommentSortType> sortType = CommentSortType.top.obs;

  StreamSubscription<List<Comment>>? _sub;

  void initWithRecipe(String recipeId) {
    _sub?.cancel();

    _sub = commentRepo.getComments(recipeId).listen((data) {
      rawComments = data;
      _applySort();
    });
  }

  Future<void> addComment({
    required String recipeId,
    required String userId,
    required String userName,
    required String content,
  }) async {
    await commentRepo.addComment(recipeId: recipeId, userId: userId, userName: userName, content: content);
  }

  void changeSort(CommentSortType type) {
    sortType.value = type;
    _applySort();
  }

  void _applySort() {
    List<Comment> sorted = List.from(rawComments);

    switch (sortType.value) {
      case CommentSortType.oldest:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;

      case CommentSortType.newest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case CommentSortType.top:
        sorted.sort((a, b) => b.likesCount.compareTo(a.likesCount));
        break;
    }

    comments.value = sorted;
  }

  void toggleLikeComment({required String recipeId, required String commentId, required String currentUserId}) async {
    final index = comments.indexWhere((c) => c.id == commentId);
    if (index == -1) return;

    final comment = comments[index];
    final isLiked = comment.likedBy.contains(currentUserId);

    // 🔥 Optimistic update
    if (isLiked) {
      comment.likedBy.remove(currentUserId);
      comment.likesCount--;
    } else {
      comment.likedBy.add(currentUserId);
      comment.likesCount++;
    }

    comments[index] = comment;
    comments.refresh();

    try {
      await commentRepo.toggleLike(recipeId: recipeId, commentId: commentId, userId: currentUserId, isLiked: isLiked);
    } catch (e) {
      // ❌ rollback nếu lỗi
      if (isLiked) {
        comment.likedBy.add(currentUserId);
        comment.likesCount++;
      } else {
        comment.likedBy.remove(currentUserId);
        comment.likesCount--;
      }

      comments[index] = comment;
      comments.refresh();
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
