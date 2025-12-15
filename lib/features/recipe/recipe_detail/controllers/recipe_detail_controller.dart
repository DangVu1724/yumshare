import 'dart:async';

import 'package:get/get.dart';
import 'package:yumshare/models/comment.dart';
import 'package:yumshare/models/comment_sort_type.dart';
import 'package:yumshare/repository/comment_repo.dart';
import 'package:yumshare/repository/recipe_repository.dart';

class RecipeDetailController extends GetxController {
  final CommentRepo commentRepo = CommentRepo();
  final RecipeRepository recipeRepo = RecipeRepository();

  // COMMENTS
  List<Comment> rawComments = [];
  RxList<Comment> comments = <Comment>[].obs;
  Rx<CommentSortType> sortType = CommentSortType.top.obs;

  StreamSubscription<List<Comment>>? _commentSub;

  // RECIPE LIKE
  RxInt recipeLikes = 0.obs;
  RxSet<String> likedBy = <String>{}.obs;
  StreamSubscription? _recipeLikeSub;

  // ---------------- INIT ----------------
  void initWithRecipe(String recipeId) {
    _commentSub?.cancel();
    _recipeLikeSub?.cancel();

    _commentSub = commentRepo.getComments(recipeId).listen((data) {
      rawComments = data;
      _applySort();
    });

    _recipeLikeSub = recipeRepo.recipeLikeStream(recipeId).listen((data) {
      recipeLikes.value = data['likesCount'] ?? 0;
      likedBy.value = Set<String>.from(data['likedBy'] ?? []);
    });
  }

  // ---------------- COMMENT ----------------
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
    final sorted = List<Comment>.from(rawComments);

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

  // ---------------- COMMENT LIKE ----------------
  void toggleLikeComment({required String recipeId, required String commentId, required String currentUserId}) async {
    final index = comments.indexWhere((c) => c.id == commentId);
    if (index == -1) return;

    final comment = comments[index];
    final isLiked = comment.likedBy.contains(currentUserId);

    // optimistic
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
    } catch (_) {
      // rollback
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

  // ---------------- RECIPE LIKE ----------------
  bool isLiked(String currentUserId) {
    return likedBy.contains(currentUserId);
  }

  int getLikeCount() {
    return recipeLikes.value;
  }

  Future<void> toggleLike({required String recipeId, required String currentUserId}) async {
    final isLikedNow = likedBy.contains(currentUserId);

    if (isLikedNow) {
      likedBy.remove(currentUserId);
      recipeLikes.value--;
    } else {
      likedBy.add(currentUserId);
      recipeLikes.value++;
    }
    likedBy.refresh();

    try {
      await recipeRepo.toggleLike(recipeId: recipeId, userId: currentUserId, isLiked: isLikedNow);
    } catch (_) {
      if (isLikedNow) {
        likedBy.add(currentUserId);
        recipeLikes.value++;
      } else {
        likedBy.remove(currentUserId);
        recipeLikes.value--;
      }
      likedBy.refresh();
    }
  }

  // ---------------- CLEAN ----------------
  @override
  void onClose() {
    _commentSub?.cancel();
    _recipeLikeSub?.cancel();
    super.onClose();
  }
}
